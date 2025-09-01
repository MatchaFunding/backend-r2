#ifndef TIPODEBENEFICIO_SQL_H
#define TIPODEBENEFICIO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/tipodebeneficio_json.h"

TipoDeBeneficio* ViewALLTipoDeBeneficio(int* count);
TipoDeBeneficio CreateTipoDeBeneficio(char* Codigo[3], char* Nombre[30]);
TipoDeBeneficio ObtainTipoDeBeneficio(int id);
TipoDeBeneficio ModifyTipoDeBeneficio(char* ID, char* Codigo[3], char* Nombre[30]);
void DeleteTipoDeBeneficio(int id);

#endif
