# This is a program that makes use of all the MIPS instruction from part (b) of Proj2.

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
	addi $1, $0, 1		        # $1 = 1
	or $3, $1, $1 			# 1 OR 1 = 1, $3 = 1
	ori $3, $0, 0		        # 1 OR 0 = 0, $3 = 0
	nor $3, $1, $1			# 1 NOR 1 = 0, $3 = -2? => $3 = 0xfffffffe
	xor $3, $1, $0		        # 1 XOR 0 = 1, $3 = 1
	xori $3, $1, 0			# 1 XOR 0 = 1, $3 = 1

sltTest:
	addi $1, $0, 0		        # $1 = 0
	addi $2, $0, 1		        # $2 = 1
	slt $3, $1, $2			# $3 = 0 < 1, $3 = 1
	slti $3, $2, 0			# $3 = 1 < 1, $3 = 0
	sltiu $3, $0, 1		        # $3 = 0 < 1, $3 = 1
	sltu $3, $2, $1			# $3 = 1 < 0, $3 = 0

shiftTest:
	addi $1, $0, 2		        # $1 = 2
	sll $2, $1, 2 			# $2 = 2 x (2^2) = 8
	srl $2, $2, 2 			# $2 = 8/4 = 2
	sra, $2, $2, 1			# $2 = 2 / 2 = 1
	sllv $2, $2, $1			# $2 = 1 * 2^2 = 4
	srlv $2, $2, $1			# $2 = 4/4 = 1
	srav $2, $1, $2, 		# $2 = 2/2 = 1

subTest:
	addi $1, $0, 2		        # $1 = 2
	addi $2, $0, 1		        # $2 = 1
	addi $3, $0, 4		        # $3 = 4
	sub $4, $1, $2			# $4 = 2 - 1 = 1
	subu $4, $3, $2			# $4 = 4 - 1 = 3

beqTest:
	addi $1, $0, 0		        # $1 = 0
	addi $2, $0, 0		        # $2 = 0
	j beqCond                       # jump to beqCond -> test for branch equal

beqCond:
	beq $1, $2, beqTrue             # if ($1 == $2) -> goto beqTrue;

beqTrue:
	addi $1, $0, 1                  # $1 = 1 if true
	j bneTest                       # goto bneTest;

bneTest:
	addi $1, $0, 0                  # $1 = 0
	addi $2, $0, 0                  # $2 = 0
	j bneCond                       # jump to bneCond -> test for branch not equal

bneCond:
	bne $1, $2, bneTrue             # if ($1 != $2) -> goto bneTrue // In this case I test for false
	j bneFalse                      # bne will fail cause 0 != 0 -> hence we jump to bneFalse

bneTrue:
	addi $1, $0, 1                  # $1 = 1 if bne succeeds

bneFalse:
	addi $2, $0, 1                  # $2 = 1 if bne fails
	jal simpleFunc                  # Jump and link to simpleFunc(tion), after this $2 will be set to 2. // PC = 0x000000ac
	j loadAndStoreTest              # After our JAL, proceed to loadAndStoreTest

simpleFunc:
	addi $2, $0, 2                  # $2 = 2
	jr $31                          # 0x000000ac + 4 = 0x000000b0

loadAndStoreTest:
	lui $1, 4097 			# 4097 = 1001 hex. The upper 16 bits is stored in $1 - Results in 0x10010000 in hex
	addi $25, $0, 1000 		# Load &A into $25 (mem location 0x10000000)
	addi $1, $zero, 4		# $1 = 4
	addi $2, $zero, 8		# $2 = 8
	sw $1, 0($25) 			# Store A[0] into $1
	sw $2, 4($25) 			# Store A[1] into $2
	lw $3, 0($25) 			# Load A[0] into $3
	lw $4, 4($25) 			# Load A[1] into $4
	