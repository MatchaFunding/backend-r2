#include <cjson/cJSON.h>
#include "../model/tipodeperfil.h"

cJSON* TipoDePerfilIntoJSON(TipoDePerfil *obj);
TipoDePerfil* TipoDePerfilFromJSON(const char *json_str);
