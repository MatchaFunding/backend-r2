import re
import os
import sys

# Dictionary for converting from MySQL types to C types
SQL_TO_C = {
    "bigint": "long long",
    "int": "int",
    "varchar": "char",   # Will append [N]
    "date": "char",  # store as string "YYYY-MM-DD"
    "text": "char*",     # dynamic
    "float": "float",
    "double": "double"
}

# Determines the equivalent C type of a variable using regular expressions
def sql_to_c_type(sql_type):
    sql_type = sql_type.lower().strip()
    match = re.match(r"(varchar|char)\((\d+)\)", sql_type)
    if match:
        return f"char"
    for key in SQL_TO_C:
        if sql_type.startswith(key):
            return SQL_TO_C[key]
    return "char*"

# Determines the length of a character array using regular expressions
def sql_to_c_size(sql_type):
    sql_type = sql_type.lower().strip()
    match = re.match(r"(varchar|char)\((\d+)\)", sql_type)
    if match:
        _, size = match.groups()
        return f"[{int(size)}]"
    match = re.match(r"(date|datetime)\((\d+)\)", sql_type)
    if match:
        _, size = match.groups()
        return f"[10]"
    return ""

# Extracts the tables from a table definition
def extract_tables(sql_text):
    tables = {}
    create_table_pattern = re.compile(
        r"CREATE TABLE\s+(\w+)\s*\((.*?)\);",
        re.S | re.I
    )
    for match in create_table_pattern.finditer(sql_text):
        table_name = match.group(1)
        body = match.group(2)
        columns = []
        for line in body.split(","):
            line = line.strip()
            if not line or line.upper().startswith(("PRIMARY", "FOREIGN", "UNIQUE", "KEY")):
                continue
            parts = line.split()
            col_type = parts[1]
            c_size = sql_to_c_size(col_type)
            col_name = parts[0].strip("`") + c_size
            c_type = sql_to_c_type(col_type)
            columns.append((col_name, c_type))
        tables[table_name] = columns
    return tables

def generate_files(table, columns):
    struct_name = table
    header_file = os.path.join("sql", f"{table.lower()}_sql.h")
    source_file = os.path.join("sql", f"{table.lower()}_sql.c")
    with open(header_file, "w") as h:
        h.write(f"#ifndef {table.upper()}_SQL_H\n")
        h.write(f"#define {table.upper()}_SQL_H\n\n")
        h.write("#include <mysql.h>\n")
        h.write("#include <stdlib.h>\n")
        h.write("#include <string.h>\n")
        h.write("\n")
        h.write(f"{struct_name}* ViewALL{table}(int* count);\n")
        h.write(f"{struct_name} Create{table}(")
        h.write(", ".join(f"{sql_to_c_type(t)} {c}" for c, t in columns if c.lower() != "id"))
        h.write(");\n")
        h.write(f"{struct_name} Obtain{table}(int id);\n")
        h.write(f"{struct_name} Modify{table}(")
        h.write(", ".join(f"{sql_to_c_type(t)} {c}" for c, t in columns))
        h.write(");\n")
        h.write(f"void Delete{table}(int id);\n\n")
        h.write("#endif\n")

    with open(source_file, "w") as c:
        c.write(f"#include \"{table.lower()}_sql.h\"\n\n")
        c.write("MYSQL* get_connection() {\n")
        c.write("    MYSQL *conn = mysql_init(NULL);\n")
        c.write("    const char* db = getenv(\"MATCHA_MYSQL\");\n")
        c.write("    const char* user = getenv(\"MATCHA_USER\");\n")
        c.write("    const char* pass = getenv(\"MATCHA_PASS\");\n")
        c.write("    if (!mysql_real_connect(conn, \"localhost\", user, pass, db, 0, NULL, 0)) {\n")
        c.write("        fprintf(stderr, \"Connection failed: %s\\n\", mysql_error(conn));\n")
        c.write("        exit(1);\n")
        c.write("    }\n")
        c.write("    return conn;\n")
        c.write("}\n\n")

        # view_all
        c.write(f"{struct_name}* ViewAll{table}(int* count) {{\n")
        c.write("    MYSQL* conn = get_connection();\n")
        c.write(f"    if (mysql_query(conn, \"SELECT * FROM {table};\")) {{\n")
        c.write("        fprintf(stderr, \"%s\\n\", mysql_error(conn));\n")
        c.write("    }\n")
        c.write("    MYSQL_RES *res = mysql_store_result(conn);\n")
        c.write("    *count = mysql_num_rows(res);\n")
        c.write(f"    {struct_name}* arr = malloc(sizeof({struct_name}) * (*count));\n")
        c.write("    MYSQL_ROW row;\n")
        c.write("    int i = 0;\n")
        c.write("    while ((row = mysql_fetch_row(res))) {\n")
        for idx, (col, ctype) in enumerate(columns):
            if "char*" in sql_to_c_type(ctype):
                c.write(f"        arr[i].{col} = strdup(row[{idx}]);\n")
            else:
                c.write(f"        arr[i].{col} = atoi(row[{idx}]);\n")
        c.write("        i++;\n")
        c.write("    }\n")
        c.write("    mysql_free_result(res);\n")
        c.write("    mysql_close(conn);\n")
        c.write("    return arr;\n")
        c.write("}\n\n")

        # obtain
        c.write(f"{struct_name} Obtain{table}(int id) {{\n")
        c.write(f"    {struct_name} obj;\n")
        c.write("    MYSQL* conn = get_connection();\n")
        c.write("    char query[256];\n")
        c.write(f"    sprintf(query, \"SELECT * FROM {table} WHERE ID=%d;\", id);\n")
        c.write("    mysql_query(conn, query);\n")
        c.write("    MYSQL_RES* res = mysql_store_result(conn);\n")
        c.write("    MYSQL_ROW row = mysql_fetch_row(res);\n")
        for idx, (col, ctype) in enumerate(columns):
            if "char*" in sql_to_c_type(ctype):
                c.write(f"    obj.{col} = strdup(row[{idx}]);\n")
            else:
                c.write(f"    obj.{col} = atoi(row[{idx}]);\n")
        c.write("    mysql_free_result(res);\n")
        c.write("    mysql_close(conn);\n")
        c.write("    return obj;\n")
        c.write("}\n\n")

        # delete
        c.write(f"void Delete{table}(int id) {{\n")
        c.write("    MYSQL* conn = get_connection();\n")
        c.write("    char query[256];\n")
        c.write(f"    sprintf(query, \"DELETE FROM {table} WHERE ID=%d;\", id);\n")
        c.write("    mysql_query(conn, query);\n")
        c.write("    mysql_close(conn);\n")
        c.write("}\n")

def main():
    if len(sys.argv) < 2:
        print("Usage: python gen_structs_c.py database.sql")
        sys.exit(1)
    sql_file = sys.argv[1]
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_text = f.read()
    os.makedirs("sql", exist_ok=True)
    tables = extract_tables(sql_text)
    for table, columns in tables.items():
        generate_files(table, columns)

if __name__ == "__main__":
    main()

