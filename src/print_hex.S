;;;
;;; Print hex value using $dx
;;;

print_hex:
    pusha
    mov cx, 0                   ; Initialize loop counter
    and si, 0

.repeat:
    cmp cx, 4
    je .done

    mov ax, dx
    and ax, 0x000F
    add al, 0x30                ; Get ASCII
    cmp al, 0x39                ; Is the hex 0-9 (less than 39) or A-F
    jle .move_to_bx
    add al, 0x7                 ; get A-F

.move_to_bx:
    mov si, hex_str + 5         ;
    sub si, cx                  ;
    mov [si], al
    ror dx, 4                   ; Rotate right by 4 bits

    add cx, 1
    jmp .repeat

.done:
    mov si, hex_str
    call print_str

    popa
    ret


;;; Data
hex_str:    db '0x0000', 0xD, 0xA, 0
