section .data
    prompt db "Enter 5 numbers: ", 0
    result_msg db "Reversed array: ", 0
    newline db 10, 0             ; Newline character for output formatting

section .bss
    array resb 20                ; Reserve 20 bytes to store input (5 numbers + spaces)

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, prompt              ; Address of the prompt message
    mov edx, 16                  ; Length of the prompt message
    int 0x80                     ; Make syscall

    ; Read user input
    mov eax, 3                   ; Syscall number for sys_read
    mov ebx, 0                   ; File descriptor (stdin)
    mov ecx, array               ; Address to store input
    mov edx, 20                  ; Max bytes to read
    int 0x80                     ; Make syscall

    ; Reverse the array in place
    lea esi, [array]             ; Pointer to the start of the array
    lea edi, [array + 19]        ; Pointer to the end of the array (20 bytes - 1)
    sub edi, 1                   ; Point to the last character (ignoring newline)

reverse_loop:
    ; Check if the pointers have crossed
    cmp esi, edi
    jge done_reversing           ; If pointers have crossed or met, we're done

    ; Load characters from both ends of the array
    mov al, byte [esi]           ; Load character at esi (start)
    mov bl, byte [edi]           ; Load character at edi (end)

    ; Swap the characters
    mov byte [esi], bl           ; Store the end character at the start
    mov byte [edi], al           ; Store the start character at the end

    ; Move the pointers towards each other
    inc esi                      ; Move esi right (towards the middle)
    dec edi                      ; Move edi left (towards the middle)

    jmp reverse_loop             ; Repeat the loop

done_reversing:
    ; Output result message
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, result_msg          ; Address of result message
    mov edx, 16                  ; Length of result message
    int 0x80                     ; Make syscall

    ; Output reversed array
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    lea ecx, [array]             ; Address of reversed array
    mov edx, 20                  ; Length of the array
    int 0x80                     ; Make syscall

    ; Print newline for better formatting
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, newline             ; Address of newline character
    mov edx, 1                   ; Length of newline
    int 0x80                     ; Make syscall

    ; Exit program
    mov eax, 1                   ; Syscall number for sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80                     ; Make syscall