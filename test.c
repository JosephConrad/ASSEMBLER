#include <stdio.h>
#include <stdlib.h>

#define MAX_SIZE 1024

//#include "zad1.c"
extern void start(int szer, int wys, unsigned char ** T);
extern void run(int ile_krokow);

void printTable(int s, int w, unsigned char ** T) {
	int i, j;
	for (i = 0; i < w; ++i) {
		for (j = 0; j < s; ++j){
			printf("%c ", T[i][j]);
		}
		printf("\n");
	}
	printf("\n\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
}

int main (int argc, char * argv[]) {

    printf("\nFirst assignment - Assebler\n\n");

    if ( argc != 2 ) { 
        printf( "usage: %s filename", argv[0] );
        return 0;
    }
    FILE *file = fopen(argv[1], "r");
	
    if ( file == 0 ) {
        printf( "Could not open file\n" );
        exit(EXIT_FAILURE);
    }
    
	int wys, szer, obroty, step;
    
    fscanf(file, "%d", &wys); 
    fscanf(file, "%d", &szer);
    fscanf(file, "%d", &obroty);  
    fscanf(file, "%d", &step); 
    
    
    unsigned char ** T;
	int k, i, j;

	T = malloc(sizeof(unsigned char *) * wys);
	for (i = 0; i < wys; ++i) {
		T[i] = malloc(sizeof(unsigned char) * szer);
	} 

	printf("\n\n%s\n\n", argv[0]);
	char buf;
 
 	for (i = 0; i < wys; i++) {
 		for (j = 0; j < szer; ++j){
 			fscanf(file, "%s", &T[i][j]); 
		}
		fgetc(file);
 	}

	start(szer, wys, (unsigned char **)T);
	printTable(szer, wys, T);

	for (k = 0; k < obroty; ++k) {
		run(step); 
		printTable(szer, wys, T);
 		
	}
	return 0;
}
