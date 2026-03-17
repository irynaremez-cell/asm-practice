section .data
    newline db 10

section .bss
    input_buffer  resb 16
    output_buffer resb 6

section .text
    global _start

_start:

; ===== I/O =====
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input_buffer
    mov edx, 16
    int 0x80

; ===== parse =====
    mov esi, input_buffer
    xor eax, eax        ; результат (число)
    xor ebx, ebx

parse_loop:
    mov bl, [esi]

    cmp bl, 10          ; newline
    je convert_done
    cmp bl, 0
    je convert_done

; ===== logic =====
    cmp bl, '0'
    jl convert_done
    cmp bl, '9'
    jg convert_done

; ===== math =====
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx

; ===== loops =====
    inc esi
    jmp parse_loop

convert_done:

; число вже в eax (AX використовується як 16-бітна частина)

; ===== convert number to string =====
    mov ebx, 10
    mov edi, output_buffer + 6

    cmp eax, 0
    jne convert_loop

; якщо число 0
    mov byte [output_buffer], '0'
    mov edi, output_buffer
    jmp print

convert_loop:
    xor edx, edx
    div ebx             ; eax / 10

    add dl, '0'
    dec edi

; ===== memory =====
    mov [edi], dl

    test eax, eax
    jnz convert_loop

; ===== I/O =====
print:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, edi
    mov edx, output_buffer + 6
    sub edx, edi
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80
