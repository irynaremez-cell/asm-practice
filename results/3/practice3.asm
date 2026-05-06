section .bss
    buffer resb 16

section .text
    global _start

_start:
    ; math
    mov ax, 12345

    ; memory
    mov edi, buffer + 15
    mov byte [edi], 10
    dec edi

    ; logic
    cmp ax, 0
    jne convert_number

    mov byte [edi], '0'
    jmp print_number

convert_number:
    ; math
    movzx eax, ax
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

print_number:
    ; I/O
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, buffer + 16
    sub edx, edi
    int 0x80

    ; parse
    ; value is already stored in AX

    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80
