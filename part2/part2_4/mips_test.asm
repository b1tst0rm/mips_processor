# This is a program that makes use of all the MIPS instruction from part (a) of Proj2.

.text
.globl main

main:

addTest:
	addi $1, $1, 1			# $1 = 1
	addiu $2, $2, 3			# $2 = 3
	add $3, $1, $2			# $3 = 1 + 3 = 4
	addu $4, $1, $2			# t4 = 1 + 2 = 4

andTest:
	andi $5, $3, 3			# $5 = 4 % 4 = 0
	and  $6, $4, $4			# $6 = 4 & 4 = 4

orTest:
	addi $1, $zero, 1		# $1 = 1
	or $3, $1, $1 			# 1 OR 1 = 1, $3 = 1
	ori $3, $zero, 0		# 1 OR 0 = 0, $3 = 0
	nor $3, $1, $1			# 1 NOR 1 = 0, $3 = -2? => $3 = 0xfffffffe
	xor $3, $1, $zero		# 1 XOR 0 = 1, $3 = 1
	xori $3, $1, 0			# 1 XOR 0 = 1, $3 = 1

sltTest:
	addi $1, $zero, 0		# $1 = 0
	addi $2, $zero, 1		# $2 = 1
	slt $3, $1, $2			# $3 = 0 < 1, $3 = 1
	slti $3, $2, 0			# $3 = 1 < 1, $3 = 0
	sltiu $3, $zero, 1		# $3 = 0 < 1, $3 = 1
	sltu $3, $2, $1			# $3 = 1 < 0, $3 = 0

shiftTest:
	addi $1, $zero, 2		# $1 = 2
	sll $2, $1, 2 			# $2 = 2 x (2^2) = 8
	srl $2, $2, 2 			# $2 = 8/4 = 2
	sra, $2, $2, 1			# $2 = 2 / 2 = 1
	sllv $2, $2, $1			# $2 = 1 * 2^2 = 4
	srlv $2, $2, $1			# $2 = 4/4 = 1
	srav $2, $1, $2, 		# $2 = 2/2 = 1

subTest:
	addi $1, $zero, 2		# $1 = 2
	addi $2, $zero, 1		# $2 = 1
	addi $3, $zero, 4		# $3 = 4
	sub $4, $1, $2			# $4 = 2 - 1 = 1
	subu $4, $3, $2			# $4 = 4 - 1 = 3

loadAndStoreTest:
	lui $8, 4096                    # $8 = 0x10000000
	ori $8, $8, 0                   # $8 = 0x10000000 -> These two implement the load address pseudo instruction.
	addi $9, $0, 4                  # $9 = 4
	addi $10, $0, 8                 # $10 = 8
	sw $9, 0($8)                    # Store $9 into A[0] -> '4' is stored in mem 0x10000000
	sw $10, 4($8)                   # Store $10 into A[1] -> '8' is stored in mem 0x10000004
	lw $11, 0($8)                   # Load A[0] into $11 -> load value from memory 0x10000000 which is '4'
	lw $12, 4($8)                   # Load A[1] into $12 -> load value from memory 0x10000004 which is '8'