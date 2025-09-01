#include "../model/postulacion.h"
#include <cjson/cJSON.h>

cJSON* postulacion_into_json(postulacion *obj);
postulacion* postulacion_from_json(const char *json_str);
