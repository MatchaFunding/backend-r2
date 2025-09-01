#include "proyecto_sql.h"

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

Proyecto* ViewAllProyecto(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Proyecto;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Proyecto* arr = malloc(sizeof(Proyecto) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Titulo[300] = strdup(row[1]);
        arr[i].Descripcion[500] = strdup(row[2]);
        arr[i].DuracionEnMesesMinimo = atoi(row[3]);
        arr[i].DuracionEnMesesMaximo = atoi(row[4]);
        arr[i].Alcance = strdup(row[5]);
        arr[i].Area[100] = strdup(row[6]);
        arr[i].Beneficiario = strdup(row[7]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Proyecto ObtainProyecto(int id) {
    Proyecto obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Proyecto WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Titulo[300] = strdup(row[1]);
    obj.Descripcion[500] = strdup(row[2]);
    obj.DuracionEnMesesMinimo = atoi(row[3]);
    obj.DuracionEnMesesMaximo = atoi(row[4]);
    obj.Alcance = strdup(row[5]);
    obj.Area[100] = strdup(row[6]);
    obj.Beneficiario = strdup(row[7]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteProyecto(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Proyecto WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
