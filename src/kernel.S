;;
;; Simple kernel loaded from boot sector
;;

    mov si, welcome_msg
    call print_str

    mov si, 0x12AB              ; print sample hex
    call print_hex

    ;; end program
    hlt

welcome_msg:    db 'Welcome to StellarOS', 13, 10, 0

    ;; include files
    include 'src/print_str.S'
    include 'src/print_hex.S'


times 512-($-$$) db 0		; Pad remainder of boot sector with 0s
