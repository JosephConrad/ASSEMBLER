DEFAULT REL
section .bss
    _s:     resw    2
    _w:     resw    2 
    _T:     resw    4 
   

section .text
global start 
global run
start:
    push rbp
    mov qword rbp, rsp

    mov dword [rbp-4], edi
    mov dword [rbp-8], esi
    mov qword [rbp-16], rdx

    mov esi, dword [rbp-4]
    mov [_s], esi

    mov esi, dword [rbp-8]
    mov [_w], esi

    mov rdx, qword [rbp-16]
    mov [_T], rdx
    
    pop rbp
    ret 
    
    
run:
    push rbp
    mov qword rbp, rsp
   
    sub rsp, 64
 
    mov dword [rbp-4], edi
    mov rax, qword [_T]
    mov qword [rbp-48], rax
    

    movsxd rax, [_w]            ; wrzuc wartosc zmiennej _w i wrzuca do raxa + zmiena z 4 bitow na 8
    shl qword rax, 3            ; przesuniecie bitowe w lewo o 3
    mov rdi, rax  
    extern malloc
    call malloc                ; wywolujemy funkcje malloc
    mov qword [rbp-24], rax     ; do raxa wrzucamy zmienna o przesunieciu 24 wzgledem wskaznika bazowego
                                ; funkcja zawsze sie returnuje do raxa i to co w raxie wrzucam do 
    
    ;================ LOOP ===================
BeforeLoop1:
    mov eax, dword [rbp-8]
    cmp eax, [_w]  
    jge AfterLoop1

; in loop
    movsxd rax, [_s]  
    shl qword rax, 0
    mov rdi, rax
    extern malloc
    call malloc 
    movsxd rdi, [rbp-8]
    mov rcx, [rbp-24] 
    mov [rcx + 8 * rdi], rax

; adding to condition 
    mov eax, dword [rbp-8]
    add eax, 1
    mov dword [rbp-8], eax
    jmp BeforeLoop1



AfterLoop1:
    ;mov [rbp-8], 0
    

BeforeLoop2:
    mov eax, dword [rbp-8]
    cmp eax, [_w]
    jge AfterLoop2

    

AfterLoop2:






; =============== epilog ========================
    add rsp, 64

    pop rbp
    ret
    
    
    
