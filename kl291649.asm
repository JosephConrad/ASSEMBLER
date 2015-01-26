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

    mov dword [rbp-4], edi        ; przenies z edi do rbp - 4
    mov dword [rbp-8], esi        ; przenies z esi do rbp - 4
    mov qword [rbp-16], rdx       ; przenies z rdx do rbp - 4

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

    mov dword [rbp-4], edi        ; przenies z edi parametr do rbp - 4

    mov rax, [_T]                 ; na rax daj wartosc pod adresem _T
    mov qword [rbp-48], rax       ; przypisz na rbp-48 to co w rax, czyli _T 

    mov rax, [_w]                 ; przypisz do rax to co w _w
    shl rax, 3                    ; przesun bitowo w lewo o 3, pomnoz razy 8
    extern malloc
    call malloc                   ; wywolaj malloca
    mov [rbp-24], rax             ; zapisze wynik malloca w rbp-24
    mov qword [rbp-24], rax       ; nc cT przypisz wynik malloca ktory jest w rax


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
    mov [rcx + rdi * 8], rax      ; zapisanie do pamieci o takim adresie to co jest w rejestrze rax

    mov eax, [rbp-8]
    add eax, 1
    mov dword [rbp-8], eax
    jmp MALLOC_LOOP 

AFTER_MALLOC_LOOP:                ; kod ktory jest po petli z alokacja 

    mov rax, qword [rbp-24]       ; przenies do rejestru rax zmienna cT
    mov qword [rbp-32], rax       ; przypisz na zmienna fT rejestr rax

    mov dword [rbp-8], 0

FIRST_LOOP:
    mov eax, dword [rbp-8]
    cmp eax, dword [rbp-4]
    jge AFTER_FIRST_LOOP          ; jezeli i >= ile_krokow to wyskakuj z petli

    mov dword [rbp-16], 0
SECOND_LOOP:
    mov eax, dword [rbp-16]       ; wez wartosc spod adresu rbp-16
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

    mov dword [rbp-52], 0         ; przypisanie na l = 0

FIRST_IF:
    cmp dword [rbp-12], 0         ; porownanie 
    jle SECOND_IF

    mov eax, dword [rbp-12]
    sub eax, 1
    movsxd rcx, eax 
    movsxd rdx, dword [rbp-16]
    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SECOND_IF                 ; jesli nie jest rowna


    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx



SECOND_IF:

    mov eax, dword [_s]
    sub eax, 1
    cmp dword [rbp-12], eax
    jge THIRD_IF

    mov eax, dword [rbp-12]
    add eax, 1
    movsxd rcx, eax 
    movsxd rdx, dword [rbp-16]

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne THIRD_IF   

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx

THIRD_IF:
    cmp dword [rbp-16], 0         ; porownanie 
    jle FOUTH_IF

    movsxd rcx, dword [rbp-12]  
    mov ebx, dword [rbp-16]
    sub ebx, 1
    movsxd rdx, ebx 

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne FOUTH_IF   

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx

FOUTH_IF:
    mov eax, dword [_w]
    sub eax, 1
    cmp dword [rbp-16], eax
    jge FIFTH_IF

    movsxd rcx, dword [rbp-12]  
    mov ebx, dword [rbp-16]
    add ebx, 1
    movsxd rdx, ebx 

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne FIFTH_IF

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx


FIFTH_IF:   
    cmp dword [rbp-12], 0         ; porownanie xe x > 0 
    jle SIXTH_IF

    cmp dword [rbp-16], 0         ; porownanie ze y > 0
    jle SIXTH_IF

    mov eax, dword [rbp-12] 
    sub eax, 1
    movsxd rcx, eax               ; wyciagniecie wartosci y - 1

    mov ebx, dword [rbp-16]
    sub ebx, 1
    movsxd rdx, ebx               ; wyciagniecie wartosci x - 1

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SIXTH_IF

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx

SIXTH_IF:
    cmp dword [rbp-12], 0         ; porownanie xe x > 0 
    jle SEVENTH_IF

    mov eax, dword [_w]
    sub eax, 1
    cmp dword [rbp-16], eax
    jge SEVENTH_IF                ; porownanie xe y < _w - 1 

    mov eax, dword [rbp-12] 
    sub eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [rbp-16]
    add ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SEVENTH_IF

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx

SEVENTH_IF: 
    mov eax, dword [_s]
    sub eax, 1
    cmp dword [rbp-12], eax
    jge EIGHT_IF

    cmp dword [rbp-16], 0         ; porownanie 
    jle EIGHT_IF

    mov eax, dword [rbp-12] 
    add eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [rbp-16]
    sub ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne EIGHT_IF

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx

EIGHT_IF: 
    mov eax, dword [_s]
    sub eax, 1
    cmp dword [rbp-12], eax
    jge END_IF

    mov eax, dword [_w]
    sub eax, 1
    cmp dword [rbp-16], eax
    jge END_IF                    ; porownanie xe y < _w - 1 

    mov eax, dword [rbp-12] 
    add eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [rbp-16]
    add ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [rbp-48]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne END_IF

    mov edx, dword [rbp-52]
    add edx, 1 
    mov dword [rbp-52], edx
    

END_IF:

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

    cmp dword [rbp-52], 4
    jge STAR_THEN

    cmp dword [rbp-52], 2
    jl STAR_THEN

    mov [rdi+rsi], byte 42        ; else
    jmp UNDERSCORE_IF

STAR_THEN:
    mov [rdi+rsi], byte 95


UNDERSCORE_IF:
    movsxd rax, dword [rbp-12]
    movsxd rcx, dword [rbp-16]
    mov rdx, qword [rbp-48]
    mov rcx, [rdx+rcx*8]
    movzx rsi, byte [rcx+rax]
    mov rdx, 95

    cmp rsi, rdx
    jne AFTER_UNDERSCORE_IF

    movsxd rsi, dword [rbp-12]
    movsxd rdi, dword [rbp-16] 
    mov rax, qword [rbp-24]
    mov rdi, [rax+rdi*8]

    cmp dword [rbp-52], 3         ; test czy l == 3
    jne UNDERSCORE_ELSE           ; jesli nie to idz do elsa

    mov [rdi+rsi], byte 42        ; a jesli tak to przypisz *
    jmp AFTER_UNDERSCORE_IF

UNDERSCORE_ELSE:
    mov [rdi+rsi], byte 95        ; i przypisz _

AFTER_UNDERSCORE_IF:
    jmp THIRD_LOOP_FINISH



; ===============================================================================
;                    protokoly koncowe petli
; ===============================================================================



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