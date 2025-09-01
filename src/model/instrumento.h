typedef struct {
    long long id;
    char titulo[200];
    long long alcance;
    char descripcion[1000];
    char fechadeapertura;
    char fechadecierre;
    int duracionenmeses;
    char beneficios[1000];
    char requisitos[1000];
    int montominimo;
    int montomaximo;
    long long estado;
    long long tipodebeneficio;
    long long tipodeperfil;
    char enlacedeldetalle[300];
    char enlacedelafoto[300];
    long long financiador;
} instrumento;
