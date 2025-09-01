#include "../model/tipodebeneficio.h"
#include <cjson/cJSON.h>

cJSON* tipodebeneficio_into_json(tipodebeneficio *obj);
tipodebeneficio* tipodebeneficio_from_json(const char *json_str);
