#include<sys/types.h>
#include<sys/stat.h>
#include<dirent.h>
#include<stdlib.h>
#include<stdio.h>
#include<errno.h>
#include<string.h>
#include <limits.h>

#include "utils.h"

void explorar_directorio(char *path, char *path_relativo, size_t *suma_total, int *contador_archivos){

    DIR *directorio = opendir(path);
    if (directorio == NULL) 
        fatal("Abriendo el directorio");
    struct dirent *contenido = readdir(directorio); 
    if (contenido == NULL)
        fatal("Leyendo el directorio");

    struct stat atributos;
    
    while (contenido){
     
        while (strcmp(contenido->d_name, ".") == 0 || strcmp(contenido->d_name, "..") == 0)
            contenido = readdir(directorio);

        strcpy(path_relativo, path);
        strcat(path_relativo, contenido->d_name);
        
        if (stat(path_relativo, &atributos) < 0)
            fatal("Obteniendo atributos del archivo");
        if (S_ISREG(atributos.st_mode) 
                && (atributos.st_mode & S_IRWXG & S_IXGRP) 
                && (atributos.st_mode & S_IRWXO & S_IXOTH)){
            printf("%s » %d\n", path_relativo, contenido->d_ino);
            *(contador_archivos) +=1;
            *suma_total += atributos.st_size;
        } else if (S_ISDIR(atributos.st_mode)){
            strcat(path_relativo, "/");
            char *aux = (char*) ec_malloc(strlen(path));
            /* Para guardar el valor anterior del path al volver de la llamada recursiva */
            strcpy(aux, path);
            explorar_directorio(path_relativo, path, suma_total, contador_archivos);
            strcpy(path, aux);
            free(aux);
        }
        contenido = readdir(directorio);
    }
}
    
int main(int argc, char *argv[])
{
    char *path;
    
    if (argc < 2){
        path = (char*) ec_malloc(2);
        strcpy(path, ".");
    }
    else{ 
        path = (char*) ec_malloc(strlen(argv[1]) + 256);
        strcpy(path, argv[1]);
    }
    
    
    char *path_relativo = (char*) ec_malloc(strlen(path) + 256); 
    //256 es la longitud maxima del nombre de un fichero, asi aseguramos que no hay buffer overflow
    
    size_t suma_total = 0;
    int contador_archivos = 0;
    
    printf("Los i-nodos son\n");
    explorar_directorio(path, path_relativo, &suma_total, &contador_archivos);
    printf("Existen %d archivos regulares con permiso x para grupo y otros\
 El tamaño total ocupado por dichos archivos es %d bytes.\n", contador_archivos, suma_total);

    free(path);
    free(path_relativo);

    return 0;
}
