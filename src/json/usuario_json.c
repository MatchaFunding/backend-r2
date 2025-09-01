#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "usuario_json.h"

cJSON* usuario_into_json(usuario *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "NombreDeUsuario", obj->NombreDeUsuario);
    cJSON_AddStringToObject(json, "Contrasena", obj->Contrasena);
    cJSON_AddStringToObject(json, "Correo", obj->Correo);
    cJSON_AddNumberToObject(json, "Persona", obj->Persona);
    return json;
}

usuario* usuario_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    usuario *obj = malloc(sizeof(usuario));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_NombreDeUsuario = cJSON_GetObjectItemCaseSensitive(json, "NombreDeUsuario");
    if (cJSON_IsString(j_NombreDeUsuario) && (j_NombreDeUsuario->valuestring != NULL)) {
        strncpy(obj->NombreDeUsuario, j_NombreDeUsuario->valuestring, sizeof(obj->NombreDeUsuario)-1);
        obj->NombreDeUsuario[sizeof(obj->NombreDeUsuario)-1] = '\0';
    } else { obj->NombreDeUsuario[0] = '\0'; }
    cJSON *j_Contrasena = cJSON_GetObjectItemCaseSensitive(json, "Contrasena");
    if (cJSON_IsString(j_Contrasena) && (j_Contrasena->valuestring != NULL)) {
        strncpy(obj->Contrasena, j_Contrasena->valuestring, sizeof(obj->Contrasena)-1);
        obj->Contrasena[sizeof(obj->Contrasena)-1] = '\0';
    } else { obj->Contrasena[0] = '\0'; }
    cJSON *j_Correo = cJSON_GetObjectItemCaseSensitive(json, "Correo");
    if (cJSON_IsString(j_Correo) && (j_Correo->valuestring != NULL)) {
        strncpy(obj->Correo, j_Correo->valuestring, sizeof(obj->Correo)-1);
        obj->Correo[sizeof(obj->Correo)-1] = '\0';
    } else { obj->Correo[0] = '\0'; }
    cJSON *j_Persona = cJSON_GetObjectItemCaseSensitive(json, "Persona");
    if (cJSON_IsNumber(j_Persona)) obj->Persona = j_Persona->valuedouble;
    else obj->Persona = 0;
    cJSON_Delete(json);
    return obj;
}
