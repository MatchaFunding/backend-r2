#ifndef SEXO_SQL_H
#define SEXO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/sexo_json.h"

Sexo* ViewALLSexo(int* count);
Sexo CreateSexo(char* Codigo[3], char* Nombre[30]);
Sexo ObtainSexo(int id);
Sexo ModifySexo(char* ID, char* Codigo[3], char* Nombre[30]);
void DeleteSexo(int id);

#endif
