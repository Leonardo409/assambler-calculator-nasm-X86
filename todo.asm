%macro print 2
  mov rax, 1
  mov edi, 1
  mov rsi, %1
  mov rdx, %2
  syscall
%endmacro


section .data
 welcome db 'what type of operation you like to do: ', 10
 lenw equ $ - welcome

 write db '1 - write a new task', 10
 lenwrite equ $ - write

 see db '2 - see all the tasks', 10
 lensee equ $ - see

 delete db '3 - delete a task', 10
 lendel equ $ - delete

 cleana db '4 - delete all the tasks', 10
 lenclean equ $ - cleana

 exit db '5 - exit', 10
 lenexit equ $ - exit

 invalid db '----invalid choice----', 10
 leninv equ $ - invalid

 tarea_eliminar db 'what task do you like to delete: ', 10
 lenTarea_eliminar equ $ - tarea_eliminar

 nl db 10
 filename db 'data.txt', 0
 lenfile equ $ -filename

 text db '- nueva tarea', 10
 lentext  equ $ - text
 

section .bss
 buffer resb 512
 buffer2 resb 1

section .text
 global _start

 _start:
  call menu
 
  mov al, byte  [buffer]
  
  cmp al, '1'
  je writel
  
  cmp al, '2'
  je seel
  
  cmp al, '3'
  je deletel

  cmp al, '4'
  je clean
  
  cmp al, '5'
  je end
  
  print invalid, leninv
  print nl, 1
  
  jmp _start
  
  writel:
  
; open file
  mov rax, 2
  mov rdi, filename
  mov rsi, 1 | 64 | 1024     
  mov rdx, 0644
  syscall

  mov r10, rax

  ; write text
  mov rax, 1
  mov rdi, r10
  mov rsi, text
  mov rdx, lentext
  syscall

; close file
  mov rax, 3
  mov rdi, r10
  syscall
  
  jmp end

  seel:
  ;open
  mov rax, 2         
  mov rdi, filename  
  mov rsi, 0          
  mov rdx, 0         
  syscall

  mov r10, rax
  ;read
  mov rax, 0          
  mov rdi, r10       
  mov rsi, buffer   
  mov rdx, 1024      
  syscall

  mov rbx, rax

  ;write
  mov rax, 1
  mov rdi, 1
  mov rsi, buffer
  mov rdx, rbx
  syscall

  ;close it
  mov rax, 3  
  mov rdi, r10
  syscall

  jmp end

  deletel:

  ; print tarea_eliminar, lenTarea_eliminar
  ; print nl, 1

  ; mov rax, 0        
  ; mov rdi, 0        
  ; mov rsi, buffer   
  ; mov rdx, 2        
  ; syscall

  ; mov cl, [buffer]

  ;open
  mov rax, 2        
  mov rdi, filename   
  mov rsi, 0         
  mov rdx, 0          
  syscall

  mov r10, rax

  ;read
  mov rax, 0        
  mov rdi, r10      
  mov rsi, buffer     
  mov rdx, 512       
  syscall

  mov r13, rax
  xor r14, r14
  xor r12, r12
  xor r11, r11

  print_loop:
  cmp r12, r13
  jge closeit
  mov al, byte [buffer + r12]
  cmp al, '2'
  ; break:
  je skip
  mov byte [buffer2 + r11], al
  inc r11
  
  ; mov [rsi], r11
  ; mov rax, 1
  ; mov rdi, 1
  ; mov rdx, 1
  ; syscall

  inc r12

  jmp print_loop

  skip:
  inc r14
  cmp r12, r13
  jge closeit
  mov bl, byte [buffer + r12]
  inc r12
  cmp bl, 10
  je print_loop
  jmp skip

  ;close it
  closeit:
  mov rax, 3  
  mov rdi, r10
  syscall

  mov rax, 2             
  mov rdi, filename       
  mov rsi, 513            
  mov rdx, 0              
  syscall

  mov r10, rax
  sub r13, r14
  
  mov rax, 1
  mov rdi, r10
  mov rsi, buffer2
  mov rdx, r13
  syscall

  mov rax, 3
  mov rdi, r10
  syscall

  

  jmp end


  clean:
  mov rax, 2                 
  mov rdi, filename
  mov rsi, 1 | 512            
  mov rdx, 0
  syscall

  mov r12, rax                

  ; cerrar
  mov rax, 3
  mov rdi, r12
  syscall

  jmp end
  
  end:
  mov rax, 60         
  xor rdi, rdi        
  syscall


  menu:
  print welcome, lenw
  print nl, 1
  
  print write, lenwrite
  print nl, 1
  
  print see, lensee
  print nl, 1
  
  print delete, lendel
  print nl, 1

  print cleana, lenclean
  print nl, 1
  
  print exit, lenexit
  print nl, 1

  mov rax, 0        
  mov rdi, 0        
  mov rsi, buffer   
  mov rdx, 2        
  syscall
  
  ret





