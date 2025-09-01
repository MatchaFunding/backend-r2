#include "../model/colaborador.h"
#include <cjson/cJSON.h>

cJSON* colaborador_into_json(colaborador *obj);
colaborador* colaborador_from_json(const char *json_str);
