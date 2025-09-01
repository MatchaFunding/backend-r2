#include "../model/tipodepersona.h"
#include <cjson/cJSON.h>

cJSON* tipodepersona_into_json(tipodepersona *obj);
tipodepersona* tipodepersona_from_json(const char *json_str);
