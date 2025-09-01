#include <cjson/cJSON.h>
#include "../model/usuario.h"

cJSON* UsuarioIntoJSON(Usuario *obj);
Usuario* UsuarioFromJSON(const char *json_str);
