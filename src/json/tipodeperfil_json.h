#include "../model/tipodeperfil.h"
#include <cjson/cJSON.h>

cJSON* tipodeperfil_into_json(tipodeperfil *obj);
tipodeperfil* tipodeperfil_from_json(const char *json_str);
