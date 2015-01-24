DEFAULT REL
section .bss
    _s:     resw    2
    _w:     resw    2 
    _T:     resw    4 
   

section .text
    global start2               ; musi  byc zadeklarowny dla linkera (gcc)
    global run2


start2:
    push rbp
    mov qword rbp, rsp

    mov dword [rbp-4], edi      ; przenies z edi do rbp - 4
    mov dword [rbp-8], esi      ; przenies z esi do rbp - 4
    mov qword [rbp-16], rdx     ; przenies z rdx do rbp - 4

    mov eax, dword [rbp-4]
    mov [_s], eax

    mov eax, dword [rbp-8]
    mov [_w], eax

    mov rdx, qword [rbp-16]
    mov [_T], rdx
    
    pop rbp
    ret
    
run2:
    push rbp
    mov rbp, rsp
    sub rsp, 48

    mov dword [rbp-4], edi      ; przenies z edi parametr do rbp - 4

    mov qword rax, [_T]         ; na rax daj adres _T
    mov qword [rbp-48], rax     ; przypisz na rbp-48 to co w rax, czyli _T 
   

    mov rax, [_w]               ; przypisz do rax to co w _w
    shl rax, 3                  ; przesun bitowo w lewo o 3, pomnoz razy 8
    extern malloc
    call malloc                 ; wywolaj malloca
    mov [rbp-24], rax           ; zapisze wynik malloca w rbp-24
    mov qword [rbp-24], rax     ; nc cT przypisz wynik malloca ktory jest w rax


    mov dword [rbp-8], 0
FOR_LOOP:
    mov eax, dword [rbp-8]
    cmp eax, [_w]
    jge AFTER_ALLOCATION

    movsxd rax, [_s]
    shl qword rax, 0
    mov rdi, rax
    extern malloc
    call malloc
    movsxd rdi, dword [rbp-8]
    mov rcx, qword [rbp-24]
    mov [rcx + rdi * 8], rax    ; zapisanie do pamieci o takim adresie to co jest w rejestrze rax

    mov eax, [rbp-8]
    add eax, 1
    mov dword [rbp-8], eax
    jmp FOR_LOOP


AFTER_ALLOCATION:               ; kod ktory jest po petli z alokacja
    mov rax, qword [rbp-24]     ; przenies do rejestru rax zmienna cT
    mov qword [rbp-32], rax     ; przypisz na zmienna fT rejestr rax
    
    add rsp, 48
    pop rbp
    ret
    
    
    
