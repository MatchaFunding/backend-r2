#ifndef PROYECTO_SQL_H
#define PROYECTO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/proyecto_json.h"

Proyecto* ViewALLProyecto(int* count);
Proyecto CreateProyecto(char* Titulo[300], char* Descripcion[500], int DuracionEnMesesMinimo, int DuracionEnMesesMaximo, char* Alcance, char* Area[100], char* Beneficiario);
Proyecto ObtainProyecto(int id);
Proyecto ModifyProyecto(char* ID, char* Titulo[300], char* Descripcion[500], int DuracionEnMesesMinimo, int DuracionEnMesesMaximo, char* Alcance, char* Area[100], char* Beneficiario);
void DeleteProyecto(int id);

#endif
