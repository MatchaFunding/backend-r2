#ifndef ESTADODEFONDO_SQL_H
#define ESTADODEFONDO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/estadodefondo_json.h"

EstadoDeFondo* ViewALLEstadoDeFondo(int* count);
EstadoDeFondo CreateEstadoDeFondo(char* Codigo[3], char* Nombre[40]);
EstadoDeFondo ObtainEstadoDeFondo(int id);
EstadoDeFondo ModifyEstadoDeFondo(char* ID, char* Codigo[3], char* Nombre[40]);
void DeleteEstadoDeFondo(int id);

#endif
