#include "../model/sexo.h"
#include <cjson/cJSON.h>

cJSON* sexo_into_json(sexo *obj);
sexo* sexo_from_json(const char *json_str);
