#include "beneficiario_sql.h"

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

Beneficiario* ViewAllBeneficiario(int* count) {
    MYSQL* conn = get_connection();
    if (mysql_query(conn, "SELECT * FROM Beneficiario;")) {
        fprintf(stderr, "%s\n", mysql_error(conn));
    }
    MYSQL_RES *res = mysql_store_result(conn);
    *count = mysql_num_rows(res);
    Beneficiario* arr = malloc(sizeof(Beneficiario) * (*count));
    MYSQL_ROW row;
    int i = 0;
    while ((row = mysql_fetch_row(res))) {
        arr[i].ID = strdup(row[0]);
        arr[i].Nombre[100] = strdup(row[1]);
        arr[i].FechaDeCreacion = strdup(row[2]);
        arr[i].RegionDeCreacion = strdup(row[3]);
        arr[i].Direccion[300] = strdup(row[4]);
        arr[i].TipoDePersona = strdup(row[5]);
        arr[i].TipoDeEmpresa = strdup(row[6]);
        arr[i].Perfil = strdup(row[7]);
        arr[i].RUTdeEmpresa[12] = strdup(row[8]);
        arr[i].RUTdeRepresentante[12] = strdup(row[9]);
        i++;
    }
    mysql_free_result(res);
    mysql_close(conn);
    return arr;
}

Beneficiario ObtainBeneficiario(int id) {
    Beneficiario obj;
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "SELECT * FROM Beneficiario WHERE ID=%d;", id);
    mysql_query(conn, query);
    MYSQL_RES* res = mysql_store_result(conn);
    MYSQL_ROW row = mysql_fetch_row(res);
    obj.ID = strdup(row[0]);
    obj.Nombre[100] = strdup(row[1]);
    obj.FechaDeCreacion = strdup(row[2]);
    obj.RegionDeCreacion = strdup(row[3]);
    obj.Direccion[300] = strdup(row[4]);
    obj.TipoDePersona = strdup(row[5]);
    obj.TipoDeEmpresa = strdup(row[6]);
    obj.Perfil = strdup(row[7]);
    obj.RUTdeEmpresa[12] = strdup(row[8]);
    obj.RUTdeRepresentante[12] = strdup(row[9]);
    mysql_free_result(res);
    mysql_close(conn);
    return obj;
}

void DeleteBeneficiario(int id) {
    MYSQL* conn = get_connection();
    char query[256];
    sprintf(query, "DELETE FROM Beneficiario WHERE ID=%d;", id);
    mysql_query(conn, query);
    mysql_close(conn);
}
