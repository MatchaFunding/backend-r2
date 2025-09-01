#include <cjson/cJSON.h>
#include "../model/persona.h"

cJSON* PersonaIntoJSON(Persona *obj);
Persona* PersonaFromJSON(const char *json_str);
