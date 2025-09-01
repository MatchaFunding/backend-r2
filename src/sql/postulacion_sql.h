#ifndef POSTULACION_SQL_H
#define POSTULACION_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/postulacion_json.h"

Postulacion* ViewALLPostulacion(int* count);
Postulacion CreatePostulacion(char* Resultado[30], int MontoObtenido, char* FechaDePostulacion, char* FechaDeResultado, char* Detalle[1000], char* Beneficiario, char* Instrumento, char* Proyecto);
Postulacion ObtainPostulacion(int id);
Postulacion ModifyPostulacion(char* ID, char* Resultado[30], int MontoObtenido, char* FechaDePostulacion, char* FechaDeResultado, char* Detalle[1000], char* Beneficiario, char* Instrumento, char* Proyecto);
void DeletePostulacion(int id);

#endif
