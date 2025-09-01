#include "../model/region.h"
#include <cjson/cJSON.h>

cJSON* region_into_json(region *obj);
region* region_from_json(const char *json_str);
