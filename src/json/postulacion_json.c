#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>
#include "postulacion_json.h"

cJSON* postulacion_into_json(postulacion *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Resultado", obj->Resultado);
    cJSON_AddNumberToObject(json, "MontoObtenido", obj->MontoObtenido);
    cJSON_AddStringToObject(json, "FechaDePostulacion", obj->FechaDePostulacion);
    cJSON_AddStringToObject(json, "FechaDeResultado", obj->FechaDeResultado);
    cJSON_AddStringToObject(json, "Detalle", obj->Detalle);
    cJSON_AddNumberToObject(json, "Beneficiario", obj->Beneficiario);
    cJSON_AddNumberToObject(json, "Instrumento", obj->Instrumento);
    cJSON_AddNumberToObject(json, "Proyecto", obj->Proyecto);
    return json;
}

postulacion* postulacion_from_json(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    postulacion *obj = malloc(sizeof(postulacion));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Resultado = cJSON_GetObjectItemCaseSensitive(json, "Resultado");
    if (cJSON_IsString(j_Resultado) && (j_Resultado->valuestring != NULL)) {
        strncpy(obj->Resultado, j_Resultado->valuestring, sizeof(obj->Resultado)-1);
        obj->Resultado[sizeof(obj->Resultado)-1] = '\0';
    } else { obj->Resultado[0] = '\0'; }
    cJSON *j_MontoObtenido = cJSON_GetObjectItemCaseSensitive(json, "MontoObtenido");
    if (cJSON_IsNumber(j_MontoObtenido)) obj->MontoObtenido = j_MontoObtenido->valuedouble;
    else obj->MontoObtenido = 0;
    cJSON *j_FechaDePostulacion = cJSON_GetObjectItemCaseSensitive(json, "FechaDePostulacion");
    if (cJSON_IsString(j_FechaDePostulacion) && (j_FechaDePostulacion->valuestring != NULL)) {
        strncpy(obj->FechaDePostulacion, j_FechaDePostulacion->valuestring, sizeof(obj->FechaDePostulacion)-1);
        obj->FechaDePostulacion[sizeof(obj->FechaDePostulacion)-1] = '\0';
    } else { obj->FechaDePostulacion[0] = '\0'; }
    cJSON *j_FechaDeResultado = cJSON_GetObjectItemCaseSensitive(json, "FechaDeResultado");
    if (cJSON_IsString(j_FechaDeResultado) && (j_FechaDeResultado->valuestring != NULL)) {
        strncpy(obj->FechaDeResultado, j_FechaDeResultado->valuestring, sizeof(obj->FechaDeResultado)-1);
        obj->FechaDeResultado[sizeof(obj->FechaDeResultado)-1] = '\0';
    } else { obj->FechaDeResultado[0] = '\0'; }
    cJSON *j_Detalle = cJSON_GetObjectItemCaseSensitive(json, "Detalle");
    if (cJSON_IsString(j_Detalle) && (j_Detalle->valuestring != NULL)) {
        strncpy(obj->Detalle, j_Detalle->valuestring, sizeof(obj->Detalle)-1);
        obj->Detalle[sizeof(obj->Detalle)-1] = '\0';
    } else { obj->Detalle[0] = '\0'; }
    cJSON *j_Beneficiario = cJSON_GetObjectItemCaseSensitive(json, "Beneficiario");
    if (cJSON_IsNumber(j_Beneficiario)) obj->Beneficiario = j_Beneficiario->valuedouble;
    else obj->Beneficiario = 0;
    cJSON *j_Instrumento = cJSON_GetObjectItemCaseSensitive(json, "Instrumento");
    if (cJSON_IsNumber(j_Instrumento)) obj->Instrumento = j_Instrumento->valuedouble;
    else obj->Instrumento = 0;
    cJSON *j_Proyecto = cJSON_GetObjectItemCaseSensitive(json, "Proyecto");
    if (cJSON_IsNumber(j_Proyecto)) obj->Proyecto = j_Proyecto->valuedouble;
    else obj->Proyecto = 0;
    cJSON_Delete(json);
    return obj;
}
