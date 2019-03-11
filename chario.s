.equ	LAST_RAM_WORD, 	0X007FFFFC
	.equ 	JTAG_UART_BASE,	0x10001000
	.equ	DATA_OFFSET,	0
	.equ	STATUS_OFFSET,	4
	.equ	WSPACE_MASK,	0xFFFF
	.equ 	RANDOM_NUMBER, 	0x8000
	.equ	OTHER_NUMBER, 	0xFF

	.text
	.global PrintChar, PrintString, GetChar
	
PrintChar: 
	subi	sp, sp, 8
	stw		r3, 4(sp)
	stw		r4, 0(sp)
	movia	r3, JTAG_UART_BASE 
pc_loop: 
	ldwio	r4, STATUS_OFFSET(r3) 
	andhi	r4, r4, WSPACE_MASK
	beq		r4, r0, pc_loop
	stwio	r2, DATA_OFFSET(r3)
	ldw 	r3, 4(sp) 
	ldw		r4, 0(sp)
	addi	sp, sp, 8 
	ret
	
PrintString: 
	subi	sp, sp, 12
	stw 	ra, 8(sp)
	stw 	r3, 4(sp) 
	stw 	r2, 0(sp)
	mov 	r3, r2 
ps_loop: 
	ldb 	r2, 0(r3)
	beq		r2, r0, end_ps_loop 
	call 	PrintChar
	addi 	r3, r3, 1 
	br		ps_loop 
end_ps_loop:
	ldw 	ra, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r2, 0(sp)
	addi 	sp, sp, 12 
	ret 
	
GetChar: 
	subi	sp, sp, 16
	stw		ra, 12(sp) #because print decimal calls this routine?
	stw		r2, 8(sp) #need a register that will return the variable
	stw		r3, 4(sp)
	stw 	r4, 0(sp) #r4 is st
	movia 	r3, JTAG_UART_BASE #r3 is data
gc_loop:
	ldwio 	r3, DATA_OFFSET(r3) #i think im setting data to read JTAG UART data register
	andi	r4,675 r3, RANDOM_NUMBER #i think im and-ing data and 0x8000
	beq 	r4, r0, gc_loop #while st is equal to? zero
	#stwio 	r2, DATA_OFFSET(r3) #and this line - im not entirely sure if this is right
	andi	r2, r3, OTHER_NUMBER #data and 0xFF and place it into r2
	ldw		ra, 12(sp)
	ldw		r2, 8(sp)
	ldw 	r3, 4(sp)
	ldw 	r4, 0(sp)
	addi 	sp, sp, 16
	ret