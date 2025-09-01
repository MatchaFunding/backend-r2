#include <cjson/cJSON.h>
#include "../model/tipodebeneficio.h"

cJSON* TipoDeBeneficioIntoJSON(TipoDeBeneficio *obj);
TipoDeBeneficio* TipoDeBeneficioFromJSON(const char *json_str);
