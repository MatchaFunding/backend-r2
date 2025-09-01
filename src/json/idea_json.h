#include "../model/idea.h"
#include <cjson/cJSON.h>

cJSON* idea_into_json(idea *obj);
idea* idea_from_json(const char *json_str);
