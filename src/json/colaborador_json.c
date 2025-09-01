#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "colaborador_json.h"

cJSON* colaborador_into_json(colaborador *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddNumberToObject(json, "Persona", obj->Persona);
    cJSON_AddNumberToObject(json, "Proyecto", obj->Proyecto);
    return json;
}

colaborador* colaborador_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    colaborador *obj = malloc(sizeof(colaborador));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Persona = cJSON_GetObjectItemCaseSensitive(json, "Persona");
    if (cJSON_IsNumber(j_Persona)) obj->Persona = j_Persona->valuedouble;
    else obj->Persona = 0;
    cJSON *j_Proyecto = cJSON_GetObjectItemCaseSensitive(json, "Proyecto");
    if (cJSON_IsNumber(j_Proyecto)) obj->Proyecto = j_Proyecto->valuedouble;
    else obj->Proyecto = 0;
    cJSON_Delete(json);
    return obj;
}
