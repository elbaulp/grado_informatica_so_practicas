#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>

int main(int argc, char *argv[])
{
    int fd[2];
    pid_t PID;

    pipe(fd); // Llamada al sistema para crear un pipe

    if (argc != 4){
        printf("Uso: %s <programa1> | <programa2>\n", argv[0]);
        exit(-1);
    }

    char *programa_1 = argv[1];
    char *programa_2 = argv[3];

    if ( (PID= fork())<0) {
        perror("\Error en fork");
        exit(-1);
    }
    if (PID == 0) { // ls
        //Cerrar el descriptor de lectura de cauce en el proceso hijo
        close(fd[0]);

        //Duplicar el descriptor de escritura en cauce en el descriptor
        //correspondiente a la salida estda r (stdout), cerrado previamente en
        //la misma operación
        if (fcntl(fd[1], F_DUPFD, STDOUT_FILENO) == -1 ){
            perror ("fcntl falló");
            exit(-1);
        }
        execlp(programa_1,programa_1,NULL);
    }
    else { // sort. Proceso padre porque PID != 0.
        //Cerrar el descriptor de escritura en cauce situado en el proceso padre
        close(fd[1]);

        //Duplicar el descriptor de lectura de cauce en el descriptor
        //correspondiente a la entrada estándar (stdin), cerrado previamente en
        //la misma operación
        if (fcntl(fd[0], F_DUPFD, STDIN_FILENO) == -1 ){
            perror ("fcntl falló");
            exit(-1);
        }
        execlp(programa_2,programa_2,NULL);
    }

    return(0);
}

