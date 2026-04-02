code is in calculator.asm file
is made in nasm x86, no macros , just hardcoded
only can add number bellow 100
and just substract number between 1 and 9 for now

executable is in calculator file (no extension), just run ./calculator

to create your own executable, need to have nasm installed and run 

nasm -f elf32 calculator.asm 
ld -m elf_i386 calculator.o -o calculator 


