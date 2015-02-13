#include <stdio.h>
#include <stdlib.h>

//#include "zad1.c"
extern void start(int szer, int wys, unsigned char ** T);
extern int run(int ile_krokow);

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

int main () {

	int szer = 100;
	int wys = 100;
	unsigned char ** T;

	int k, i, j;

	T = malloc(sizeof(unsigned char *) * wys);
	for (i = 0; i < wys; ++i) {
		T[i] = malloc(sizeof(unsigned char) * szer);
	}


	printf("\n\nTest nr 1\n\n");


	for (i = 0; i < wys; ++i) {
		for (j = 0; j < szer; ++j){
			T[i][j] = '_';
		} 
	}

	for (i = 0; i < wys; ++i) {
		for (j = 0; j < szer; ++j){
			if ((i+j) % 2 == 0)
				T[i][j] = '*';
		} 
	}
	start(szer, wys, (unsigned char **)T);
 

	printTable(szer, wys, T);

	for (k = 0; k < 15; ++k) {
		int a= run(1);

		printf("%d\n", a);
		printTable(szer, wys, T);
 		
	}

	printf("\n\nTest nr 2\n\n");
	szer = 20;
	wys = 20;

	T = malloc(sizeof(unsigned char *) * wys);
	for (i = 0; i < wys; ++i) {
		T[i] = malloc(sizeof(unsigned char) * szer);
	}

	for (i = 0; i < wys; ++i) {
		for (j = 0; j < szer; ++j){
			T[i][j] = '_';
		} 
	}

	for (i = 0; i < szer; i++) {
		T[0][i] = '*'; 
		T[2][i] = '*'; 
		T[4][i] = '*'; 
	}


	start(szer, wys, (unsigned char **)T);

 	//printTable(szer, wys, T);

	for (k = 0; k < 3; ++k) {
		int a= run(1);

		printf("%d\n", a);
 		//printTable(szer, wys, T);
	}

	// printf("\n\nTest nr 3\n\n");

	// for (i = 0; i < wys; ++i) {
	// 	for (j = 0; j < szer; ++j){
	// 		T[i][j] = '_';
	// 	} 
	// }

	// for (i = 0; i < wys; ++i) {
	// 	for (j = 0; j < szer; ++j){
	// 		if ((i+j) % 2 == 0)
	// 			T[i][j] = '*';
	// 	} 
	// }

	// start(szer, wys, (unsigned char **)T);

 // 	printTable(szer, wys, T);

	// for (k = 0; k < 6; ++k) {
	// 	run(1);
 // 		printTable(szer, wys, T);
	// }

	return 0;
}
