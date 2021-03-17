print_string:	
	mov ah, 0x0E

	.repeat:
        mov al, [si]
		cmp al, byte 0
		je .done
		int 10h
		inc si
		jmp .repeat

	.done:
		ret