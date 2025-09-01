typedef struct {
    long long ID;
    char Titulo[200];
    long long Alcance;
    char Descripcion[1000];
    char FechaDeApertura;
    char FechaDeCierre;
    int DuracionEnMeses;
    char Beneficios[1000];
    char Requisitos[1000];
    int MontoMinimo;
    int MontoMaximo;
    long long Estado;
    long long TipoDeBeneficio;
    long long TipoDePerfil;
    char EnlaceDelDetalle[300];
    char EnlaceDeLaFoto[300];
    long long Financiador;
} Instrumento;
