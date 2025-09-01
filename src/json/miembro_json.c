#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "miembro_json.h"

cJSON* miembro_into_json(miembro *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddNumberToObject(json, "Beneficiario", obj->Beneficiario);
    cJSON_AddNumberToObject(json, "Persona", obj->Persona);
    return json;
}

miembro* miembro_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    miembro *obj = malloc(sizeof(miembro));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Beneficiario = cJSON_GetObjectItemCaseSensitive(json, "Beneficiario");
    if (cJSON_IsNumber(j_Beneficiario)) obj->Beneficiario = j_Beneficiario->valuedouble;
    else obj->Beneficiario = 0;
    cJSON *j_Persona = cJSON_GetObjectItemCaseSensitive(json, "Persona");
    if (cJSON_IsNumber(j_Persona)) obj->Persona = j_Persona->valuedouble;
    else obj->Persona = 0;
    cJSON_Delete(json);
    return obj;
}
