#ifndef IDEA_SQL_H
#define IDEA_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/idea_json.h"

Idea* ViewALLIdea(int* count);
Idea CreateIdea(char* Usuario, char* Campo[1000], char* Problema[1000], char* Publico[1000], char* Innovacion[1000]);
Idea ObtainIdea(int id);
Idea ModifyIdea(char* ID, char* Usuario, char* Campo[1000], char* Problema[1000], char* Publico[1000], char* Innovacion[1000]);
void DeleteIdea(int id);

#endif
