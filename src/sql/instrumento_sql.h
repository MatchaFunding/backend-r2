#ifndef INSTRUMENTO_SQL_H
#define INSTRUMENTO_SQL_H

#include <mysql/mysql.h>
#include <stdlib.h>
#include <string.h>

#include "../json/instrumento_json.h"

Instrumento* ViewALLInstrumento(int* count);
Instrumento CreateInstrumento(char* Titulo[200], char* Alcance, char* Descripcion[1000], char* FechaDeApertura, char* FechaDeCierre, int DuracionEnMeses, char* Beneficios[1000], char* Requisitos[1000], int MontoMinimo, int MontoMaximo, char* Estado, char* TipoDeBeneficio, char* TipoDePerfil, char* EnlaceDelDetalle[300], char* EnlaceDeLaFoto[300], char* Financiador);
Instrumento ObtainInstrumento(int id);
Instrumento ModifyInstrumento(char* ID, char* Titulo[200], char* Alcance, char* Descripcion[1000], char* FechaDeApertura, char* FechaDeCierre, int DuracionEnMeses, char* Beneficios[1000], char* Requisitos[1000], int MontoMinimo, int MontoMaximo, char* Estado, char* TipoDeBeneficio, char* TipoDePerfil, char* EnlaceDelDetalle[300], char* EnlaceDeLaFoto[300], char* Financiador);
void DeleteInstrumento(int id);

#endif
