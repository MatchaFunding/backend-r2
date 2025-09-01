#ifndef COLABORADOR_SQL_H
#define COLABORADOR_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/colaborador_json.h"

Colaborador* ViewALLColaborador(int* count);
Colaborador CreateColaborador(char* Persona, char* Proyecto);
Colaborador ObtainColaborador(int id);
Colaborador ModifyColaborador(char* ID, char* Persona, char* Proyecto);
void DeleteColaborador(int id);

#endif
