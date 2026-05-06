section .data
    n dd 10

    before_msg db "Before sort: "
    before_msg_len equ $ - before_msg

    after_msg db 10, "After sort: "
    after_msg_len equ $ - after_msg

    median_msg db 10, "Median: "
    median_msg_len equ $ - median_msg

    space db " "
    newline db 10

section .bss
    array resd 100
    buffer resb 16

section .text
    global _start

_start:
    ; parse
    mov eax, [n]
    cmp eax, 10
    jl set_min_n
    cmp eax, 100
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
    jge print_before

    ; math
    mov eax, [n]
    sub eax, esi
    imul eax, 3
    add eax, esi

    ; memory
    mov [array + esi * 4], eax

    inc esi
    jmp fill_loop

print_before:
    ; I/O
    mov ecx, before_msg
    mov edx, before_msg_len
    call print_text

    xor esi, esi
    call print_array

selection_sort:
    ; loops
    xor esi, esi

outer_loop:
    mov eax, [n]
    dec eax
    cmp esi, eax
    jge print_after

    ; memory
    mov edi, esi

    ; loops
    mov ebx, esi
    inc ebx

inner_loop:
    cmp ebx, [n]
    jge swap_if_needed

    ; memory
    mov eax, [array + ebx * 4]
    mov edx, [array + edi * 4]

    ; logic
    cmp eax, edx
    jge next_j

    mov edi, ebx

next_j:
    inc ebx
    jmp inner_loop

swap_if_needed:
    ; logic
    cmp edi, esi
    je next_i

    ; memory
    mov eax, [array + esi * 4]
    mov edx, [array + edi * 4]
    mov [array + esi * 4], edx
    mov [array + edi * 4], eax

next_i:
    inc esi
    jmp outer_loop

print_after:
    ; I/O
    mov ecx, after_msg
    mov edx, after_msg_len
    call print_text

    xor esi, esi
    call print_array

print_median:
    ; I/O
    mov ecx, median_msg
    mov edx, median_msg_len
    call print_text

    ; math
    mov eax, [n]
    dec eax
    shr eax, 1

    ; memory
    mov eax, [array + eax * 4]
    call print_unsigned_number

    mov ecx, newline
    mov edx, 1
    call print_text

exit_program:
    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_array:
    ; loops
print_array_loop:
    cmp esi, [n]
    jge print_array_done

    ; memory
    mov eax, [array + esi * 4]
    call print_unsigned_number

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

    inc esi
    jmp print_array_loop

print_array_done:
    ret

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
