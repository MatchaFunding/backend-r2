#include "tipodeempresa_sql.h"

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

TipoDeEmpresa* ViewAllTipoDeEmpresa(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM TipoDeEmpresa;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    TipoDeEmpresa* arr = malloc(sizeof(TipoDeEmpresa) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Codigo[4] = strdup(row[1]);
        arr[i].Nombre[50] = strdup(row[2]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

TipoDeEmpresa ObtainTipoDeEmpresa(int id) {
    TipoDeEmpresa obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM TipoDeEmpresa WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Codigo[4] = strdup(row[1]);
    obj.Nombre[50] = strdup(row[2]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteTipoDeEmpresa(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM TipoDeEmpresa WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
