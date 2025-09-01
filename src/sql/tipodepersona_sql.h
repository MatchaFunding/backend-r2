#ifndef TIPODEPERSONA_SQL_H
#define TIPODEPERSONA_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/tipodepersona_json.h"

TipoDePersona* ViewALLTipoDePersona(int* count);
TipoDePersona CreateTipoDePersona(char* Codigo[2], char* Nombre[10]);
TipoDePersona ObtainTipoDePersona(int id);
TipoDePersona ModifyTipoDePersona(char* ID, char* Codigo[2], char* Nombre[10]);
void DeleteTipoDePersona(int id);

#endif
