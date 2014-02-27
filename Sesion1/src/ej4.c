#include<sys/types.h>
#include<unistd.h>
#include<sys/stat.h>
#include<stdio.h>
#include<errno.h>
#include<string.h>

#define MY_S_ISREG(mode) ((mode & S_IFMT ) == S_IFREG) 

int main(int argc, char *argv[])
{
int i;
struct stat atributos;
char tipoArchivo[30];

if(argc<2) {
	printf("\nSintaxis de ejecucion: tarea2 [<nombre_archivo>]+\n\n");
	exit(-1);
}
for(i=1;i<argc;i++) {
	printf("%s: ", argv[i]);
	if(lstat(argv[i],&atributos) < 0) {
		printf("\nError al intentar acceder a los atributos de %s",argv[i]);
		perror("\nError en lstat");
	}
	else {
        printf("Usado macro del sistema \n");
        if(S_ISREG(atributos.st_mode)) strcpy(tipoArchivo,"Regular");
        printf("%s\n",tipoArchivo);
        printf("Usando mi macro\n");
        if(MY_S_ISREG(atributos.st_mode)) strcpy(tipoArchivo,"My Regular");
        printf("%s\n",tipoArchivo);
	}
}

return 0;
}
