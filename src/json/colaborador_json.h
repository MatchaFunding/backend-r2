#include <cjson/cJSON.h>
#include "../model/colaborador.h"

cJSON* ColaboradorIntoJSON(Colaborador *obj);
Colaborador* ColaboradorFromJSON(const char *json_str);
