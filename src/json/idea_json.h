#include <cjson/cJSON.h>
#include "../model/idea.h"

cJSON* IdeaIntoJSON(Idea *obj);
Idea* IdeaFromJSON(const char *json_str);
