#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <mysql.h>
#include "util.h"

int main() {
	char db[] = "MatchaFundingMySQL";
	char *host = getenv("MATCHA_HOST");
	char *user = getenv("MATCHA_USER");
	char *pass = getenv("MATCHA_PASS");

	MYSQL *con = mysql_init(NULL);

	if (mysql_real_connect(con, host, user, pass, db, 0, NULL, 0) == NULL) {
		fprintf(stderr, "%s\n", mysql_error(con));
		mysql_close(con);
		exit(1);
	}

	if (mysql_query(con, "SELECT * FROM Beneficiario")) {
		fprintf(stderr, "%s\n", mysql_error(con));
		mysql_close(con);
		exit(1);
	}

	MYSQL_ROW row;
	MYSQL_RES *res = mysql_store_result(con);
	int n_rows = mysql_num_rows(res);
	//int n_fields = mysql_num_fields(res);
	Beneficiario *b = malloc(sizeof(Beneficiario) * n_rows);

	for (int r = 0; r < n_rows; r++) {
		row = mysql_fetch_row(res);
		b[r].ID = (long long)row[0];
		strcpy(b[r].Nombre, row[1]);
		strcpy(b[r].FechaDeCreacion, row[2]);
		b[r].RegionDeCreacion = (long long)row[3];
		strcpy(b[r].Direccion, row[4]);
		b[r].TipoDePersona = (long long)row[5];
		b[r].TipoDeEmpresa = (long long)row[6];
		b[r].Perfil = (long long)row[7];
		strcpy(b[r].RUTdeEmpresa, row[8]);
		strcpy(b[r].RUTdeRepresentante, row[9]);
	}

	for (int r = 0; r < n_rows; r++) {
		printf("Beneficiario: %s\n", b[r].Nombre);
	}

	mysql_free_result(res);
	mysql_close(con);
	return 0;
}
