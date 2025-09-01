#include <cjson/cJSON.h>
#include "../model/proyecto.h"

cJSON* ProyectoIntoJSON(Proyecto *obj);
Proyecto* ProyectoFromJSON(const char *json_str);
