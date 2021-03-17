print_string:	
	mov ah, 0Eh

	.repeat:
		cmp [bx], byte 0
		je .done
		mov al, [bx]
		int 10h
		inc bx
		jmp .repeat

	.done:
		ret