#include "../model/persona.h"
#include <cjson/cJSON.h>

cJSON* persona_into_json(persona *obj);
persona* persona_from_json(const char *json_str);
