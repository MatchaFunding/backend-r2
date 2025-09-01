#include "../model/usuario.h"
#include <cjson/cJSON.h>

cJSON* usuario_into_json(usuario *obj);
usuario* usuario_from_json(const char *json_str);
