;;
;; boot loader
;;

BITS 16

org 0x7C00

mov si, asterisks
call print_string

mov si, boot_starting
call print_string

mov bx, 0x1000					; load sector to mem 0x1000
mov es, bx						; set es segment
mov bx, 0x0

mov dh, 0x00        ; head 0
mov dl, 0x80        ; drive 0
mov ch, 0x00        ; cylinder 0
mov cl, 0x02        ; read at CL sector 2, immediately after bootsector

disk_load:
    mov si, loading_kernel
    call print_string

    mov ah, 0x02        ; BIOS read sector from drive
    mov al, 0x01        ; numbers of sectors

    int 0x13            ; BIOS interrupt
    jc disk_err

    mov si, kernel_loaded
    call print_string

    mov si, asterisks
    call print_string

    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x1000:0x0

asterisks db '************************', 13, 10, 0

boot_starting db 'Boot starting...', 13, 10, 0

boot_finished db 'Boot finished.', 13, 10, 0

loading_kernel db 'Loading kernel...', 13, 10, 0

kernel_loaded db 'Kernel loaded.', 13, 10, 0

disk_err:
    hlt

%include "src/print.S"

	times 510-($-$$) db 0		; Pad remainder of boot sector with 0s
	dw 0xAA55					; The standard PC boot signature, little endian
