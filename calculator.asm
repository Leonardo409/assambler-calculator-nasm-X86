%macro input 1
    mov eax,3            
	mov ebx,0          
	mov ecx,%1       
	mov edx,4     
	int 0x80 
%endmacro

%macro print 2
    mov eax,4            
	mov ebx,1           
	mov ecx,%1     
	mov edx,%2    
	int 0x80 
%endmacro
section .bss
    num1 resb 10
    num2 resb 10
    num3 resb 10
    num4 resb 10
    num5 resb 10
   
section .data
    msg1 db "type first number: ", 0
    len1 equ $ - msg1
    msg2 db "type second number: ", 0
    len2 equ $ - msg2
    msg3 db "type operation: ", 0
    len3 equ $ - msg3

    msg4 db "must be a 2-digit number, start over.... ", 0Dh, 0Ah
    len4 equ $ - msg4

    msg5 db "wrong operation, start over... ", 0Dh, 0Ah
    len5 equ $ - msg5  

    salto db 0Dh, 0Ah
    lenSalto equ $ - salto

section .text
	global _start

_start:
;==========================

    print msg1, len1
	input num1 
    print msg3, len3
    input num3
    print msg2, len2
    input num2

;==========================	

	mov cl, [num1]
	sub cl, '0'
	
	mov bl, [num1+1]      
	
	mov ah, [num2]
	sub ah, '0'

	mov bh, [num2+1]     
	
    mov al, [num3]

;============ Compare operations ==============	

    cmp al, '-'
    je resta_simple
    
    cmp al, '+'
    je double_digit_check

    double_digit_check:
    cmp bl, 0x0A
    je suma_simple

    jump_check:
    cmp bh, 0x0A
    je suma_simple

;============= Double digit sum =============	
    
    sub bl, '0' 
    sub bh, '0' 

    suma_plus:
	add bl, bh
	add cl, ah
	
	movzx ax, bl
	mov dx, 0
	mov bx, 10
    div bx
	
	add cl, al
    add cl, "0"
	add dl, "0"

	mov[num5], cl
	mov[num5+1], dl
	
    print num5, 4 
    print salto, lenSalto
    jmp salida

;=========== Suma ===============	

    suma_simple:

    cmp bh, 0x0A
    jne bh_double_digit

    cmp bl, 0x0A
    jne bl_double_digit

    add cl, ah
    cmp cl, 9
    jg double_digit_result
    add cl, "0"
    mov [num5], cl
    print num5, 1
    print salto, lenSalto
    jmp salida

    double_digit_result:
    movzx ax, cl
	mov dx, 0
	mov bx, 10
    div bx

    add al, "0"
	add dl, "0"

	mov[num5], al
	mov[num5+1], dl

    print num5, 4 
    print salto, lenSalto
    jmp salida

    bh_double_digit:
    sub bh, '0'
    add bh, cl
    cmp bh, 10
    jg bh_double_digit_result
    add ah, "0"
    add bh, "0"

    mov [num5], ah
    mov [num5+1], bh

    print num5, 2
    print salto, lenSalto
    jmp salida

    bh_double_digit_result:
    mov cl, ah
    movzx ax, bh
	mov dx, 0
	mov bx, 10
    div bx

    add al, cl

    add al, "0"
	add dl, "0"

	mov[num5], al
	mov[num5+1], dl

    print num5, 4 
    print salto, lenSalto
    jmp salida

    bl_double_digit:
    sub bl, '0'
    add bl, ah
    cmp bl, 10
    jg bl_double_digit_result
    add cl, "0"
    add bl, "0"

    mov [num5], cl
    mov [num5+1], bl

    print num5, 2
    print salto, lenSalto
    jmp salida

    bl_double_digit_result:
    movzx ax, bl
	mov dx, 0
	mov bx, 10
    div bx

    add cl, al

    add cl, "0"
	add dl, "0"

	mov[num5], cl
	mov[num5+1], dl

    print num5, 4 
    print salto, lenSalto
    jmp salida

;========== Resta ================	

    resta_simple:
    sub cl, ah
    cmp cl, 0
    jl double_digit_result
    add cl, "0"
    mov [num5], cl
    print num5, 1
    print salto, lenSalto
    jmp salida

;==========================	

    debe_ser_de_dos_digitos:
    print msg4, len4
    jmp _start

    salida:
    mov eax,1        
	mov ebx,0           
	int 80h;

