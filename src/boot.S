BITS 16					; Assemble for 16-bit mode

start:
	;mov [BOOT_DISK], dl

	; Starting address of bootloader is 0x7C00(physical)
	; we need to translate it into segment, 0x7C00 = segment * 16 + offset, where offset = 0
	mov ax, 07C0h
	add ax, 20h			; 512 bytes / 16, ie, size of bootloader
	mov ss, ax			; set stack segment to ax
	mov sp, 4096		; move stack pointer 4096 bytes away from ss

	mov ax, 07C0h		; Set data segment to where we're loaded
	mov ds, ax

	mov bx, text_string	; Put string position into SI
	call print_string	; Call our string-printing routine

	jmp $				; Infinite loop

	text_string db 'Welcome to StellarOS', 0

	%include "src/print.S"
	%include "src/disk.S"

	times 510-($-$$) db 0	; Pad remainder of boot sector with 0s
	dw 0xAA55				; The standard PC boot signature, little endian
