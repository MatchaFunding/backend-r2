#include <cjson/cJSON.h>
#include "../model/estadodefondo.h"

cJSON* EstadoDeFondoIntoJSON(EstadoDeFondo *obj);
EstadoDeFondo* EstadoDeFondoFromJSON(const char *json_str);
