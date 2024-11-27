section .data
    prompt db "Enter a number: ", 0
    result_msg db "Factorial: ", 0
    newline db 10, 0              ; Newline character for output formatting

section .bss
    num resb 5                   ; Buffer to store input number (up to 4 digits + null terminator)
    result resb 20               ; Buffer to store the result string (max 20 digits)

section .text
    global _start

_start:
    ; Display prompt
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, prompt              ; Address of the prompt
    mov edx, 15                  ; Length of the prompt
    int 0x80                     ; Make syscall

    ; Read user input
    mov eax, 3                   ; Syscall number for sys_read
    mov ebx, 0                   ; File descriptor (stdin)
    mov ecx, num                 ; Address to store input
    mov edx, 5                   ; Number of bytes to read
    int 0x80                     ; Make syscall

    ; Null-terminate the input string
    mov byte [num+4], 0

    ; Convert input string to integer
    mov esi, num                 ; Address of input string
    xor eax, eax                 ; Clear eax (result)
    xor ebx, ebx                 ; Clear ebx (multiplier)
    mov ecx, 10                  ; Base 10 multiplier
convert_to_integer:
    movzx ebx, byte [esi]        ; Load byte from string
    cmp ebx, 0                   ; Check for null terminator
    je done_conversion
    sub ebx, '0'                 ; Convert ASCII to integer
    imul eax, ecx                ; Multiply result by 10
    add eax, ebx                 ; Add current digit
    inc esi                      ; Move to next character
    jmp convert_to_integer
done_conversion:
    mov edi, eax                 ; Move input number to edi for factorial calculation

    ; Call factorial subroutine
    call factorial

    ; Convert factorial result to string for printing
    mov eax, edi                 ; Move factorial result to eax
    mov esi, result              ; Address of result buffer
    call int_to_string           ; Convert integer to string

    ; Display result message
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, result_msg          ; Address of the result message
    mov edx, 10                  ; Length of the result message
    int 0x80                     ; Make syscall

    ; Display result
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, result              ; Address of the result
    mov edx, 20                  ; Max length of result
    int 0x80                     ; Make syscall

    ; Print newline
    mov eax, 4                   ; Syscall number for sys_write
    mov ebx, 1                   ; File descriptor (stdout)
    mov ecx, newline             ; Address of newline character
    mov edx, 1                   ; Length of newline
    int 0x80                     ; Make syscall

    ; Exit program
    mov eax, 1                   ; Syscall number for sys_exit
    xor ebx, ebx                 ; Exit code 0
    int 0x80                     ; Make syscall

factorial:
    push ebp                    ; Save base pointer
    mov ebp, esp                ; Set up stack frame
    push ebx                    ; Preserve ebx (callee-saved register)

    ; Base case: if number <= 1, return 1
    cmp edi, 1
    jle base_case

    ; Recursive case: factorial(n) = n * factorial(n-1)
    mov ebx, edi                ; Save n in ebx
    sub edi, 1                  ; Compute n-1
    call factorial              ; Recursive call
    imul edi, ebx               ; Multiply n * factorial(n-1)
    jmp end_factorial

base_case:
    mov edi, 1                  ; Return 1 for base case

end_factorial:
    pop ebx                     ; Restore ebx
    pop ebp                     ; Restore base pointer
    ret                         ; Return to caller

int_to_string:
    mov ecx, 10                 ; Base 10
    xor edx, edx                ; Clear edx (remainder)
    mov ebx, esi                ; Save starting address of buffer
convert_digits:
    xor edx, edx                ; Clear edx
    div ecx                     ; Divide eax by 10
    add dl, '0'                 ; Convert remainder to ASCII
    mov [esi], dl               ; Store ASCII character in buffer
    inc esi                     ; Move buffer pointer
    test eax, eax               ; Check if eax is 0
    jnz convert_digits          ; If not, continue dividing
    mov byte [esi], 0           ; Null-terminate the string

    ; Reverse the digits
    dec esi                     ; Adjust pointer to last digit
    mov edi, ebx                ; Starting address of the buffer
reverse_string:
    cmp edi, esi                ; Check if pointers have crossed
    jge done_reverse            ; If yes, we're done
    mov al, [edi]               ; Load current character
    mov bl, [esi]               ; Load end character
    mov [edi], bl               ; Swap characters
    mov [esi], al               ; Swap characters
    inc edi                     ; Move start pointer forward
    dec esi                     ; Move end pointer backward
    jmp reverse_string
done_reverse:
    ret