#ifndef BENEFICIARIO_SQL_H
#define BENEFICIARIO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/beneficiario_json.h"

Beneficiario* ViewALLBeneficiario(int* count);
Beneficiario CreateBeneficiario(char* Nombre[100], char* FechaDeCreacion, char* RegionDeCreacion, char* Direccion[300], char* TipoDePersona, char* TipoDeEmpresa, char* Perfil, char* RUTdeEmpresa[12], char* RUTdeRepresentante[12]);
Beneficiario ObtainBeneficiario(int id);
Beneficiario ModifyBeneficiario(char* ID, char* Nombre[100], char* FechaDeCreacion, char* RegionDeCreacion, char* Direccion[300], char* TipoDePersona, char* TipoDeEmpresa, char* Perfil, char* RUTdeEmpresa[12], char* RUTdeRepresentante[12]);
void DeleteBeneficiario(int id);

#endif
