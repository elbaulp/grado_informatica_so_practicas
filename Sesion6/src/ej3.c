#include<sys/types.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/stat.h>

/**
 * Este programa probara como actua el kernel al detectar interbloqueo
 * cuando intenta realizar E/S sobre un fichero que tiene un cerrojo
 * activo y ha sido creado con bloqueo obligatorio
 */
int main(int argc, char *argv[])
{
    /* Permisos necesarios */
    mode_t permisos = (S_ISGID & ~S_IXGRP) | S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH; //S_IRWXU;
    
    /* Creacion del fichero */
    int fd = open("bloqueoObligatorio", O_CREAT|O_TRUNC|O_RDWR, permisos);
    
    if (fd == -1){
        perror("Creando o abriendo el fichero");
        exit(EXIT_FAILURE);
    }
    /* En caso de que el fichero existiera, reseteamos los permisos */
    if ( fchmod(fd, permisos) == -1){
        perror("Estableciendo bloqueo obligatorio");
        exit(EXIT_FAILURE);
    }

    /* Escribir algo en el fichero y fijar el bit de bloqueo obligatorio */
    const char* msj = "linea1\nlinea2\nlinea3\n";

    if ( write(fd, msj, strlen(msj)) == -1){
        perror("Escribiendo en el archivo");
        exit(EXIT_FAILURE);
    }

    /* Intentamos escribir en un area con un cerrojo de lectura */
    /* Establecer el cerrojo */
    struct flock cerrojo;
    cerrojo.l_type = F_RDLCK; 
    cerrojo.l_whence = SEEK_SET;
    cerrojo.l_start = 0;    /* Bloquear desde el principio de la segunda linea */
    cerrojo.l_len = 0;      /* hasta el final de la segunda linea */
    cerrojo.l_pid = getpid();
    
    if ( fcntl(fd, F_SETLK, &cerrojo) == -1) {
        perror("Adquiriendo bloqueo");
        exit(EXIT_FAILURE);
    }

    /* Con el cerrojo de lectura, intentamos escribir en la segunda linea */
    if ( lseek(fd, 8, SEEK_SET) == -1){
        perror("Posicionando el puntero de escritura");
        exit(EXIT_FAILURE);
    }
    if ( write(fd, "g", 1) == -1){
        perror("Escribiendo");
        exit(EXIT_FAILURE);
    }

    sleep(800);
}



