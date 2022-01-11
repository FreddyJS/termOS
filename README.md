# termOS - Terminal Operating System
**Operating System for the i386 architecture.**  

Hobby operating system written for fun, it cannot really do anything but maybe it will.  

## Used References
Starting point: [OS Tutorial: From a 16bits bootloader to a 32bits kernel with interrupts](https://github.com/cfenollosa/os-tutorial)   
   
The core reference: [OS Dev Wiki](https://wiki.osdev.org/Expanded_Main_Page)   
ASM in C: [Using Inline Assembly in C/C++](https://www.codeproject.com/Articles/15971/Using-Inline-Assembly-in-C-C)   

## TODO List
- [x] Boot with grub2 and multiboot2
- [x] Call C code from ASM
- [x] Load a valid GDT
- [ ] Print to the screen
- [ ] Load a valid IDT
- [ ] Support keyboard input

## Multiboot2 i386 Machine State
* **EAX**:Must contain the magic value ‘0x36d76289’; the presence of this value indicates to the operating system that it was loaded by a Multiboot2-compliant boot loader (e.g. as opposed to another type of boot loader that the operating system can also be loaded from).
* **EBX**: Must contain the 32-bit physical address of the Multiboot2 information structure provided by the boot loader (see Boot information format).
* **CS**: Must be a 32-bit read/execute code segment with an offset of ‘0’ and a limit of ‘0xFFFFFFFF’. The exact value is undefined.
* **‘DS’, ‘ES’, ‘FS’, ‘GS’, ‘SS’**: Must be a 32-bit read/write data segment with an offset of ‘0’ and a limit of ‘0xFFFFFFFF’. The exact values are all undefined.
* **A20 gate**: Must be enabled.
* **CR0**: Bit 31 (PG) must be cleared. Bit 0 (PE) must be set. Other bits are all undefined.
* **EFLAGS**: Bit 17 (VM) must be cleared. Bit 9 (IF) must be cleared. Other bits are all undefined.

All other processor registers and flag bits are undefined. This includes, in particular:

* **ESP**: The OS image must create its own stack as soon as it needs one.
* **GDTR**: Even though the segment registers are set up as described above, the ‘GDTR’ may be invalid, so the OS image must not load any segment registers (even just reloading the same values!) until it sets up its own ‘GDT’.
* **IDTR**: The OS image must leave interrupts disabled until it sets up its own IDT.

On EFI system boot services must be terminated.