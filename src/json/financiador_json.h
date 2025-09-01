#include "../model/financiador.h"
#include <cjson/cJSON.h>

cJSON* financiador_into_json(financiador *obj);
financiador* financiador_from_json(const char *json_str);
