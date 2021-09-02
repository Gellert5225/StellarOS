;;
;; Boot loader
;;

    org 0x7C00                  ; Origin of Boot

    mov ah, 0x00                ; set video mode
    mov al, 0x02
    int 0x10

    mov si, asterisks
    call print_str

    mov si, boot_starting
    call print_str

    ;; Read file table
    ;; Set up ES:BX offset to load sectors into
    mov bx, 0x1000              ; Load sector to mem 0x1000
    mov es, bx                  ; es = 0x1000
    mov bx, 0x0                 ; es:bx = 0x1000:0

    ;; Set up $dx
    mov dh, 0x00                ; Number of sectors to load
    mov dl, 0x80                ; Drive 0 (boot disk)
    mov ch, 0x00                ; Cylinder 0
    mov cl, 0x02                ; Starting sector

read_disk_1:
    mov si, loading_fat
    call print_str

    mov ah, 0x02
    mov al, 0x01
    int 0x13

    jc disk_err

    mov si, fat_loaded
    call print_str


    ;; Load kernel into memory
    ;; Set up ES:BX offset to load sectors into
    mov bx, 0x2000              ; Load sector to mem 0x1000
    mov es, bx                  ; es = 0x1000
    mov bx, 0x0                 ; es:bx = 0x1000:0

    ;; Set up $dx
    mov dh, 0x00                ; Number of sectors to load
    mov dl, 0x80                ; Drive 0 (boot disk)
    mov ch, 0x00                ; Cylinder 0
    mov cl, 0x03                ; Starting sectori

read_disk_2:
    mov si, loading_kernel
    call print_str

    mov ah, 0x02
    mov al, 0x01
    int 0x13

    jc disk_err

    mov si, kernel_loaded
    call print_str



    mov si, asterisks
    call print_str

    ;; Reset segment registers
    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp 0x2000:0x0              ; Jump to kernel

disk_err:
    mov si, DISK_ERR
    call print_str
    hlt


DISK_ERR:       db 'Disk read error!', 0xD, 0xA, 0

asterisks:      db '************************', 0xD, 0xA, 0 ;crlf and null terminate

boot_starting:  db 'Boot starting...', 0xD, 0xA, 0

boot_finished:  db 'Boot finished.', 0xD, 0xA, 0

loading_kernel: db 'Loading kernel...', 0xD, 0xA, 0

kernel_loaded:  db 'Kernel loaded.', 0xD, 0xA, 0

loading_fat:    db 'Loading File Allocation Table...', 0xD, 0xA, 0

fat_loaded:     db 'File Allocation Table loaded.', 0xD, 0xA, 0

    include 'src/print_str.S'


    times 510-($-$$) db 0
    dw 0xAA55                   ; The standard PC boot signature, little endian
