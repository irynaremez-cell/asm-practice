section .data
    source_text db "hello test hello test hello", 0
    source_pattern db "test", 0

    first_msg db "First position: "
    first_msg_len equ $ - first_msg

    count_msg db 10, "Count: "
    count_msg_len equ $ - count_msg

    newline db 10

section .bss
    text_buf resb 201
    pattern_buf resb 51
    number_buf resb 16
    text_len resd 1
    pattern_len resd 1
    first_pos resd 1
    count resd 1

section .text
    global _start

_start:
    ; parse
    mov esi, source_text
    mov edi, text_buf
    call copy_string

    mov esi, source_pattern
    mov edi, pattern_buf
    call copy_string

    ; memory
    mov esi, text_buf
    call strlen
    mov [text_len], eax

    mov esi, pattern_buf
    call strlen
    mov [pattern_len], eax

    mov dword [first_pos], -1
    mov dword [count], 0

    ; logic
    cmp dword [pattern_len], 0
    je print_result

    ; loops
    xor esi, esi

search_loop:
    ; math
    mov eax, [text_len]
    sub eax, [pattern_len]

    ; logic
    cmp esi, eax
    jg print_result

    ; memory
    mov edi, 0

compare_loop:
    ; loops
    cmp edi, [pattern_len]
    jge found_match

    ; memory
    mov al, [text_buf + esi + edi]
    mov bl, [pattern_buf + edi]

    ; logic
    cmp al, bl
    jne next_position

    inc edi
    jmp compare_loop

found_match:
    ; logic
    cmp dword [count], 0
    jne add_count_only

    ; memory
    mov [first_pos], esi

add_count_only:
    ; math
    inc dword [count]
    mov eax, [pattern_len]
    add esi, eax
    jmp search_loop

next_position:
    ; math
    inc esi
    jmp search_loop

print_result:
    ; I/O
    mov ecx, first_msg
    mov edx, first_msg_len
    call print_text

    mov eax, [first_pos]
    call print_signed_number

    mov ecx, count_msg
    mov edx, count_msg_len
    call print_text

    mov eax, [count]
    call print_unsigned_number

    mov ecx, newline
    mov edx, 1
    call print_text

exit_program:
    ; I/O
    mov eax, 1
    xor ebx, ebx
    int 0x80

copy_string:
    ; loops
copy_loop:
    ; memory
    mov al, [esi]
    mov [edi], al

    ; logic
    cmp al, 0
    je copy_done

    inc esi
    inc edi
    jmp copy_loop

copy_done:
    ret

strlen:
    ; memory
    xor eax, eax

strlen_loop:
    ; loops
    cmp byte [esi + eax], 0
    je strlen_done

    ; math
    inc eax
    jmp strlen_loop

strlen_done:
    ret

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
    mov byte [number_buf], '-'
    mov ecx, number_buf
    mov edx, 1
    call print_text

    pop eax

    ; math
    neg eax
    call print_unsigned_number
    ret

print_unsigned_number:
    ; memory
    mov edi, number_buf + 15
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
    mov edx, number_buf + 15
    sub edx, edi
    call print_text
    ret
