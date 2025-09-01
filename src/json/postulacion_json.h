#include <cjson/cJSON.h>
#include "../model/postulacion.h"

cJSON* PostulacionIntoJSON(Postulacion *obj);
Postulacion* PostulacionFromJSON(const char *json_str);
