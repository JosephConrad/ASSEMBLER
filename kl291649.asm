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
    push rbp
    mov rbp, rsp
    sub rsp, 64

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
    mov rax, qword [rbp-24]     ; przenies do rejestru rax zmienna cT
    mov qword [rbp-32], rax     ; przypisz na zmienna fT rejestr rax

    mov dword [rbp-8], 0

    ; mov rsi, 0
    ; mov rdi, 0
    ; mov r8, qword [rbp-48]
    ; mov rdi, [r8+rdi*8]
    ; mov [rdi+rsi], byte 88

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

    mov dword [rbp-52], 0         ; przypisanie na l 0

    cmp dword [rbp-12], 0
    jle AFTER_FIRST_IF

    mov eax, dword [rbp-12]
    sub eax, 1
    movsxd rcx, eax 
    movsxd rdx, dword [rbp-16]
    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    mov eax, [rdx+rcx]              ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp eax, 42                     ; porownaj to co jest w cT2[y][x-1] z tym *
    jne AFTER_FIRST_IF              ; jesli nie jest rowna

    mov eax, dword [rbp-52]
    add eax, 1
    mov dword [rbp-52], eax 



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
    mov esi, [rcx+rax]
    cmp esi, 0
    jne AFTER_STAR_IF



    movsxd rsi, dword [rbp-12]
    movsxd rdi, dword [rbp-16]
    mov r8, qword [rbp-24]
    mov rdi, [r8+rdi*8]
    mov [rdi+rsi], byte 42  





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
    jmp FIRST_LOOP_FINISH

FIRST_LOOP_FINISH:


; ===============================================================================
;                    podmieniam tablice na koncu ostatniej petli
; ===============================================================================

    mov rax, qword [rbp-48]
    mov qword [rbp-40], rax
    mov rax, qword [rbp-24]
    mov qword [rbp-48], rax
    mov rax, qword [rbp-40]
    mov qword [rbp-24], rax

    mov eax, dword [rbp-8]
    add eax, 1
    mov dword [rbp-8], eax
    jmp FIRST_LOOP    

AFTER_FIRST_LOOP:

    add rsp, 64
    pop rbp
    ret
    
    
    
