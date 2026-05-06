section .data
    n dd 5

    fact_msg db "fact(n) = "
    fact_msg_len equ $ - fact_msg

    calls_msg db 10, "calls = "
    calls_msg_len equ $ - calls_msg

    newline db 10

section .bss
    calls resd 1
    buffer resb 16

section .text
    global _start

_start:
    ; parse
    mov eax, [n]
    cmp eax, 0
    jl set_zero
    cmp eax, 12
    jg set_twelve
    jmp start_calc

set_zero:
    mov dword [n], 0
    jmp start_calc

set_twelve:
    mov dword [n], 12

start_calc:
    ; memory
    mov dword [calls], 0

    ; math
    mov eax, [n]
    call fact

    push eax

    ; I/O
    mov ecx, fact_msg
    mov edx, fact_msg_len
    call print_text

    pop eax
    call print_unsigned_number

    ; I/O
    mov ecx, calls_msg
    mov edx, calls_msg_len
    call print_text

    ; memory
    mov eax, [calls]
    call print_unsigned_number

    mov ecx, newline
    mov edx, 1
    call print_text

exit_program:
    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

fact:
    ; memory
    push ebp
    mov ebp, esp
    push ebx

    ; math
    inc dword [calls]

    ; logic
    cmp eax, 1
    jbe fact_base

    mov ebx, eax
    dec eax
    call fact
    imul eax, ebx
    jmp fact_done

fact_base:
    mov eax, 1

fact_done:
    ; memory
    pop ebx
    mov esp, ebp
    pop ebp
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
