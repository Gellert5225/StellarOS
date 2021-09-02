print_str:
	pusha
	mov ah, 0x0E                ; BIOS teletype output
.repeat:
    mov al, [si]
	cmp al, 0
	je .done
	int 0x10
	inc si
	jmp .repeat

.done:
	popa
	ret
