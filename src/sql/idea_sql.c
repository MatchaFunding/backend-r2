#include "idea_sql.h"

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

Idea* ViewAllIdea(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Idea;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Idea* arr = malloc(sizeof(Idea) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Usuario = strdup(row[1]);
        arr[i].Campo[1000] = strdup(row[2]);
        arr[i].Problema[1000] = strdup(row[3]);
        arr[i].Publico[1000] = strdup(row[4]);
        arr[i].Innovacion[1000] = strdup(row[5]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Idea ObtainIdea(int id) {
    Idea obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Idea WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Usuario = strdup(row[1]);
    obj.Campo[1000] = strdup(row[2]);
    obj.Problema[1000] = strdup(row[3]);
    obj.Publico[1000] = strdup(row[4]);
    obj.Innovacion[1000] = strdup(row[5]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteIdea(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Idea WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
