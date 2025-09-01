#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>

cJSON* FinanciadorIntoJSON(Financiador *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Nombre", obj->Nombre);
    cJSON_AddStringToObject(json, "FechaDeCreacion", obj->FechaDeCreacion);
    cJSON_AddNumberToObject(json, "RegionDeCreacion", obj->RegionDeCreacion);
    cJSON_AddStringToObject(json, "Direccion", obj->Direccion);
    cJSON_AddNumberToObject(json, "TipoDePersona", obj->TipoDePersona);
    cJSON_AddNumberToObject(json, "TipoDeEmpresa", obj->TipoDeEmpresa);
    cJSON_AddNumberToObject(json, "Perfil", obj->Perfil);
    cJSON_AddStringToObject(json, "RUTdeEmpresa", obj->RUTdeEmpresa);
    cJSON_AddStringToObject(json, "RUTdeRepresentante", obj->RUTdeRepresentante);
    return json;
}

Financiador* FinanciadorFromJSON(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    Financiador *obj = malloc(sizeof(Financiador));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Nombre = cJSON_GetObjectItemCaseSensitive(json, "Nombre");
    if (cJSON_IsString(j_Nombre) && (j_Nombre->valuestring != NULL)) {
        strncpy(obj->Nombre, j_Nombre->valuestring, sizeof(obj->Nombre)-1);
        obj->Nombre[sizeof(obj->Nombre)-1] = '\0';
    } else { obj->Nombre[0] = '\0'; }
    cJSON *j_FechaDeCreacion = cJSON_GetObjectItemCaseSensitive(json, "FechaDeCreacion");
    if (cJSON_IsString(j_FechaDeCreacion) && (j_FechaDeCreacion->valuestring != NULL)) {
        strncpy(obj->FechaDeCreacion, j_FechaDeCreacion->valuestring, sizeof(obj->FechaDeCreacion)-1);
        obj->FechaDeCreacion[sizeof(obj->FechaDeCreacion)-1] = '\0';
    } else { obj->FechaDeCreacion[0] = '\0'; }
    cJSON *j_RegionDeCreacion = cJSON_GetObjectItemCaseSensitive(json, "RegionDeCreacion");
    if (cJSON_IsNumber(j_RegionDeCreacion)) obj->RegionDeCreacion = j_RegionDeCreacion->valuedouble;
    else obj->RegionDeCreacion = 0;
    cJSON *j_Direccion = cJSON_GetObjectItemCaseSensitive(json, "Direccion");
    if (cJSON_IsString(j_Direccion) && (j_Direccion->valuestring != NULL)) {
        strncpy(obj->Direccion, j_Direccion->valuestring, sizeof(obj->Direccion)-1);
        obj->Direccion[sizeof(obj->Direccion)-1] = '\0';
    } else { obj->Direccion[0] = '\0'; }
    cJSON *j_TipoDePersona = cJSON_GetObjectItemCaseSensitive(json, "TipoDePersona");
    if (cJSON_IsNumber(j_TipoDePersona)) obj->TipoDePersona = j_TipoDePersona->valuedouble;
    else obj->TipoDePersona = 0;
    cJSON *j_TipoDeEmpresa = cJSON_GetObjectItemCaseSensitive(json, "TipoDeEmpresa");
    if (cJSON_IsNumber(j_TipoDeEmpresa)) obj->TipoDeEmpresa = j_TipoDeEmpresa->valuedouble;
    else obj->TipoDeEmpresa = 0;
    cJSON *j_Perfil = cJSON_GetObjectItemCaseSensitive(json, "Perfil");
    if (cJSON_IsNumber(j_Perfil)) obj->Perfil = j_Perfil->valuedouble;
    else obj->Perfil = 0;
    cJSON *j_RUTdeEmpresa = cJSON_GetObjectItemCaseSensitive(json, "RUTdeEmpresa");
    if (cJSON_IsString(j_RUTdeEmpresa) && (j_RUTdeEmpresa->valuestring != NULL)) {
        strncpy(obj->RUTdeEmpresa, j_RUTdeEmpresa->valuestring, sizeof(obj->RUTdeEmpresa)-1);
        obj->RUTdeEmpresa[sizeof(obj->RUTdeEmpresa)-1] = '\0';
    } else { obj->RUTdeEmpresa[0] = '\0'; }
    cJSON *j_RUTdeRepresentante = cJSON_GetObjectItemCaseSensitive(json, "RUTdeRepresentante");
    if (cJSON_IsString(j_RUTdeRepresentante) && (j_RUTdeRepresentante->valuestring != NULL)) {
        strncpy(obj->RUTdeRepresentante, j_RUTdeRepresentante->valuestring, sizeof(obj->RUTdeRepresentante)-1);
        obj->RUTdeRepresentante[sizeof(obj->RUTdeRepresentante)-1] = '\0';
    } else { obj->RUTdeRepresentante[0] = '\0'; }
    cJSON_Delete(json);
    return obj;
}
