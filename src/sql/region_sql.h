#ifndef REGION_SQL_H
#define REGION_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/region_json.h"

Region* ViewALLRegion(int* count);
Region CreateRegion(char* Codigo[2], char* Nombre[20]);
Region ObtainRegion(int id);
Region ModifyRegion(char* ID, char* Codigo[2], char* Nombre[20]);
void DeleteRegion(int id);

#endif
