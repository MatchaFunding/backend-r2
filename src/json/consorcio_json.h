#include "../model/consorcio.h"
#include <cjson/cJSON.h>

cJSON* consorcio_into_json(consorcio *obj);
consorcio* consorcio_from_json(const char *json_str);
