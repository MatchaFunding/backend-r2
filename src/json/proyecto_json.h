#include "../model/proyecto.h"
#include <cjson/cJSON.h>

cJSON* proyecto_into_json(proyecto *obj);
proyecto* proyecto_from_json(const char *json_str);
