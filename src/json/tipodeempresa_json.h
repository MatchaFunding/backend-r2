#include <cjson/cJSON.h>
#include "../model/tipodeempresa.h"

cJSON* TipoDeEmpresaIntoJSON(TipoDeEmpresa *obj);
TipoDeEmpresa* TipoDeEmpresaFromJSON(const char *json_str);
