#ifndef FINANCIADOR_SQL_H
#define FINANCIADOR_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/financiador_json.h"

Financiador* ViewALLFinanciador(int* count);
Financiador CreateFinanciador(char* Nombre[100], char* FechaDeCreacion, char* RegionDeCreacion, char* Direccion[300], char* TipoDePersona, char* TipoDeEmpresa, char* Perfil, char* RUTdeEmpresa[12], char* RUTdeRepresentante[12]);
Financiador ObtainFinanciador(int id);
Financiador ModifyFinanciador(char* ID, char* Nombre[100], char* FechaDeCreacion, char* RegionDeCreacion, char* Direccion[300], char* TipoDePersona, char* TipoDeEmpresa, char* Perfil, char* RUTdeEmpresa[12], char* RUTdeRepresentante[12]);
void DeleteFinanciador(int id);

#endif
