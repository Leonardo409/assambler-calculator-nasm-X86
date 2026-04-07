section .data
 msg db '157', 10
 len equ $ - msg

 nl db 10

section .bss
 count resb 10
 buffer resb 3

section .text
 global _start

 _start:
  mov rbp, msg
  mov r8, 0
  mov r9, 0
  mov r10, 0
 
  init:
   mov al, byte [rbp]
   cmp al, 10
   je prep_conver
   inc rbp
   inc r8
   inc r10
  jmp init
 
  prep_conver:
  mov r15, msg
  convertion:
   xor rax, rax
   sub r8, 1
   mov cl, byte [r15]
   inc r15
   sub cl, '0'
   call expo
  
  expo:
    mov rax, 1
    mov rsi, r8
    mov rdi, 10
    pow_loop:
    cmp rsi, 0
    je suma
    mul rdi
    dec rsi
    jmp pow_loop
    ret
 
  suma:
   imul rax, rcx
   add r9, rax
   cmp r8, 0
   jne convertion

   add r9, 56

   sub r10, 1
   mov r12, r10
   mov rcx, 1
   prep_div:
   cmp r10, 0
   je division
   imul rcx, rcx, 10
   dec r10
   jmp prep_div
  
 
   division:
   xor rax, rax
   mov rax, r9

   start_div:
   cmp r12, 0
   je print
   div rcx
   dec r12
  ; mov r13, rax   ;this print values like 106 or 305
   cmp rax, 9
   jg less_than_100
   cmp rdx, 9
   jle print
  
  mov r13, rax  ;this print every other value
  mov rax, rdx
  xor rdx, rdx
  mov rcx, 1
  Imul rcx, rcx, 10
  jmp start_div
 
  print:
   ;mov rax, 0    ;this print values like 106 or 305  
   mov rbx, r13
  cmp bl, 0
  je print_excep
  
   add bl, "0"
   add al, "0"
   add dl, "0"
  
  mov byte [buffer], bl
  mov byte [buffer+1], al
  mov byte [buffer+2], dl


  show:

   mov rax, 1
   mov edi, 1
   mov rsi, buffer
   mov rdx, 3
   syscall
  
   mov rax, 1      ; sys_write
   mov rdi, 1      ; stdou  mov rsi, nl
   mov rsi, nl
   mov rdx, 1
   syscall
 
   mov rax, 60         ; syscall: sys_exit
    xor rdi, rdi        ; exit code: 0
   syscall

  print_excep:
   add bl, "0"
   add al, "0"
   add dl, "0"
  
  cmp al, ':'
  je dots
  
  mov byte [buffer], al
  mov byte [buffer+1], bl
  mov byte [buffer+2], dl 
  
  jmp show
  
  dots:
  mov byte [buffer], '1'
  mov byte [buffer+1], bl
  mov byte [buffer+2], dl 
  
  jmp show


 less_than_100:
 mov rbx, rdx 
 xor rdx, rdx
 mov rcx, 10
 div rcx
 
   add bl, "0"
   add al, "0"
   add dl, "0"
  
  mov byte [buffer], al
  mov byte [buffer+1], dl
  mov byte [buffer+2], bl
 
 jmp show





