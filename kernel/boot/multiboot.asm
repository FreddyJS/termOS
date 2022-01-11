[extern _loadStart]
[extern _loadEnd]
[extern _bssEnd]
[extern _start]

section .multiboot
header_start:
    dd 0xe85250d6                ; magic number (multiboot 2) off = 0
    dd 0                         ; architecture 0 (protected mode i386) off = 4
    dd header_end - header_start ; header length off = 8
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) ; off = 12

; Request prefered framebuffer, needed when we move from text mode to graphics mode
; framebuffer_tag:
;     dw 5, 0
;     dd framebuffer_tag - framebuffer_end
;     dd 640
;     dd 480
;     dd 32
;     dd 0
; framebuffer_end:

info_req: ; this is offset 16, each tag must be aligned to 8 bytes so tagoff%8 = 0
    dw 1, 0                 ; off = 16 + 4 bytes (2 words). this ends on offset 20
    dd info_end - info_req  ; each dd adds 4 bytes to the offset. this end on offset 24
    dd 5  ; BIOS Boot Device
    dd 1  ; Command Line
    dd 3  ; Modules
    dd 9  ; ELF Symbols
    dd 6  ; Memory Map
    dd 10 ; APM Table // this is offset 44 + 4 we end on offset 48. need align? 48%8 = 0 NO!
info_end:

addr_tag:   ; Address Header Tag
    dw 2, 0 ; type = 2 (16b) flags = 0
    dd addr_end - addr_tag
    dd header_start
    dd _loadStart
    dd _loadEnd
    dd _bssEnd 
addr_end:

entry_tag:
    dw 3, 0
    dd entry_end - entry_tag
    dd _start
    dd 0 ; align next tag to 8 byte
entry_end:

    ; required end tag
    dw 0, 0    ; type, flags
    dd 8    ; size
header_end: