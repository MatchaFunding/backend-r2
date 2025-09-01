#include <cjson/cJSON.h>
#include "../model/tipodepersona.h"

cJSON* TipoDePersonaIntoJSON(TipoDePersona *obj);
TipoDePersona* TipoDePersonaFromJSON(const char *json_str);
