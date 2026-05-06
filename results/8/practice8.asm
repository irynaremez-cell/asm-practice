section .data
    n dd 12
    target dd 5

    first_msg db "First index: "
    first_msg_len equ $ - first_msg

    count_msg db 10, "Count: "
    count_msg_len equ $ - count_msg

    indexes_msg db 10, "Indexes: "
    indexes_msg_len equ $ - indexes_msg

    space db " "
    newline db 10

section .bss
    array resd 100
    buffer resb 16
    first_index resd 1
    count resd 1

section .text
    global _start

_start:
    ; parse
    mov ecx, [n]
    cmp ecx, 10
    jl set_min_n
    cmp ecx, 100
    jg set_max_n
    jmp fill_array

set_min_n:
    mov dword [n], 10
    jmp fill_array

set_max_n:
    mov dword [n], 100

fill_array:
    ; loops
    xor esi, esi

fill_loop:
    cmp esi, [n]
    jge init_search

    ; math
    mov eax, esi
    add eax, 1
    mov ebx, 7
    xor edx, edx
    div ebx
    mov eax, edx

    ; memory
    mov [array + esi * 4], eax

    inc esi
    jmp fill_loop

init_search:
    ; memory
    mov dword [first_index], -1
    mov dword [count], 0

    ; loops
    xor esi, esi

search_loop:
    cmp esi, [n]
    jge print_result

    ; memory
    mov eax, [array + esi * 4]
    mov ebx, [target]

    ; logic
    cmp eax, ebx
    jne next_item

    mov eax, [count]
    cmp eax, 0
    jne inc_count

    mov [first_index], esi

inc_count:
    ; math
    inc dword [count]

next_item:
    inc esi
    jmp search_loop

print_result:
    ; I/O
    mov ecx, first_msg
    mov edx, first_msg_len
    call print_text

    mov eax, [first_index]
    call print_signed_number

    mov ecx, count_msg
    mov edx, count_msg_len
    call print_text

    mov eax, [count]
    call print_unsigned_number

    mov ecx, indexes_msg
    mov edx, indexes_msg_len
    call print_text

    ; logic
    cmp dword [count], 0
    je finish_output

    ; loops
    xor esi, esi

print_indexes_loop:
    cmp esi, [n]
    jge finish_output

    ; memory
    mov eax, [array + esi * 4]
    mov ebx, [target]

    ; logic
    cmp eax, ebx
    jne next_print_index

    mov eax, esi
    call print_unsigned_number

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

next_print_index:
    inc esi
    jmp print_indexes_loop

finish_output:
    ; I/O
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
