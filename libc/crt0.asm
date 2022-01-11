.section .text

.global _start
_start:
	# Set up end of the stack frame linked list.
	mov $0, %ebp
	push %ebp # rip=0
	push %ebp # ebp=0
	mov %esp, %ebp

	# We need those in a moment when we call main.
	push %esi
	push %edi

	# Run the global constructors.
	call _init

	# Restore argc and argv.
	pop %edi
	pop %esi

	# Run main
	call main

	# Terminate the process with the exit code.
	movl %eax, %edi
	call exit
.size _start, . - _start
