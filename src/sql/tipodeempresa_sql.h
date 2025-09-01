#ifndef TIPODEEMPRESA_SQL_H
#define TIPODEEMPRESA_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/tipodeempresa_json.h"

TipoDeEmpresa* ViewALLTipoDeEmpresa(int* count);
TipoDeEmpresa CreateTipoDeEmpresa(char* Codigo[4], char* Nombre[50]);
TipoDeEmpresa ObtainTipoDeEmpresa(int id);
TipoDeEmpresa ModifyTipoDeEmpresa(char* ID, char* Codigo[4], char* Nombre[50]);
void DeleteTipoDeEmpresa(int id);

#endif
