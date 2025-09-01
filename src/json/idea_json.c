#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>

cJSON* IdeaIntoJSON(Idea *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddNumberToObject(json, "Usuario", obj->Usuario);
    cJSON_AddStringToObject(json, "Campo", obj->Campo);
    cJSON_AddStringToObject(json, "Problema", obj->Problema);
    cJSON_AddStringToObject(json, "Publico", obj->Publico);
    cJSON_AddStringToObject(json, "Innovacion", obj->Innovacion);
    return json;
}

Idea* IdeaFromJSON(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    Idea *obj = malloc(sizeof(Idea));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Usuario = cJSON_GetObjectItemCaseSensitive(json, "Usuario");
    if (cJSON_IsNumber(j_Usuario)) obj->Usuario = j_Usuario->valuedouble;
    else obj->Usuario = 0;
    cJSON *j_Campo = cJSON_GetObjectItemCaseSensitive(json, "Campo");
    if (cJSON_IsString(j_Campo) && (j_Campo->valuestring != NULL)) {
        strncpy(obj->Campo, j_Campo->valuestring, sizeof(obj->Campo)-1);
        obj->Campo[sizeof(obj->Campo)-1] = '\0';
    } else { obj->Campo[0] = '\0'; }
    cJSON *j_Problema = cJSON_GetObjectItemCaseSensitive(json, "Problema");
    if (cJSON_IsString(j_Problema) && (j_Problema->valuestring != NULL)) {
        strncpy(obj->Problema, j_Problema->valuestring, sizeof(obj->Problema)-1);
        obj->Problema[sizeof(obj->Problema)-1] = '\0';
    } else { obj->Problema[0] = '\0'; }
    cJSON *j_Publico = cJSON_GetObjectItemCaseSensitive(json, "Publico");
    if (cJSON_IsString(j_Publico) && (j_Publico->valuestring != NULL)) {
        strncpy(obj->Publico, j_Publico->valuestring, sizeof(obj->Publico)-1);
        obj->Publico[sizeof(obj->Publico)-1] = '\0';
    } else { obj->Publico[0] = '\0'; }
    cJSON *j_Innovacion = cJSON_GetObjectItemCaseSensitive(json, "Innovacion");
    if (cJSON_IsString(j_Innovacion) && (j_Innovacion->valuestring != NULL)) {
        strncpy(obj->Innovacion, j_Innovacion->valuestring, sizeof(obj->Innovacion)-1);
        obj->Innovacion[sizeof(obj->Innovacion)-1] = '\0';
    } else { obj->Innovacion[0] = '\0'; }
    cJSON_Delete(json);
    return obj;
}
