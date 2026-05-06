section .data
    n dd 10

    array_msg db "Array: "
    array_msg_len equ $ - array_msg

    min_msg db 10, "min = "
    min_msg_len equ $ - min_msg

    min_idx_msg db ", index = "
    min_idx_msg_len equ $ - min_idx_msg

    max_msg db 10, "max = "
    max_msg_len equ $ - max_msg

    max_idx_msg db ", index = "
    max_idx_msg_len equ $ - max_idx_msg

    space db " "
    newline db 10

section .bss
    array resd 50
    buffer resb 16
    min_val resd 1
    max_val resd 1
    min_idx resd 1
    max_idx resd 1

section .text
    global _start

_start:
    ; parse
    mov ecx, [n]
    cmp ecx, 5
    jl set_min_n
    cmp ecx, 50
    jg set_max_n
    jmp fill_array

set_min_n:
    mov dword [n], 5
    jmp fill_array

set_max_n:
    mov dword [n], 50

fill_array:
    ; loops
    xor esi, esi

fill_loop:
    cmp esi, [n]
    jge init_min_max

    ; math
    mov eax, esi
    imul eax, eax
    mov ebx, esi
    imul ebx, 3
    sub eax, ebx
    add eax, 7

    ; memory
    mov [array + esi * 4], eax

    inc esi
    jmp fill_loop

init_min_max:
    ; memory
    mov eax, [array]
    mov [min_val], eax
    mov [max_val], eax
    mov dword [min_idx], 0
    mov dword [max_idx], 0

    ; loops
    mov esi, 1

find_loop:
    cmp esi, [n]
    jge print_array

    ; memory
    mov eax, [array + esi * 4]

    ; logic
    cmp eax, [min_val]
    jl update_min

check_max:
    cmp eax, [max_val]
    jg update_max
    jmp next_find

update_min:
    mov [min_val], eax
    mov [min_idx], esi
    jmp check_max

update_max:
    mov [max_val], eax
    mov [max_idx], esi

next_find:
    inc esi
    jmp find_loop

print_array:
    ; I/O
    mov ecx, array_msg
    mov edx, array_msg_len
    call print_text

    ; loops
    xor esi, esi

print_array_loop:
    cmp esi, [n]
    jge print_min

    ; memory
    mov eax, [array + esi * 4]
    call print_signed_number

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

    inc esi
    jmp print_array_loop

print_min:
    ; I/O
    mov ecx, min_msg
    mov edx, min_msg_len
    call print_text

    mov eax, [min_val]
    call print_signed_number

    mov ecx, min_idx_msg
    mov edx, min_idx_msg_len
    call print_text

    mov eax, [min_idx]
    call print_unsigned_number

print_max:
    ; I/O
    mov ecx, max_msg
    mov edx, max_msg_len
    call print_text

    mov eax, [max_val]
    call print_signed_number

    mov ecx, max_idx_msg
    mov edx, max_idx_msg_len
    call print_text

    mov eax, [max_idx]
    call print_unsigned_number

    mov ecx, newline
    mov edx, 1
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

print_signed_number:
    ; logic
    cmp eax, 0
    jge print_unsigned_number

    push eax

    ; I/O
    mov byte [buffer], '-'
    mov ecx, buffer
    mov edx, 1
    call print_text

    pop eax

    ; math
    neg eax
    call print_unsigned_number
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
