#include<sys/types.h>  	
#include<sys/stat.h>
#include<fcntl.h>
#include<stdlib.h>
#include<stdio.h>
#include<errno.h>
#include<unistd.h>
#include<string.h>
#include<limits.h>

void print_error(char *where){
    printf("\nError %d en %s",errno, where);
    perror("\nError");
    exit(-1);
}

int main(int argc, char *argv[]) {
    int fd;
    if (argc < 2){
        printf("Uso: %s <nombre_fichero> ", argv[0]);
        exit(-1);
    }

    if( (fd=open(argv[1],O_RDONLY))<0) {
    }
    
    /* Crear el archivo donde se escribira el contenido */
    uint fd_salida;
 
    if( (fd_salida = open("dump",O_CREAT|O_TRUNC|O_WRONLY,S_IRUSR|S_IWUSR))<0) 
        print_error("open");

    char myBuff[80];
    unsigned int i = 1;
    char bloque[11];
    int leido;
    
    char *resumen = "El número de bloques es %d";

    if (lseek(fd_salida, 50, SEEK_SET) < 0 )
        print_error("lseek");

    while ((leido = read(fd, myBuff, 80)) > 0){
        sprintf(bloque, "\nBloque %d\n", i++);
        write(fd_salida, bloque, 11);
        write(fd_salida, myBuff, leido);
    }

    if(lseek(fd_salida, 0, SEEK_SET) < 0)
        print_error("lseek");

    sprintf(bloque, "El número de bloques es %d", i-1);
    write(fd_salida, bloque, strlen(bloque));

    if(close(fd_salida) < 0)
        print_error("close");
    if(close(fd) < 0 )
        print_error("close");

    return 0;
}
