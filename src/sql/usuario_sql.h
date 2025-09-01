#ifndef USUARIO_SQL_H
#define USUARIO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/usuario_json.h"

Usuario* ViewALLUsuario(int* count);
Usuario CreateUsuario(char* NombreDeUsuario[200], char* Contrasena[200], char* Correo[200], char* Persona);
Usuario ObtainUsuario(int id);
Usuario ModifyUsuario(char* ID, char* NombreDeUsuario[200], char* Contrasena[200], char* Correo[200], char* Persona);
void DeleteUsuario(int id);

#endif
