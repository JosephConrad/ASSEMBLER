all: 
	#nasm -g -f macho64 kl291649.asm
	nasm -f elf64 kl291649.asm
	gcc -Wall -c test1.c
	gcc -Wall kl291649.o test1.o -o kl291649 
	./kl291649
