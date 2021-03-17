;;
;; simple kernel
;;

;mov ah, 0x00                ; set video mode
;mov al, 0x02                
;int 0x10

mov si, text_string			; Put string position into SI
call print_string			; Call our string-printing routine

hlt

text_string db 'Welcome to StellarOS', 13, 10, 0

;; include files
%include "src/print.S"

times 512-($-$$) db 0		; Pad remainder of boot sector with 0s