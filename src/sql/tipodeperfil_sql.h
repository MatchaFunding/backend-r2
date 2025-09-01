#ifndef TIPODEPERFIL_SQL_H
#define TIPODEPERFIL_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/tipodeperfil_json.h"

TipoDePerfil* ViewALLTipoDePerfil(int* count);
TipoDePerfil CreateTipoDePerfil(char* Codigo[3], char* Nombre[30]);
TipoDePerfil ObtainTipoDePerfil(int id);
TipoDePerfil ModifyTipoDePerfil(char* ID, char* Codigo[3], char* Nombre[30]);
void DeleteTipoDePerfil(int id);

#endif
