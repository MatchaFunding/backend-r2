#ifndef CONSORCIO_SQL_H
#define CONSORCIO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/consorcio_json.h"

Consorcio* ViewALLConsorcio(int* count);
Consorcio CreateConsorcio(char* PrimerBeneficiario, char* SegundoBeneficiario);
Consorcio ObtainConsorcio(int id);
Consorcio ModifyConsorcio(char* ID, char* PrimerBeneficiario, char* SegundoBeneficiario);
void DeleteConsorcio(int id);

#endif
