# This is a program that makes use of some nops to test against data hazards

.text
.globl main

main:
	addi $1, $0, 0
	addi $2, $0, 0
	addi $3, $0, 0
	addi $4, $0, 0
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $2, $1, 2     # $2 = 2
	addi $3, $2, 2     # $3 = 4
	add $4, $3, $3     # $4 = 8

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $2, $0, 0x100
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($0)     # Store $2 into ($0 + 0) -> 0x100
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	lw $3, 0($0)     # load data from memory ($0 + 0)
	add $4, $3, 1    # $4 = 100 + 1 = 101

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0