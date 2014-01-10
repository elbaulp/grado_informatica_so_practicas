#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char *argv[]) {

    if (argc < 4){
        printf("Uso: %s <programa> <<|>> <fichero>.\n", argv[0]);
        exit(-1);
    }    
    
    char redireccion = argv[2][0];
    int fd;
    
    switch(redireccion){
        case '<':
            /* Proporcionamos los datos al programa desde el fichero indicado */
            close(STDIN_FILENO);
            if ((fd = open(argv[3], O_RDONLY)) == -1){
                perror("open");
                exit(-1);
            }
            if (fcntl(fd, F_DUPFD, STDIN_FILENO) == -1 ){
                perror ("fcntl falló");
                exit(-1);
            }
            if( (execlp(argv[1],argv[1], NULL)<0)) {
	            perror("Error en el execl\n");
	            exit(-1);
            }
            
            break;
        case '>':
            /* Escribiremos la salida del programa al fichero indicado */
            
            close(STDOUT_FILENO);
            if ((fd = open(argv[3], O_WRONLY | O_TRUNC | O_CREAT)) == -1){
                perror("open");
                exit(-1);
            }
            if (fcntl(fd, F_DUPFD, STDOUT_FILENO) == -1 ){
                perror ("fcntl falló");
                exit(-1);
            }
            if( (execlp(argv[1],argv[1], NULL)<0)) {
	            perror("Error en el execl\n");
	            exit(-1);
            }
            break;
    }
	
    exit(0);
}
