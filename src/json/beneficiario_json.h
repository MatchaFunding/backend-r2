#include <cjson/cJSON.h>
#include "../model/beneficiario.h"

cJSON* BeneficiarioIntoJSON(Beneficiario *obj);
Beneficiario* BeneficiarioFromJSON(const char *json_str);
