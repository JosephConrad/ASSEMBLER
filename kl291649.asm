DEFAULT REL
section .bss
    _s:     resb    4
    _w:     resb    4 
    _T:     resb    8 
   

section .text
    global start2               ; musi  byc zadeklarowny dla linkera (gcc)
    global run2


start2:
    push rbp
    mov rbp, rsp

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
    enter 0,0
    sub rsp, 100

    mov dword [rbp-4], edi      ; przenies z edi parametr do rbp - 4

    mov rax, [_T]               ; na rax daj wartosc pod adresem _T
    mov qword [rbp-48], rax     ; przypisz na rbp-48 to co w rax, czyli _T 

    mov rax, [_w]               ; przypisz do rax to co w _w
    shl rax, 3                  ; przesun bitowo w lewo o 3, pomnoz razy 8
    extern malloc
    call malloc                 ; wywolaj malloca
    mov [rbp-24], rax           ; zapisze wynik malloca w rbp-24
    mov qword [rbp-24], rax     ; nc cT przypisz wynik malloca ktory jest w rax


    mov dword [rbp-8], 0
MALLOC_LOOP:
    mov eax, dword [rbp-8]
    cmp eax, [_w]
    jge AFTER_MALLOC_LOOP

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
    jmp MALLOC_LOOP 

AFTER_MALLOC_LOOP:               ; kod ktory jest po petli z alokacja 

    mov rax, qword [rbp-24]      ; przenies do rejestru rax zmienna cT
    mov qword [rbp-32], rax      ; przypisz na zmienna fT rejestr rax

    mov dword [rbp-8], 0

FIRST_LOOP:
    mov eax, dword [rbp-8]
    cmp eax, dword [rbp-4]
    jge AFTER_FIRST_LOOP        ; jezeli i >= ile_krokow to wyskakuj z petli

    mov dword [rbp-16], 0
SECOND_LOOP:
    mov eax, dword [rbp-16]     ; wez wartosc spod adresu rbp-16
    cmp eax, [_w]
    jge AFTER_SECOND_LOOP

    mov dword [rbp-12], 0
THIRD_LOOP:
    mov eax, dword [rbp-12]
    cmp eax, [_s]
    jge AFTER_THIRD_LOOP

; ===============================================================================
;                    w srodku petli - sprawdzenie ifow
; ===============================================================================

AFTER_FIRST_IF:
    jmp STAR_IF

; ===============================================================================
;                    w srodku petli - aktualizacja pol gry w zycie
; ===============================================================================
   

STAR_IF: 

    movsxd rax, dword [rbp-12]
    movsxd rcx, dword [rbp-16]
    mov rdx, qword [rbp-48]
    mov rcx, [rdx+rcx*8]
    movzx rsi, byte [rcx+rax]
    mov rdx, 42

    cmp rsi, rdx
    jne UNDERSCORE_IF
 
    movsxd rsi, dword [rbp-12]
    movsxd rdi, dword [rbp-16] 
    mov rax, qword [rbp-24]
    mov rdi, [rax+rdi*8] 
    mov [rdi+rsi], byte 42

UNDERSCORE_IF:
    movsxd rax, dword [rbp-12]
    movsxd rcx, dword [rbp-16]
    mov rdx, qword [rbp-48]
    mov rcx, [rdx+rcx*8]
    movzx rsi, byte [rcx+rax]
    mov rdx, 95

    cmp rsi, rdx
    jne AFTER_STAR_IF
 
    movsxd rsi, dword [rbp-12]
    movsxd rdi, dword [rbp-16] 
    mov rax, qword [rbp-24]
    mov rdi, [rax+rdi*8] 
    mov [rdi+rsi], byte 95


AFTER_STAR_IF:
    jmp THIRD_LOOP_FINISH

THIRD_LOOP_FINISH:
    mov eax, dword [rbp-12]
    add eax, 1
    mov dword [rbp-12], eax
    jmp THIRD_LOOP

AFTER_THIRD_LOOP:
    jmp SECOND_LOOP_FINISH

SECOND_LOOP_FINISH:
    mov eax, dword [rbp-16]
    add eax, 1
    mov dword [rbp-16], eax
    jmp SECOND_LOOP

AFTER_SECOND_LOOP:
    jmp MEMCPY

MEMCPY:


; ===============================================================================
;                    podmieniam tablice na koncu ostatniej petli
; ===============================================================================

    mov dword [rbp-100], 0
MEMCPY_LOOP:
    mov eax, [rbp-100]
    cmp eax, [_w]
    jge FIRST_LOOP_FINISH 

    movsxd rax, dword [rbp-100]
    mov rdx, qword [rbp-48]
    mov rdi, [rdx+rax*8]
    movsxd rax, dword [rbp-100]
    mov rdx, qword [rbp-24]
    mov rsi, [rdx+rax*8]
    movsxd rdx, [_s] 
    extern memcpy
    call memcpy

    mov eax, dword [rbp-100]
    add eax, 1
    mov dword [rbp-100], eax
    jmp MEMCPY_LOOP

FIRST_LOOP_FINISH:

    mov eax, dword [rbp-8]
    add eax, 1
    mov dword [rbp-8], eax
    jmp FIRST_LOOP    


; ===============================================================================
;                    protokol koncowy
; ===============================================================================

AFTER_FIRST_LOOP: 
    leave
    ret
    
    
    
