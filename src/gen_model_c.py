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

# Generates a C struct by parsing the database dump file in .sql
def generate_struct(table, columns):
    struct_lines = [f"typedef struct {{"]
    for col, ctype in columns:
        struct_lines.append(f"    {ctype} {col};")
    struct_lines.append(f"}} {table};\n")
    return "\n".join(struct_lines)

# Simple Python script that reads a MariaDB database dump and generated
# C structs for backend manipulation
def main():
    if len(sys.argv) < 2:
        print("Usage: python gen_structs_c.py database.sql")
        sys.exit(1)
    sql_file = sys.argv[1]
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_text = f.read()
    os.makedirs("model", exist_ok=True)
    tables = extract_tables(sql_text)
    for table, columns in tables.items():
        struct_code = generate_struct(table, columns)
        file_path = os.path.join("model", f"{table.lower()}.h")
        with open(file_path, "w") as f:
            f.write(struct_code)
        print(f"Generated {file_path}")

if __name__ == "__main__":
    main()
