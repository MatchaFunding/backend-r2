#include <cjson/cJSON.h>
#include "../model/region.h"

cJSON* RegionIntoJSON(Region *obj);
Region* RegionFromJSON(const char *json_str);
