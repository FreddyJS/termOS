#define hlt(); asm volatile("hlt")

void idle();

/*  Check if MAGIC is valid and print the Multiboot information structure pointed by ADDR. */
void kmain(unsigned long magic, unsigned long addr)
{  
  (void) magic;
  (void) addr;

  idle();
}

void idle(){
    while (1) {
        hlt();
    }
}