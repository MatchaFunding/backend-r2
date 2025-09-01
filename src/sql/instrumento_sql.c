#include "instrumento_sql.h"

MYSQL* get_connection() {
    MYSQL *conn = mysql_init(NULL);
    const char* db = getenv("MATCHA_MYSQL");
    const char* user = getenv("MATCHA_USER");
    const char* pass = getenv("MATCHA_PASS");
    if (!mysql_real_connect(conn, "localhost", user, pass, db, 0, NULL, 0)) {
        fprintf(stderr, "Connection failed: %s\n", mysql_error(conn));
        exit(1);
    }
    return conn;
}

Instrumento* ViewAllInstrumento(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Instrumento;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Instrumento* arr = malloc(sizeof(Instrumento) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Titulo[200] = strdup(row[1]);
        arr[i].Alcance = strdup(row[2]);
        arr[i].Descripcion[1000] = strdup(row[3]);
        arr[i].FechaDeApertura = strdup(row[4]);
        arr[i].FechaDeCierre = strdup(row[5]);
        arr[i].DuracionEnMeses = atoi(row[6]);
        arr[i].Beneficios[1000] = strdup(row[7]);
        arr[i].Requisitos[1000] = strdup(row[8]);
        arr[i].MontoMinimo = atoi(row[9]);
        arr[i].MontoMaximo = atoi(row[10]);
        arr[i].Estado = strdup(row[11]);
        arr[i].TipoDeBeneficio = strdup(row[12]);
        arr[i].TipoDePerfil = strdup(row[13]);
        arr[i].EnlaceDelDetalle[300] = strdup(row[14]);
        arr[i].EnlaceDeLaFoto[300] = strdup(row[15]);
        arr[i].Financiador = strdup(row[16]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Instrumento ObtainInstrumento(int id) {
    Instrumento obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Instrumento WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Titulo[200] = strdup(row[1]);
    obj.Alcance = strdup(row[2]);
    obj.Descripcion[1000] = strdup(row[3]);
    obj.FechaDeApertura = strdup(row[4]);
    obj.FechaDeCierre = strdup(row[5]);
    obj.DuracionEnMeses = atoi(row[6]);
    obj.Beneficios[1000] = strdup(row[7]);
    obj.Requisitos[1000] = strdup(row[8]);
    obj.MontoMinimo = atoi(row[9]);
    obj.MontoMaximo = atoi(row[10]);
    obj.Estado = strdup(row[11]);
    obj.TipoDeBeneficio = strdup(row[12]);
    obj.TipoDePerfil = strdup(row[13]);
    obj.EnlaceDelDetalle[300] = strdup(row[14]);
    obj.EnlaceDeLaFoto[300] = strdup(row[15]);
    obj.Financiador = strdup(row[16]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteInstrumento(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Instrumento WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
