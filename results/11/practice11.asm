section .data
    h dd 10
    newline db 10

section .bss
    line_buffer resb 64
    height resd 1

section .text
    global _start

_start:
    ; parse
    mov eax, [h]
    cmp eax, 5
    jl set_min_h
    cmp eax, 25
    jg set_max_h
    jmp start_tree

set_min_h:
    mov eax, 5
    jmp save_height

set_max_h:
    mov eax, 25

save_height:
    ; memory
    mov [height], eax

start_tree:
    ; memory
    mov eax, [h]
    cmp eax, 5
    jl use_saved_height
    cmp eax, 25
    jg use_saved_height
    mov [height], eax

use_saved_height:
    ; loops
    xor esi, esi

row_loop:
    cmp esi, [height]
    jge exit_program

    ; memory
    mov edi, line_buffer

    ; math
    mov eax, [height]
    sub eax, esi
    dec eax

    ; loops
    mov ecx, eax

spaces_loop:
    cmp ecx, 0
    je prepare_stars

    ; memory
    mov byte [edi], ' '
    inc edi

    dec ecx
    jmp spaces_loop

prepare_stars:
    ; math
    mov eax, esi
    shl eax, 1
    inc eax

    ; loops
    mov ecx, eax

stars_loop:
    cmp ecx, 0
    je finish_line

    ; memory
    mov byte [edi], '*'
    inc edi

    dec ecx
    jmp stars_loop

finish_line:
    ; memory
    mov byte [edi], 10
    inc edi

    ; math
    mov edx, edi
    sub edx, line_buffer

    ; I/O
    mov ecx, line_buffer
    call print_line

    inc esi
    jmp row_loop

exit_program:
    ; logic
    ; program exits after all rows are printed

    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_line:
    ; I/O
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
