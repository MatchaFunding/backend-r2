#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>

cJSON* PersonaIntoJSON(Persona *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Nombre", obj->Nombre);
    cJSON_AddNumberToObject(json, "Sexo", obj->Sexo);
    cJSON_AddStringToObject(json, "RUT", obj->RUT);
    cJSON_AddStringToObject(json, "FechaDeNacimiento", obj->FechaDeNacimiento);
    return json;
}

Persona* PersonaFromJSON(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    Persona *obj = malloc(sizeof(Persona));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Nombre = cJSON_GetObjectItemCaseSensitive(json, "Nombre");
    if (cJSON_IsString(j_Nombre) && (j_Nombre->valuestring != NULL)) {
        strncpy(obj->Nombre, j_Nombre->valuestring, sizeof(obj->Nombre)-1);
        obj->Nombre[sizeof(obj->Nombre)-1] = '\0';
    } else { obj->Nombre[0] = '\0'; }
    cJSON *j_Sexo = cJSON_GetObjectItemCaseSensitive(json, "Sexo");
    if (cJSON_IsNumber(j_Sexo)) obj->Sexo = j_Sexo->valuedouble;
    else obj->Sexo = 0;
    cJSON *j_RUT = cJSON_GetObjectItemCaseSensitive(json, "RUT");
    if (cJSON_IsString(j_RUT) && (j_RUT->valuestring != NULL)) {
        strncpy(obj->RUT, j_RUT->valuestring, sizeof(obj->RUT)-1);
        obj->RUT[sizeof(obj->RUT)-1] = '\0';
    } else { obj->RUT[0] = '\0'; }
    cJSON *j_FechaDeNacimiento = cJSON_GetObjectItemCaseSensitive(json, "FechaDeNacimiento");
    if (cJSON_IsString(j_FechaDeNacimiento) && (j_FechaDeNacimiento->valuestring != NULL)) {
        strncpy(obj->FechaDeNacimiento, j_FechaDeNacimiento->valuestring, sizeof(obj->FechaDeNacimiento)-1);
        obj->FechaDeNacimiento[sizeof(obj->FechaDeNacimiento)-1] = '\0';
    } else { obj->FechaDeNacimiento[0] = '\0'; }
    cJSON_Delete(json);
    return obj;
}
