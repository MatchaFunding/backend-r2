#ifndef PERSONA_SQL_H
#define PERSONA_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/persona_json.h"

Persona* ViewALLPersona(int* count);
Persona CreatePersona(char* Nombre[200], char* Sexo, char* RUT[12], char* FechaDeNacimiento);
Persona ObtainPersona(int id);
Persona ModifyPersona(char* ID, char* Nombre[200], char* Sexo, char* RUT[12], char* FechaDeNacimiento);
void DeletePersona(int id);

#endif
