bits 32
[EXTERN kmain]

section .boot
global _start
_start:
    ; We are now on 32bits mode loaded by multiboot2, the multiboot2 GDT not must be correct
    ; If true eax = 0x36d76289 and ebx = *multiboot_info
    cli
    lgdt [gdt_descriptor]  ; Load our own GDT at the very beginning

    jmp CODE_SEG:init      ; Far jump using the kernel code segment

init:
    mov esp, _stackTop     ; Set up the stack
    push ebx               ; Push the address of the multiboot2 info header
    push eax               ; Push the magic number

    mov ax, DATA_SEG       ; Update the segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call kmain       ; Call our main kernel function

    ; Should never return here ;
    mov dword [0xb8000], 0x2f4b2f4f

.hlt_loop:  
    hlt
    jmp .hlt_loop

;------- GDT ---------;

gdt_start: ; don't remove the labels, they're needed to compute sizes and jumps
    ; Null segment descriptor, it cannot be used
    dd 0x0 ; 4 byte
    dd 0x0 ; 4 byte

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36
code_segment:
    ; Segment code descriptor
    dw 0xffff    ; segment limit: bits 0:15
    dw 0x0       ; segment base:  bits 0:15
    db 0x0       ; segment base,  bits 16-23
    db 10011010b ; Access Byte
    db 11001111b ; flags (4 bits) | segment limit: bits 16-19
    db 0x0       ; segment base, bits 24-31

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
data_segment:
    ; Segment data descriptor
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b  ; For a 64bits GDT should be 10101111b
    db 11001111b
    db 0x0

; TODO: Add TSS (Task State Segment) segment descriptor

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
    dd gdt_start ; address (32 bit)

; define some constants for later use
CODE_SEG equ code_segment - gdt_start
DATA_SEG equ data_segment - gdt_start

section .bss
    resb 4096
_stackTop: