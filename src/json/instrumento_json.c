#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cjson/cJSON.h>

cJSON* InstrumentoIntoJSON(Instrumento *obj) {
    if (!obj) return NULL;
    cJSON *json = cJSON_CreateObject();
    cJSON_AddNumberToObject(json, "ID", obj->ID);
    cJSON_AddStringToObject(json, "Titulo", obj->Titulo);
    cJSON_AddNumberToObject(json, "Alcance", obj->Alcance);
    cJSON_AddStringToObject(json, "Descripcion", obj->Descripcion);
    cJSON_AddStringToObject(json, "FechaDeApertura", obj->FechaDeApertura);
    cJSON_AddStringToObject(json, "FechaDeCierre", obj->FechaDeCierre);
    cJSON_AddNumberToObject(json, "DuracionEnMeses", obj->DuracionEnMeses);
    cJSON_AddStringToObject(json, "Beneficios", obj->Beneficios);
    cJSON_AddStringToObject(json, "Requisitos", obj->Requisitos);
    cJSON_AddNumberToObject(json, "MontoMinimo", obj->MontoMinimo);
    cJSON_AddNumberToObject(json, "MontoMaximo", obj->MontoMaximo);
    cJSON_AddNumberToObject(json, "Estado", obj->Estado);
    cJSON_AddNumberToObject(json, "TipoDeBeneficio", obj->TipoDeBeneficio);
    cJSON_AddNumberToObject(json, "TipoDePerfil", obj->TipoDePerfil);
    cJSON_AddStringToObject(json, "EnlaceDelDetalle", obj->EnlaceDelDetalle);
    cJSON_AddStringToObject(json, "EnlaceDeLaFoto", obj->EnlaceDeLaFoto);
    cJSON_AddNumberToObject(json, "Financiador", obj->Financiador);
    return json;
}

Instrumento* InstrumentoFromJSON(const char *json_str) {
    if (!json_str) return NULL;
    cJSON *json = cJSON_Parse(json_str);
    if (!json) return NULL;
    Instrumento *obj = malloc(sizeof(Instrumento));
    if (!obj) { cJSON_Delete(json); return NULL; }
    cJSON *j_ID = cJSON_GetObjectItemCaseSensitive(json, "ID");
    if (cJSON_IsNumber(j_ID)) obj->ID = j_ID->valuedouble;
    else obj->ID = 0;
    cJSON *j_Titulo = cJSON_GetObjectItemCaseSensitive(json, "Titulo");
    if (cJSON_IsString(j_Titulo) && (j_Titulo->valuestring != NULL)) {
        strncpy(obj->Titulo, j_Titulo->valuestring, sizeof(obj->Titulo)-1);
        obj->Titulo[sizeof(obj->Titulo)-1] = '\0';
    } else { obj->Titulo[0] = '\0'; }
    cJSON *j_Alcance = cJSON_GetObjectItemCaseSensitive(json, "Alcance");
    if (cJSON_IsNumber(j_Alcance)) obj->Alcance = j_Alcance->valuedouble;
    else obj->Alcance = 0;
    cJSON *j_Descripcion = cJSON_GetObjectItemCaseSensitive(json, "Descripcion");
    if (cJSON_IsString(j_Descripcion) && (j_Descripcion->valuestring != NULL)) {
        strncpy(obj->Descripcion, j_Descripcion->valuestring, sizeof(obj->Descripcion)-1);
        obj->Descripcion[sizeof(obj->Descripcion)-1] = '\0';
    } else { obj->Descripcion[0] = '\0'; }
    cJSON *j_FechaDeApertura = cJSON_GetObjectItemCaseSensitive(json, "FechaDeApertura");
    if (cJSON_IsString(j_FechaDeApertura) && (j_FechaDeApertura->valuestring != NULL)) {
        strncpy(obj->FechaDeApertura, j_FechaDeApertura->valuestring, sizeof(obj->FechaDeApertura)-1);
        obj->FechaDeApertura[sizeof(obj->FechaDeApertura)-1] = '\0';
    } else { obj->FechaDeApertura[0] = '\0'; }
    cJSON *j_FechaDeCierre = cJSON_GetObjectItemCaseSensitive(json, "FechaDeCierre");
    if (cJSON_IsString(j_FechaDeCierre) && (j_FechaDeCierre->valuestring != NULL)) {
        strncpy(obj->FechaDeCierre, j_FechaDeCierre->valuestring, sizeof(obj->FechaDeCierre)-1);
        obj->FechaDeCierre[sizeof(obj->FechaDeCierre)-1] = '\0';
    } else { obj->FechaDeCierre[0] = '\0'; }
    cJSON *j_DuracionEnMeses = cJSON_GetObjectItemCaseSensitive(json, "DuracionEnMeses");
    if (cJSON_IsNumber(j_DuracionEnMeses)) obj->DuracionEnMeses = j_DuracionEnMeses->valuedouble;
    else obj->DuracionEnMeses = 0;
    cJSON *j_Beneficios = cJSON_GetObjectItemCaseSensitive(json, "Beneficios");
    if (cJSON_IsString(j_Beneficios) && (j_Beneficios->valuestring != NULL)) {
        strncpy(obj->Beneficios, j_Beneficios->valuestring, sizeof(obj->Beneficios)-1);
        obj->Beneficios[sizeof(obj->Beneficios)-1] = '\0';
    } else { obj->Beneficios[0] = '\0'; }
    cJSON *j_Requisitos = cJSON_GetObjectItemCaseSensitive(json, "Requisitos");
    if (cJSON_IsString(j_Requisitos) && (j_Requisitos->valuestring != NULL)) {
        strncpy(obj->Requisitos, j_Requisitos->valuestring, sizeof(obj->Requisitos)-1);
        obj->Requisitos[sizeof(obj->Requisitos)-1] = '\0';
    } else { obj->Requisitos[0] = '\0'; }
    cJSON *j_MontoMinimo = cJSON_GetObjectItemCaseSensitive(json, "MontoMinimo");
    if (cJSON_IsNumber(j_MontoMinimo)) obj->MontoMinimo = j_MontoMinimo->valuedouble;
    else obj->MontoMinimo = 0;
    cJSON *j_MontoMaximo = cJSON_GetObjectItemCaseSensitive(json, "MontoMaximo");
    if (cJSON_IsNumber(j_MontoMaximo)) obj->MontoMaximo = j_MontoMaximo->valuedouble;
    else obj->MontoMaximo = 0;
    cJSON *j_Estado = cJSON_GetObjectItemCaseSensitive(json, "Estado");
    if (cJSON_IsNumber(j_Estado)) obj->Estado = j_Estado->valuedouble;
    else obj->Estado = 0;
    cJSON *j_TipoDeBeneficio = cJSON_GetObjectItemCaseSensitive(json, "TipoDeBeneficio");
    if (cJSON_IsNumber(j_TipoDeBeneficio)) obj->TipoDeBeneficio = j_TipoDeBeneficio->valuedouble;
    else obj->TipoDeBeneficio = 0;
    cJSON *j_TipoDePerfil = cJSON_GetObjectItemCaseSensitive(json, "TipoDePerfil");
    if (cJSON_IsNumber(j_TipoDePerfil)) obj->TipoDePerfil = j_TipoDePerfil->valuedouble;
    else obj->TipoDePerfil = 0;
    cJSON *j_EnlaceDelDetalle = cJSON_GetObjectItemCaseSensitive(json, "EnlaceDelDetalle");
    if (cJSON_IsString(j_EnlaceDelDetalle) && (j_EnlaceDelDetalle->valuestring != NULL)) {
        strncpy(obj->EnlaceDelDetalle, j_EnlaceDelDetalle->valuestring, sizeof(obj->EnlaceDelDetalle)-1);
        obj->EnlaceDelDetalle[sizeof(obj->EnlaceDelDetalle)-1] = '\0';
    } else { obj->EnlaceDelDetalle[0] = '\0'; }
    cJSON *j_EnlaceDeLaFoto = cJSON_GetObjectItemCaseSensitive(json, "EnlaceDeLaFoto");
    if (cJSON_IsString(j_EnlaceDeLaFoto) && (j_EnlaceDeLaFoto->valuestring != NULL)) {
        strncpy(obj->EnlaceDeLaFoto, j_EnlaceDeLaFoto->valuestring, sizeof(obj->EnlaceDeLaFoto)-1);
        obj->EnlaceDeLaFoto[sizeof(obj->EnlaceDeLaFoto)-1] = '\0';
    } else { obj->EnlaceDeLaFoto[0] = '\0'; }
    cJSON *j_Financiador = cJSON_GetObjectItemCaseSensitive(json, "Financiador");
    if (cJSON_IsNumber(j_Financiador)) obj->Financiador = j_Financiador->valuedouble;
    else obj->Financiador = 0;
    cJSON_Delete(json);
    return obj;
}
