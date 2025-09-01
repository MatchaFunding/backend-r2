#include "postulacion_sql.h"

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

Postulacion* ViewAllPostulacion(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Postulacion;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Postulacion* arr = malloc(sizeof(Postulacion) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Resultado[30] = strdup(row[1]);
        arr[i].MontoObtenido = atoi(row[2]);
        arr[i].FechaDePostulacion = strdup(row[3]);
        arr[i].FechaDeResultado = strdup(row[4]);
        arr[i].Detalle[1000] = strdup(row[5]);
        arr[i].Beneficiario = strdup(row[6]);
        arr[i].Instrumento = strdup(row[7]);
        arr[i].Proyecto = strdup(row[8]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Postulacion ObtainPostulacion(int id) {
    Postulacion obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Postulacion WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Resultado[30] = strdup(row[1]);
    obj.MontoObtenido = atoi(row[2]);
    obj.FechaDePostulacion = strdup(row[3]);
    obj.FechaDeResultado = strdup(row[4]);
    obj.Detalle[1000] = strdup(row[5]);
    obj.Beneficiario = strdup(row[6]);
    obj.Instrumento = strdup(row[7]);
    obj.Proyecto = strdup(row[8]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeletePostulacion(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Postulacion WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
