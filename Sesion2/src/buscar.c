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
    char *path;
    
    if (argc < 2){
        path = (char*) ec_malloc(2);
        strcpy(path, ".");
    }
    else{ 
        path = (char*) ec_malloc(strlen(argv[1]));
        strcpy(path, argv[1]);
    }
    
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
    
    char* path_relativo = (char*) ec_malloc(strlen(path) + 256); 
    //256 es la longitud maxima del nombre de un fichero, asi aseguramos que no hay buffer overflow

    size_t suma_total = 0;
    int contador_archivos = 0;
    
    while (contenido){
        strcpy(path_relativo, path);
        strcat(path_relativo, contenido->d_name);
        
        if (stat(path_relativo, &atributos) < 0)
            fatal("Obteniendo atributos del archivo");
        if (S_ISREG(atributos.st_mode) 
                && (atributos.st_mode & S_IRWXG & S_IXGRP) 
                && (atributos.st_mode & S_IRWXO & S_IXOTH)){
            printf("%s » %d\n", contenido->d_name, contenido->d_ino);
        }
        contenido = readdir(directorio);
    }

    free(path);
    free(path_relativo);

    return 0;
}
