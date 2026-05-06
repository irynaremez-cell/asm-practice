section .data
    a dd -5
    b dd 3

    signed_less db "SIGNED: a < b", 10
    signed_less_len equ $ - signed_less
    signed_equal db "SIGNED: a = b", 10
    signed_equal_len equ $ - signed_equal
    signed_greater db "SIGNED: a > b", 10
    signed_greater_len equ $ - signed_greater

    unsigned_less db "UNSIGNED: a < b", 10
    unsigned_less_len equ $ - unsigned_less
    unsigned_equal db "UNSIGNED: a = b", 10
    unsigned_equal_len equ $ - unsigned_equal
    unsigned_greater db "UNSIGNED: a > b", 10
    unsigned_greater_len equ $ - unsigned_greater

section .text
    global _start

_start:
    ; memory
    mov eax, [a]
    mov ebx, [b]

    ; logic
    call cmp_signed
    cmp eax, -1
    je print_signed_less
    cmp eax, 1
    je print_signed_greater
    jmp print_signed_equal

print_signed_less:
    ; I/O
    mov ecx, signed_less
    mov edx, signed_less_len
    call print_text
    jmp do_unsigned

print_signed_equal:
    ; I/O
    mov ecx, signed_equal
    mov edx, signed_equal_len
    call print_text
    jmp do_unsigned

print_signed_greater:
    ; I/O
    mov ecx, signed_greater
    mov edx, signed_greater_len
    call print_text

do_unsigned:
    ; memory
    mov eax, [a]
    mov ebx, [b]

    ; logic
    call cmp_unsigned
    cmp eax, -1
    je print_unsigned_less
    cmp eax, 1
    je print_unsigned_greater
    jmp print_unsigned_equal

print_unsigned_less:
    ; I/O
    mov ecx, unsigned_less
    mov edx, unsigned_less_len
    call print_text
    jmp exit_program

print_unsigned_equal:
    ; I/O
    mov ecx, unsigned_equal
    mov edx, unsigned_equal_len
    call print_text
    jmp exit_program

print_unsigned_greater:
    ; I/O
    mov ecx, unsigned_greater
    mov edx, unsigned_greater_len
    call print_text

exit_program:
    ; parse
    ; input values are stored in variables a and b

    ; math
    ; comparison result is calculated by cmp instructions

    ; loops
    ; no loops are needed in this task

    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

cmp_signed:
    ; logic
    cmp eax, ebx
    jl signed_is_less
    jg signed_is_greater
    je values_are_equal

signed_is_less:
    mov eax, -1
    ret

signed_is_greater:
    mov eax, 1
    ret

cmp_unsigned:
    ; logic
    cmp eax, ebx
    jb unsigned_is_less
    ja unsigned_is_greater
    je values_are_equal

unsigned_is_less:
    mov eax, -1
    ret

unsigned_is_greater:
    mov eax, 1
    ret

values_are_equal:
    mov eax, 0
    ret

print_text:
    ; I/O
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
