#include "../model/beneficiario.h"
#include <cjson/cJSON.h>

cJSON* beneficiario_into_json(beneficiario *obj);
beneficiario* beneficiario_from_json(const char *json_str);
