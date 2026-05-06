section .data
    n dd 7

    original_msg db "Original: "
    original_msg_len equ $ - original_msg

    reversed_msg db 10, "Reversed: "
    reversed_msg_len equ $ - reversed_msg

    palindrome_yes db 10, "PALINDROME: YES", 10
    palindrome_yes_len equ $ - palindrome_yes

    palindrome_no db 10, "PALINDROME: NO", 10
    palindrome_no_len equ $ - palindrome_no

    space db " "

section .bss
    array resd 200
    reversed resd 200
    buffer resb 16
    is_palindrome resd 1

section .text
    global _start

_start:
    ; parse
    mov eax, [n]
    cmp eax, 5
    jl set_min_n
    cmp eax, 200
    jg set_max_n
    jmp fill_array

set_min_n:
    mov dword [n], 5
    jmp fill_array

set_max_n:
    mov dword [n], 200

fill_array:
    ; loops
    xor esi, esi

fill_loop:
    cmp esi, [n]
    jge make_reversed

    ; logic
    cmp esi, 0
    je val_one
    cmp esi, 1
    je val_two
    cmp esi, 2
    je val_three
    cmp esi, 3
    je val_four
    cmp esi, 4
    je val_three
    cmp esi, 5
    je val_two
    cmp esi, 6
    je val_one

    ; math
    mov eax, esi
    add eax, 1
    jmp save_value

val_one:
    mov eax, 1
    jmp save_value

val_two:
    mov eax, 2
    jmp save_value

val_three:
    mov eax, 3
    jmp save_value

val_four:
    mov eax, 4

save_value:
    ; memory
    mov [array + esi * 4], eax
    inc esi
    jmp fill_loop

make_reversed:
    ; loops
    xor esi, esi

reverse_loop:
    cmp esi, [n]
    jge check_palindrome

    ; math
    mov edi, [n]
    dec edi
    sub edi, esi

    ; memory
    mov eax, [array + edi * 4]
    mov [reversed + esi * 4], eax

    inc esi
    jmp reverse_loop

check_palindrome:
    ; memory
    mov dword [is_palindrome], 1

    ; loops
    xor esi, esi
    mov edi, [n]
    dec edi

pal_loop:
    ; logic
    cmp esi, edi
    jge print_original

    ; memory
    mov eax, [array + esi * 4]
    mov ebx, [array + edi * 4]

    ; logic
    cmp eax, ebx
    jne not_palindrome

    inc esi
    dec edi
    jmp pal_loop

not_palindrome:
    ; memory
    mov dword [is_palindrome], 0

print_original:
    ; I/O
    mov ecx, original_msg
    mov edx, original_msg_len
    call print_text

    ; loops
    xor esi, esi

print_original_loop:
    cmp esi, [n]
    jge print_reversed

    ; memory
    mov eax, [array + esi * 4]
    call print_unsigned_number

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

    inc esi
    jmp print_original_loop

print_reversed:
    ; I/O
    mov ecx, reversed_msg
    mov edx, reversed_msg_len
    call print_text

    ; loops
    xor esi, esi

print_reversed_loop:
    cmp esi, [n]
    jge print_palindrome

    ; memory
    mov eax, [reversed + esi * 4]
    call print_unsigned_number

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

    inc esi
    jmp print_reversed_loop

print_palindrome:
    ; logic
    cmp dword [is_palindrome], 1
    je print_yes

print_no:
    ; I/O
    mov ecx, palindrome_no
    mov edx, palindrome_no_len
    call print_text
    jmp exit_program

print_yes:
    ; I/O
    mov ecx, palindrome_yes
    mov edx, palindrome_yes_len
    call print_text

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
