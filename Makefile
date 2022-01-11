CC=./toolchain/i386/bin/i386-termos-gcc
LD=./toolchain/i386/bin/i386-termos-ld
ASM=nasm

CFLAGS=-g -ffreestanding -Wall -Wextra -fno-exceptions -m32 -nostdlib

ASM_SOURCES=./kernel/boot/boot.asm \
	./kernel/boot/multiboot.asm
ASM_OBJECTS=./kernel/boot/boot.o \
	./kernel/boot/multiboot.o

C_SOURCES=./kernel/kernel.c
C_OBJECTS=./kernel/kernel.o

KERNEL_OBJECTS=$(ASM_OBJECTS) $(C_OBJECTS)

all: termOS

kernel: $(KERNEL_OBJECTS)
	@echo "[LD] Linking kernel..."
	@$(LD) -T kernel/linker.ld -o kernel.bin $(ASM_OBJECTS) $(C_OBJECTS)

termOS: kernel
	@cp kernel.bin ./sysroot/boot/kernel.bin
	@grub-mkrescue -o termOS.iso sysroot

run: termOS
	qemu-system-i386 termOS.iso -serial stdio

clean:
	@echo "[RM] Removing asm objects..."
	@rm $(ASM_OBJECTS)
	@echo "[RM] Removing C objects..."
	@rm $(C_OBJECTS)
	@echo "[RM] Removing kernel..."
	@rm kernel.bin
	@echo "[RM] Removing iso..."
	@rm termOS.iso

$(ASM_OBJECTS): $(ASM_SOURCES)
	@echo "[NASM] $(patsubst %.o, %.asm, $@) -o $@"
	@$(ASM) -f elf32 -o $@ $(patsubst %.o, %.asm, $@)

$(C_OBJECTS): $(C_SOURCES)
	@echo "[GCC] $(patsubst %.o, %.c, $@) -o $@"
	@$(CC) $(CFLAGS) -c $(patsubst %.o, %.c, $@) -o $@

toolchain:
	mkdir -p ./sysroot/usr/include
	mkdir -p ./sysroot/boot/grub
	printf 'set timeout=1\nset default=0\n\nmenuentry "termOS" {\n\tmultiboot2 /boot/kernel.bin "Run termOS kernel"\n\tboot\n}' > ./sysroot/boot/grub/grub.cfg
	cp -r ./libc/include ./sysroot/usr
	./toolchain/build.sh << 'y'