section .data
    x dd 12345
    p dd 1
    q dd 5
    r dd 3

    binary_msg db "Binary: "
    binary_msg_len equ $ - binary_msg

    popcount_msg db 10, "popcount(x) = "
    popcount_msg_len equ $ - popcount_msg

    modified_msg db 10, "modified x = "
    modified_msg_len equ $ - modified_msg

    zero db "0"
    one db "1"
    space db " "
    newline db 10

section .bss
    buffer resb 16
    bit_count resd 1
    modified_x resd 1

section .text
    global _start

_start:
    ; parse
    mov eax, [x]

    ; memory
    mov dword [bit_count], 0

    ; I/O
    mov ecx, binary_msg
    mov edx, binary_msg_len
    call print_text

    ; loops
    mov esi, 31
    mov edi, 0

print_binary_loop:
    cmp esi, -1
    jl after_binary

    ; logic
    mov eax, [x]
    mov ecx, esi
    shr eax, cl
    and eax, 1

    cmp eax, 1
    je print_one_bit

print_zero_bit:
    ; I/O
    mov ecx, zero
    mov edx, 1
    call print_text
    jmp after_bit_print

print_one_bit:
    ; I/O
    mov ecx, one
    mov edx, 1
    call print_text

after_bit_print:
    ; math
    inc edi

    ; logic
    cmp edi, 4
    jne next_binary_bit

    cmp esi, 0
    je next_binary_bit

    ; I/O
    mov ecx, space
    mov edx, 1
    call print_text

    ; memory
    mov edi, 0

next_binary_bit:
    dec esi
    jmp print_binary_loop

after_binary:
    ; loops
    mov ecx, 32
    mov eax, [x]

popcount_loop:
    cmp ecx, 0
    je print_popcount

    ; logic
    mov ebx, eax
    and ebx, 1

    ; math
    add [bit_count], ebx
    shr eax, 1

    dec ecx
    jmp popcount_loop

print_popcount:
    ; I/O
    mov ecx, popcount_msg
    mov edx, popcount_msg_len
    call print_text

    ; memory
    mov eax, [bit_count]
    call print_unsigned_number

modify_bits:
    ; memory
    mov eax, [x]

    ; logic
    mov ecx, [p]
    mov ebx, 1
    shl ebx, cl
    or eax, ebx

    mov ecx, [q]
    mov ebx, 1
    shl ebx, cl
    or eax, ebx

    mov ecx, [r]
    mov ebx, 1
    shl ebx, cl
    not ebx
    and eax, ebx

    mov [modified_x], eax

    ; I/O
    mov ecx, modified_msg
    mov edx, modified_msg_len
    call print_text

    ; memory
    mov eax, [modified_x]
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
