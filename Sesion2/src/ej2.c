#include<sys/types.h>
#include<sys/stat.h>
#include<dirent.h>
#include<stdlib.h>
#include<stdio.h>
#include<errno.h>
#include<string.h>
#include <limits.h>

#include "utils.h"

int main(int argc, char *argv[])
{
    if(argc < 3) {
        fprintf(stderr, "\nUso: %s <path> <permisos en octal>\n\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    char *path  = (char*) ec_malloc(strlen(argv[1]));   
    strcpy(path, argv[1]);
    
    long permisos;
    char *str = argv[2];
    char *endptr;

    errno = 0;    /* To distinguish success/failure after call */
    permisos = strtol(str, &endptr, 8);

    if ((errno == ERANGE && (permisos == LONG_MAX || permisos == LONG_MIN))
            || (errno != 0 && permisos == 0)) {
        perror("strtol");
        exit(EXIT_FAILURE);
    }

    if (endptr == str) {
        fprintf(stderr, "No se han encontrado dígitos\n");
        exit(EXIT_FAILURE);
    }
    
    /* SI hemos llegado hasta aquí, el número para los permisos es correcto */

    DIR *directorio = opendir(path);
    if (directorio == NULL) 
        fatal("Abriendo el directorio");
    struct dirent *contenido = readdir(directorio); 
    if (contenido == NULL)
        fatal("Leyendo el directorio");
    struct stat atributos;

    /* Ignoramos . y .. */
    while(contenido->d_type == 0x4) 
        contenido = readdir(directorio);
    
    char* path_relativo = (char*) ec_malloc(strlen(path) + 256); //256 es la longitud maxima del nombre de un fichero, asi aseguramos que no hay buffer overflow
    
    while (contenido){
        strcpy(path_relativo, path);
        strcat(path_relativo, contenido->d_name);
        
        if (stat(path_relativo, &atributos) < 0)
            fatal("Obteniendo atributos del archivo");
        
        long permisos_antiguos = atributos.st_mode & (S_IRWXU | S_IRWXG | S_IRWXO); //0777
        
        if (chmod(path_relativo, permisos) < 0){
            fprintf(stderr, "Error cambiando permisos de %s con permisos %o, el error es %d :", 
                    contenido->d_name, permisos_antiguos, errno);
            perror(path_relativo);
        } else
            printf("%s: %o %o\n", contenido->d_name, permisos_antiguos, permisos); 

        contenido = readdir(directorio);
    }

    free(path);
    free(path_relativo);

    return 0;
}
