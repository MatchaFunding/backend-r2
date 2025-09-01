#include <cjson/cJSON.h>
#include "../model/consorcio.h"

cJSON* ConsorcioIntoJSON(Consorcio *obj);
Consorcio* ConsorcioFromJSON(const char *json_str);
