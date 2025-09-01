#include <cjson/cJSON.h>
#include "../model/sexo.h"

cJSON* SexoIntoJSON(Sexo *obj);
Sexo* SexoFromJSON(const char *json_str);
