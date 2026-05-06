section .data
    n dd 100
    seed dd 123

    colon_space db ": "
    colon_space_len equ $ - colon_space

    space_open db " ("
    space_open_len equ $ - space_open

    close_newline db ")", 10
    close_newline_len equ $ - close_newline

    hash db "#"

section .bss
    freq resd 10
    buffer resb 16

section .text
    global _start

_start:
    ; parse
    mov eax, [n]
    cmp eax, 100
    jl set_min_n
    cmp eax, 1000
    jg set_max_n
    jmp clear_freq

set_min_n:
    mov dword [n], 100
    jmp clear_freq

set_max_n:
    mov dword [n], 1000

clear_freq:
    ; loops
    xor esi, esi

clear_loop:
    cmp esi, 10
    jge generate_values

    ; memory
    mov dword [freq + esi * 4], 0

    inc esi
    jmp clear_loop

generate_values:
    ; loops
    xor esi, esi

generate_loop:
    cmp esi, [n]
    jge print_histogram

    ; math
    mov eax, [seed]
    mov ebx, 1103515245
    mul ebx
    add eax, 12345
    and eax, 0x7fffffff
    mov [seed], eax

    ; math
    xor edx, edx
    mov ebx, 10
    div ebx

    ; memory
    inc dword [freq + edx * 4]

    inc esi
    jmp generate_loop

print_histogram:
    ; loops
    xor esi, esi

hist_loop:
    cmp esi, 10
    jge exit_program

    ; I/O
    mov eax, esi
    call print_unsigned_number

    mov ecx, colon_space
    mov edx, colon_space_len
    call print_text

    ; memory
    mov ecx, [freq + esi * 4]

    ; logic
    cmp ecx, 0
    je print_count

    ; math
    mov eax, ecx
    mov ebx, 2
    xor edx, edx
    div ebx
    cmp eax, 0
    jne set_hash_count
    mov eax, 1

set_hash_count:
    mov ecx, eax

hash_loop:
    ; loops
    cmp ecx, 0
    je print_count

    push ecx

    ; I/O
    mov ecx, hash
    mov edx, 1
    call print_text

    pop ecx
    dec ecx
    jmp hash_loop

print_count:
    ; I/O
    mov ecx, space_open
    mov edx, space_open_len
    call print_text

    ; memory
    mov eax, [freq + esi * 4]
    call print_unsigned_number

    mov ecx, close_newline
    mov edx, close_newline_len
    call print_text

    inc esi
    jmp hist_loop

exit_program:
    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_text:
    ; I/O
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

print_unsigned_number:
    ; memory
    mov edi, buffer + 15
    mov byte [edi], 0
    dec edi

    ; logic
    cmp eax, 0
    jne convert_number

    mov byte [edi], '0'
    jmp write_number

convert_number:
    ; math
    mov ebx, 10

convert_loop:
    ; loops
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    cmp eax, 0
    jne convert_loop

    inc edi

write_number:
    ; I/O
    mov ecx, edi
    mov edx, buffer + 15
    sub edx, edi
    call print_text
    ret
