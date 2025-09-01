#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "sexo_json.h"

cJSON* sexo_into_json(sexo *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Codigo", obj->Codigo);
    cJSON_AddStringToObject(json, "Nombre", obj->Nombre);
    return json;
}

sexo* sexo_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    sexo *obj = malloc(sizeof(sexo));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Codigo = cJSON_GetObjectItemCaseSensitive(json, "Codigo");
    if (cJSON_IsString(j_Codigo) && (j_Codigo->valuestring != NULL)) {
        strncpy(obj->Codigo, j_Codigo->valuestring, sizeof(obj->Codigo)-1);
        obj->Codigo[sizeof(obj->Codigo)-1] = '\0';
    } else { obj->Codigo[0] = '\0'; }
    cJSON *j_Nombre = cJSON_GetObjectItemCaseSensitive(json, "Nombre");
    if (cJSON_IsString(j_Nombre) && (j_Nombre->valuestring != NULL)) {
        strncpy(obj->Nombre, j_Nombre->valuestring, sizeof(obj->Nombre)-1);
        obj->Nombre[sizeof(obj->Nombre)-1] = '\0';
    } else { obj->Nombre[0] = '\0'; }
    cJSON_Delete(json);
    return obj;
}
