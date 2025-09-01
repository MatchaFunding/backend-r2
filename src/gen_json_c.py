#!/usr/bin/env python3
import re
import os
import sys

SQL_TO_C = {
    "bigint": "long long",
    "int": "int",
    "varchar": "char",   # with [N]
    "date": "char[11]",  # YYYY-MM-DD
    "text": "char*",     # dynamic
    "float": "float",
    "double": "double"
}

def sql_to_c_type(sql_type):
    sql_type = sql_type.lower().strip()
    match = re.match(r"(varchar|char)\((\d+)\)", sql_type)
    if match:
        base, size = match.groups()
        return f"char[{int(size)+1}]"
    for key in SQL_TO_C:
        if sql_type.startswith(key):
            return SQL_TO_C[key]
    return "char*"

def extract_tables(sql_text):
    tables = {}
    create_table_pattern = re.compile(
        r"CREATE TABLE\s+(\w+)\s*\((.*?)\);",
        re.S | re.I
    )
    for match in create_table_pattern.finditer(sql_text):
        table_name = match.group(1).lower()
        body = match.group(2)
        columns = []
        for line in body.split(","):
            line = line.strip()
            if not line or line.upper().startswith(("PRIMARY", "FOREIGN", "UNIQUE", "KEY")):
                continue
            parts = line.split()
            col_name = parts[0].strip("`")
            col_type = parts[1]
            c_type = sql_to_c_type(col_type)
            columns.append((col_name, c_type))
        tables[table_name] = columns
    return tables

def generate_header(table, columns):
    h_lines = []
    #h_lines.append("#pragma once")
    h_lines.append('#include "../model/{}.h"'.format(table))
    h_lines.append("#include <cjson/cJSON.h>")
    h_lines.append("")
    h_lines.append(f"cJSON* {table}_into_json({table} *obj);")
    h_lines.append(f"{table}* {table}_from_json(const char *json_str);")
    h_lines.append("")
    return "\n".join(h_lines)

def generate_source(table, columns):
    c_lines = []
    c_lines.append('#include <stdio.h>')
    c_lines.append('#include <stdlib.h>')
    c_lines.append('#include <string.h>')
    c_lines.append('#include <cjson/cJSON.h>')
    c_lines.append(f'#include "{table}_json.h"')
    c_lines.append("")

    # into_json
    c_lines.append(f"cJSON* {table}_into_json({table} *obj) {{")
    c_lines.append("    if (!obj) return NULL;")
    c_lines.append("    cJSON *json = cJSON_CreateObject();")
    for col, ctype in columns:
        if ctype.startswith("char["):
            c_lines.append(f'    cJSON_AddStringToObject(json, "{col}", obj->{col});')
        elif ctype == "char*":
            c_lines.append(f'    if (obj->{col}) cJSON_AddStringToObject(json, "{col}", obj->{col});')
        elif ctype in ("int", "long long"):
            c_lines.append(f'    cJSON_AddNumberToObject(json, "{col}", obj->{col});')
        elif ctype in ("float", "double"):
            c_lines.append(f'    cJSON_AddNumberToObject(json, "{col}", obj->{col});')
        else:
            c_lines.append(f'    // Unsupported type for {col}, skipping')
    c_lines.append("    return json;")
    c_lines.append("}")
    c_lines.append("")

    # from_json
    c_lines.append(f"{table}* {table}_from_json(const char *json_str) {{")
    c_lines.append("    if (!json_str) return NULL;")
    c_lines.append("    cJSON *json = cJSON_Parse(json_str);")
    c_lines.append("    if (!json) return NULL;")
    c_lines.append(f"    {table} *obj = malloc(sizeof({table}));")
    c_lines.append("    if (!obj) { cJSON_Delete(json); return NULL; }")
    for col, ctype in columns:
        if ctype.startswith("char["):
            c_lines.append(f'    cJSON *j_{col} = cJSON_GetObjectItemCaseSensitive(json, "{col}");')
            c_lines.append(f'    if (cJSON_IsString(j_{col}) && (j_{col}->valuestring != NULL)) {{')
            c_lines.append(f'        strncpy(obj->{col}, j_{col}->valuestring, sizeof(obj->{col})-1);')
            c_lines.append(f'        obj->{col}[sizeof(obj->{col})-1] = \'\\0\';')
            c_lines.append("    } else { obj->{col}[0] = '\\0'; }".replace("{col}", col))
        elif ctype == "char*":
            c_lines.append(f'    cJSON *j_{col} = cJSON_GetObjectItemCaseSensitive(json, "{col}");')
            c_lines.append(f'    if (cJSON_IsString(j_{col}) && (j_{col}->valuestring != NULL)) {{')
            c_lines.append(f'        obj->{col} = strdup(j_{col}->valuestring);')
            c_lines.append("    } else { obj->{col} = NULL; }")
        elif ctype in ("int", "long long", "float", "double"):
            c_lines.append(f'    cJSON *j_{col} = cJSON_GetObjectItemCaseSensitive(json, "{col}");')
            c_lines.append(f'    if (cJSON_IsNumber(j_{col})) obj->{col} = j_{col}->valuedouble;')
            c_lines.append(f'    else obj->{col} = 0;')
    c_lines.append("    cJSON_Delete(json);")
    c_lines.append("    return obj;")
    c_lines.append("}")
    c_lines.append("")

    return "\n".join(c_lines)

def main():
    if len(sys.argv) < 2:
        print("Usage: python gen_json_c.py database.sql")
        sys.exit(1)

    sql_file = sys.argv[1]
    with open(sql_file, "r", encoding="utf-8") as f:
        sql_text = f.read()

    os.makedirs("json", exist_ok=True)
    tables = extract_tables(sql_text)

    for table, columns in tables.items():
        h_code = generate_header(table, columns)
        c_code = generate_source(table, columns)
        with open(f"json/{table}_json.h", "w") as f:
            f.write(h_code)
        with open(f"json/{table}_json.c", "w") as f:
            f.write(c_code)
        print(f"Generated json/{table}_json.h and json/{table}_json.c")

if __name__ == "__main__":
    main()

