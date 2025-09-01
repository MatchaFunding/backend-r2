#ifndef MIEMBRO_SQL_H
#define MIEMBRO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/miembro_json.h"

Miembro* ViewALLMiembro(int* count);
Miembro CreateMiembro(char* Beneficiario, char* Persona);
Miembro ObtainMiembro(int id);
Miembro ModifyMiembro(char* ID, char* Beneficiario, char* Persona);
void DeleteMiembro(int id);

#endif
