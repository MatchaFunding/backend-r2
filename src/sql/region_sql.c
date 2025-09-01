#include "region_sql.h"

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

Region* ViewAllRegion(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Region;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Region* arr = malloc(sizeof(Region) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Codigo[2] = strdup(row[1]);
        arr[i].Nombre[20] = strdup(row[2]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Region ObtainRegion(int id) {
    Region obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Region WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Codigo[2] = strdup(row[1]);
    obj.Nombre[20] = strdup(row[2]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteRegion(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Region WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
