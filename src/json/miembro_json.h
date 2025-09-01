#include "../model/miembro.h"
#include <cjson/cJSON.h>

cJSON* miembro_into_json(miembro *obj);
miembro* miembro_from_json(const char *json_str);
