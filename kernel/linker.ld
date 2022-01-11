ENTRY(_start)

SECTIONS
{
    . = 0x100000;

    .boot : 
    {  
        *(.multiboot)  /* Set the multiboot header at the start */
        _loadStart = .;            /* Mark the start point of our code      */
        *(.boot)
    } 

    .text : ALIGN(0x1000)
    {
        *(.text)
    }

    .data : ALIGN(0x1000)
    {
        *(.data)
    }

    .rodata : ALIGN(0x1000)
    {
        *(.rodata)
    }

    _loadEnd = .;        /* Mark the finish point of our code */

    .bss : ALIGN(0x1000)
    {
        *(COMMON)
        *(.bss)
    }

    _bssEnd = .;       /* Finish of unitialized data*/

}