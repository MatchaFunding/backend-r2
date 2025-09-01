#include "../model/tipodeempresa.h"
#include <cjson/cJSON.h>

cJSON* tipodeempresa_into_json(tipodeempresa *obj);
tipodeempresa* tipodeempresa_from_json(const char *json_str);
