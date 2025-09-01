#include <cjson/cJSON.h>
#include "../model/financiador.h"

cJSON* FinanciadorIntoJSON(Financiador *obj);
Financiador* FinanciadorFromJSON(const char *json_str);
