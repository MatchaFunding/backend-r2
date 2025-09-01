#include <cjson/cJSON.h>
#include "../model/miembro.h"

cJSON* MiembroIntoJSON(Miembro *obj);
Miembro* MiembroFromJSON(const char *json_str);
