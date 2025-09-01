#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "proyecto_json.h"

cJSON* proyecto_into_json(proyecto *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Titulo", obj->Titulo);
    cJSON_AddStringToObject(json, "Descripcion", obj->Descripcion);
    cJSON_AddNumberToObject(json, "DuracionEnMesesMinimo", obj->DuracionEnMesesMinimo);
    cJSON_AddNumberToObject(json, "DuracionEnMesesMaximo", obj->DuracionEnMesesMaximo);
    cJSON_AddNumberToObject(json, "Alcance", obj->Alcance);
    cJSON_AddStringToObject(json, "Area", obj->Area);
    cJSON_AddNumberToObject(json, "Beneficiario", obj->Beneficiario);
    return json;
}

proyecto* proyecto_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    proyecto *obj = malloc(sizeof(proyecto));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Titulo = cJSON_GetObjectItemCaseSensitive(json, "Titulo");
    if (cJSON_IsString(j_Titulo) && (j_Titulo->valuestring != NULL)) {
        strncpy(obj->Titulo, j_Titulo->valuestring, sizeof(obj->Titulo)-1);
        obj->Titulo[sizeof(obj->Titulo)-1] = '\0';
    } else { obj->Titulo[0] = '\0'; }
    cJSON *j_Descripcion = cJSON_GetObjectItemCaseSensitive(json, "Descripcion");
    if (cJSON_IsString(j_Descripcion) && (j_Descripcion->valuestring != NULL)) {
        strncpy(obj->Descripcion, j_Descripcion->valuestring, sizeof(obj->Descripcion)-1);
        obj->Descripcion[sizeof(obj->Descripcion)-1] = '\0';
    } else { obj->Descripcion[0] = '\0'; }
    cJSON *j_DuracionEnMesesMinimo = cJSON_GetObjectItemCaseSensitive(json, "DuracionEnMesesMinimo");
    if (cJSON_IsNumber(j_DuracionEnMesesMinimo)) obj->DuracionEnMesesMinimo = j_DuracionEnMesesMinimo->valuedouble;
    else obj->DuracionEnMesesMinimo = 0;
    cJSON *j_DuracionEnMesesMaximo = cJSON_GetObjectItemCaseSensitive(json, "DuracionEnMesesMaximo");
    if (cJSON_IsNumber(j_DuracionEnMesesMaximo)) obj->DuracionEnMesesMaximo = j_DuracionEnMesesMaximo->valuedouble;
    else obj->DuracionEnMesesMaximo = 0;
    cJSON *j_Alcance = cJSON_GetObjectItemCaseSensitive(json, "Alcance");
    if (cJSON_IsNumber(j_Alcance)) obj->Alcance = j_Alcance->valuedouble;
    else obj->Alcance = 0;
    cJSON *j_Area = cJSON_GetObjectItemCaseSensitive(json, "Area");
    if (cJSON_IsString(j_Area) && (j_Area->valuestring != NULL)) {
        strncpy(obj->Area, j_Area->valuestring, sizeof(obj->Area)-1);
        obj->Area[sizeof(obj->Area)-1] = '\0';
    } else { obj->Area[0] = '\0'; }
    cJSON *j_Beneficiario = cJSON_GetObjectItemCaseSensitive(json, "Beneficiario");
    if (cJSON_IsNumber(j_Beneficiario)) obj->Beneficiario = j_Beneficiario->valuedouble;
    else obj->Beneficiario = 0;
    cJSON_Delete(json);
    return obj;
}
