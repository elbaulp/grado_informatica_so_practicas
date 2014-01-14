#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/stat.h>

#define LOCK_FILE "lck.ej4"

/**
 * En este programa se pretende mostrar como usan los demonios
 * cerrojos para asegurarse que unicamente hay una instancia de 
 * ellos ejecutandose, para ello se establece un cerrojo de escritura
 * en /var/run
 */
int main(int argc, char *argv[])
{
    struct flock cerrojo;
    struct stat sf;
    int fd;

    if ((fd = open(LOCK_FILE, O_WRONLY | O_CREAT, S_IRWXU)) == -1){
       perror("Creando el fichero");
       exit(EXIT_FAILURE);
    }
    
    cerrojo.l_type = F_WRLCK;
    cerrojo.l_whence = SEEK_SET;
    cerrojo.l_start = 0;
    cerrojo.l_len = 0;
    cerrojo.l_pid = getpid();

    /* Bloquear el fichero completo */
    if (fcntl(fd, F_SETLK, &cerrojo) == -1){
        perror("Estableciendo cerrojo");
        exit(EXIT_FAILURE);
    }
    
    /* Comprobamos si existe el fichero */
    if (stat(LOCK_FILE, &sf) == -1 ){
        perror("stat");
        exit(EXIT_FAILURE);
    }

    if (sf.st_size != 0){
        printf("Error: otro proceso no ha finalizado correctamente el fichero, borralo\n");
        exit(EXIT_FAILURE);
    }

    char *pid;
    sprintf(pid, "%d", getpid());

    if (write(fd, pid, strlen(pid)) == -1){
        perror("Escribiendo en el cerrojo");
        exit(EXIT_FAILURE);
    }

    printf("Intenta ejecutar de nuevo el programa, no se podra debido a que se ha establecido el cerrojo, %s\n", pid);
    printf("Para finalizar pulsa enter");
    fgetc(stdin);
    
    /* Borrar el fichero */
    if ( close(fd) == -1 ){
        perror("close");
        exit(EXIT_FAILURE);
    }
    if (unlink(LOCK_FILE) == -1){
        perror("unlink");
        exit(EXIT_FAILURE);
    }
    return 0;
}



