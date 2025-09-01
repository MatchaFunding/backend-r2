#include "../model/instrumento.h"
#include <cjson/cJSON.h>

cJSON* instrumento_into_json(instrumento *obj);
instrumento* instrumento_from_json(const char *json_str);
