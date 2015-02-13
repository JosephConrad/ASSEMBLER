all: 
	nasm -g -f elf64 kl291649.asm
	gcc -o test -Wall -g kl291649.o test.c
