#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "consorcio_json.h"

cJSON* consorcio_into_json(consorcio *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddNumberToObject(json, "PrimerBeneficiario", obj->PrimerBeneficiario);
    cJSON_AddNumberToObject(json, "SegundoBeneficiario", obj->SegundoBeneficiario);
    return json;
}

consorcio* consorcio_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    consorcio *obj = malloc(sizeof(consorcio));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_PrimerBeneficiario = cJSON_GetObjectItemCaseSensitive(json, "PrimerBeneficiario");
    if (cJSON_IsNumber(j_PrimerBeneficiario)) obj->PrimerBeneficiario = j_PrimerBeneficiario->valuedouble;
    else obj->PrimerBeneficiario = 0;
    cJSON *j_SegundoBeneficiario = cJSON_GetObjectItemCaseSensitive(json, "SegundoBeneficiario");
    if (cJSON_IsNumber(j_SegundoBeneficiario)) obj->SegundoBeneficiario = j_SegundoBeneficiario->valuedouble;
    else obj->SegundoBeneficiario = 0;
    cJSON_Delete(json);
    return obj;
}
