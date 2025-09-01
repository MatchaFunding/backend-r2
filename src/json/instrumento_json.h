#include <cjson/cJSON.h>
#include "../model/instrumento.h"

cJSON* InstrumentoIntoJSON(Instrumento *obj);
Instrumento* InstrumentoFromJSON(const char *json_str);
