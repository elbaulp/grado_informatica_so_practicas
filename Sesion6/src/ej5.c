#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv)
{
	int	fd;
	char *ptr;
	struct stat st;

    if (argc != 3){
        printf("Uso: %s <src> <dst>", argv[0]);
        exit(EXIT_FAILURE);
    }

	fd = open(argv[1], O_RDONLY);
    if (fd == -1){
        perror("en open");
        exit(EXIT_FAILURE);
    }
    
    if (fstat(fd, &st)){
        perror("en stat");
        exit(EXIT_FAILURE);
    }

    if(!S_ISREG(st.st_mode)){
        printf("No es regular");
        exit(EXIT_FAILURE);
    }

	ptr = (char*) mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	close(fd);

    if (ptr == MAP_FAILED){
        perror("En mmap");
        exit(EXIT_FAILURE);
    }
	
    int copy = open(argv[2], O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
    if (copy == -1){
        perror("Creando fichero destino");
        exit(EXIT_FAILURE);
    }

    if (ftruncate(copy, st.st_size) == -1){
        perror("ftruncate");
        exit(EXIT_FAILURE);
    }
    
    char *ptr2 = (char*) mmap(NULL, st.st_size, PROT_WRITE, MAP_SHARED, copy, 0);
    
    if (ptr2 == MAP_FAILED){
        perror("En mmap");
        exit(EXIT_FAILURE);
    }

    close(copy);
    memcpy(ptr2, ptr, st.st_size);

	exit(0);
}
