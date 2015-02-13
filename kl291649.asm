DEFAULT REL

    extern malloc
    extern free

;; Sekcja danych
section .bss
    _s:     resb    4
    _w:     resb    4 
    _T:     resb    8 
   
    i:      resd    1
    x:      resd    1
    y:      resd    1
    cT:     resq    1
    fT:     resq    1
    tmp:    resq    1
    cT2:    resq    1
    l:      resd    1


;; We start our program with the start procedure
section .text
    global start                  ; musi  byc zadeklarowny dla linkera (gcc)
    global run


start:
    push rbp
    mov rbp, rsp

    mov [_s], edi                 ; przenies z edi do rbp - 4
    mov [_w], esi                 ; przenies z esi do rbp - 4
    mov [_T], rdx                 ; przenies z rdx do rbp - 4
    
    pop rbp
    ret
    
run:
    enter 0,0
    sub rsp, 100

    mov dword [rbp-4], edi        ; przenies z edi parametr do rbp - 4

    mov rax, [_T]                 ; na rax daj wartosc pod adresem _T
    mov qword [cT2], rax       ; przypisz na rbp-48 to co w rax, czyli _T 

    movsxd rax, dword [_w]                 ; przypisz do rax to co w _w
    shl rax, 3                    ; przesun bitowo w lewo o 3, pomnoz razy 8
    call malloc                   ; wywolaj malloca
    mov [cT], rax             ; zapisze wynik malloca w rbp-24
    mov qword [cT], rax       ; nc cT przypisz wynik malloca ktory jest w rax


    mov dword [i], 0
MALLOC_LOOP:
    mov eax, dword [i]
    cmp eax, [_w]
    jge AFTER_MALLOC_LOOP

    movsxd rax, [_s]
    shl rax, 3  
    call malloc
    movsxd rdi, dword [i]
    mov rcx, [cT]
    mov[rcx + rdi * 8], rax      ; zapisanie do pamieci o takim adresie to co jest w rejestrze rax

    mov eax, [i]
    add eax, 1
    mov dword [i], eax
    jmp MALLOC_LOOP 

AFTER_MALLOC_LOOP:                ; kod ktory jest po petli z alokacja 

    mov rax, qword [cT]       ; przenies do rejestru rax zmienna cT
    mov qword [fT], rax       ; przypisz na zmienna fT rejestr rax

    mov dword [i], 0

FIRST_LOOP:
    mov eax, dword [i]
    cmp eax, dword [rbp-4]
    jge AFTER_FIRST_LOOP          ; jezeli i >= ile_krokow to wyskakuj z petli

    mov dword [y], 0
SECOND_LOOP:
    mov eax, dword [y]       ; wez wartosc spod adresu rbp-16
    cmp eax, [_w]
    jge AFTER_SECOND_LOOP

    mov dword [x], 0
THIRD_LOOP:
    mov eax, dword [x]
    cmp eax, [_s]
    jge AFTER_THIRD_LOOP


; ===============================================================================
;                    w srodku petli - sprawdzenie ifow
; ===============================================================================

    mov dword [l], 0         ; przypisanie na l = 0

FIRST_IF:
    cmp dword [x], 0         ; porownanie 
    jle SECOND_IF

    mov eax, dword [x]
    sub eax, 1
    movsxd rcx, eax 
    movsxd rdx, dword [y]
    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SECOND_IF                 ; jesli nie jest rowna


    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx



SECOND_IF:

    mov eax, dword [_s]
    sub eax, 1
    cmp dword [x], eax
    jge THIRD_IF

    mov eax, dword [x]
    add eax, 1
    movsxd rcx, eax 
    movsxd rdx, dword [y]

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne THIRD_IF   

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx

THIRD_IF:
    cmp dword [y], 0         ; porownanie 
    jle FOUTH_IF

    movsxd rcx, dword [x]  
    mov ebx, dword [y]
    sub ebx, 1
    movsxd rdx, ebx 

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne FOUTH_IF   

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx

FOUTH_IF:
    mov eax, dword [_w]
    sub eax, 1
    cmp dword [y], eax
    jge FIFTH_IF

    movsxd rcx, dword [x]  
    mov ebx, dword [y]
    add ebx, 1
    movsxd rdx, ebx 

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne FIFTH_IF

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx


FIFTH_IF:   
    cmp dword [x], 0         ; porownanie xe x > 0 
    jle SIXTH_IF

    cmp dword [y], 0         ; porownanie ze y > 0
    jle SIXTH_IF

    mov eax, dword [x] 
    sub eax, 1
    movsxd rcx, eax               ; wyciagniecie wartosci y - 1

    mov ebx, dword [y]
    sub ebx, 1
    movsxd rdx, ebx               ; wyciagniecie wartosci x - 1

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SIXTH_IF

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx

SIXTH_IF:
    cmp dword [x], 0         ; porownanie xe x > 0 
    jle SEVENTH_IF

    mov eax, dword [_w]
    sub eax, 1
    cmp dword [y], eax
    jge SEVENTH_IF                ; porownanie xe y < _w - 1 

    mov eax, dword [x] 
    sub eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [y]
    add ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne SEVENTH_IF

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx

SEVENTH_IF: 
    mov eax, dword [_s]
    sub eax, 1
    cmp dword [x], eax
    jge EIGHT_IF

    cmp dword [y], 0         ; porownanie 
    jle EIGHT_IF

    mov eax, dword [x] 
    add eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [y]
    sub ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne EIGHT_IF

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx

EIGHT_IF: 
    mov eax, dword [_s]
    sub eax, 1
    cmp dword [x], eax
    jge END_IF

    mov eax, dword [_w]
    sub eax, 1
    cmp dword [y], eax
    jge END_IF                    ; porownanie xe y < _w - 1 

    mov eax, dword [x] 
    add eax, 1
    movsxd rcx, eax               ; tutaj zmieniam x

    mov ebx, dword [y]
    add ebx, 1
    movsxd rdx, ebx               ; tutaj zmieniam y

    mov rsi, qword [cT2]
    mov rdx, [rsi+rdx*8]
    movzx rax, byte [rdx+rcx]     ; byc moze trezeba bedzie inna instrukcje zastosowac
    cmp rax, 42                   ; porownaj to co jest w cT2[y][x-1] z tym *
    jne END_IF

    mov edx, dword [l]
    add edx, 1 
    mov dword [l], edx
    

END_IF:
    jmp STAR_IF

; ===============================================================================
;                    w srodku petli - aktualizacja pol gry w zycie
; ===============================================================================

STAR_IF: 

    movsxd rax, dword [x]
    movsxd rcx, dword [y]
    mov rdx, qword [cT2]
    mov rcx, [rdx+rcx*8]
    movzx rsi, byte [rcx+rax]
    mov rdx, 42

    cmp rsi, rdx
    jne UNDERSCORE_IF
 
    movsxd rsi, dword [x]
    movsxd rdi, dword [y] 
    mov rax, qword [cT]
    mov rdi, [rax+rdi*8] 

    cmp dword [l], 4
    jge STAR_THEN

    cmp dword [l], 2
    jl STAR_THEN

    mov [rdi+rsi], byte 42        ; else
    jmp UNDERSCORE_IF

STAR_THEN:
    mov [rdi+rsi], byte 95


UNDERSCORE_IF:
    movsxd rax, dword [x]
    movsxd rcx, dword [y]
    mov rdx, qword [cT2]
    mov rcx, [rdx+rcx*8]
    movzx rsi, byte [rcx+rax]
    mov rdx, 95

    cmp rsi, rdx
    jne AFTER_UNDERSCORE_IF

    movsxd rsi, dword [x]
    movsxd rdi, dword [y] 
    mov rax, qword [cT]
    mov rdi, [rax+rdi*8]

    cmp dword [l], 3         ; test czy l == 3
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
    mov eax, dword [x]
    add eax, 1
    mov dword [x], eax
    jmp THIRD_LOOP

AFTER_THIRD_LOOP:
    jmp SECOND_LOOP_FINISH

SECOND_LOOP_FINISH:

    mov eax, dword [y]
    add eax, 1
    mov dword [y], eax
    jmp SECOND_LOOP

AFTER_SECOND_LOOP:
    jmp MEMCPY

; ===============================================================================
;                    podmieniam tablice na koncu ostatniej petli
; ===============================================================================

MEMCPY:

    mov dword [rbp-100], 0
FIRST_COPY_LOOP:
    mov eax, [rbp-100]
    cmp eax, [_w]
    jge FIRST_LOOP_FINISH 

    mov dword [rbp-96], 0

SECOND_COPY_LOOP:
    mov eax, [rbp-96]
    cmp eax, [_s]
    jge FIRST_COPY_LOOP_FINISH 

    movsxd rax, dword [rbp-96]
    movsxd rcx, dword [rbp-100]
    mov rdx, qword [cT]
    mov rcx, [rdx+rcx*8]
    movzx r11, byte [rcx+rax]
 
    movsxd rsi, dword [rbp-96]
    movsxd rdi, dword [rbp-100] 
    mov rax, qword [cT2]
    mov rdi, [rax+rdi*8]
    mov [rdi+rsi], r11


SECOND_COPY_LOOP_FINISH:
    mov eax, dword [rbp-96]
    add eax, 1
    mov dword [rbp-96], eax
    jmp SECOND_COPY_LOOP

FIRST_COPY_LOOP_FINISH: 
    mov eax, dword [rbp-100]
    add eax, 1
    mov dword [rbp-100], eax
    jmp FIRST_COPY_LOOP


; ===============================================================================
;                    koniec petli z liczba krokow
; ===============================================================================


FIRST_LOOP_FINISH:

    mov eax, dword [i]
    add eax, 1
    mov dword [i], eax
    jmp FIRST_LOOP    


; ===============================================================================
;                    finish
; ===============================================================================
TIDE_UP:

    mov dword [i], 0
FREE_LOOP:
    mov eax, dword [i]
    cmp eax, [_w]
    jge AFTER_FREE_LOOP

    movsxd rax, dword [i]
    mov rcx, [cT]
    mov rdi, [rcx + rax * 8] 
    call free

    mov eax, [i]
    add eax, 1
    mov dword [i], eax
    jmp FREE_LOOP 

AFTER_FREE_LOOP:

    mov rax, [cT]
    mov rdi, rax 
    call free

; ===============================================================================
;                    protokol koncowy
; ===============================================================================

AFTER_FIRST_LOOP:
    leave 
    ret
