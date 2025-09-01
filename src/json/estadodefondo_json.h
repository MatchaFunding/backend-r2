#include "../model/estadodefondo.h"
#include <cjson/cJSON.h>

cJSON* estadodefondo_into_json(estadodefondo *obj);
estadodefondo* estadodefondo_from_json(const char *json_str);
