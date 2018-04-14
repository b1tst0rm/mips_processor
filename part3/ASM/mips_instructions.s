# This is a program that makes use of all the MIPS instruction from part (b) of Proj2.

.text
.globl main

main:

addTest:
	addi $1, $0, 1			# $1 = 1
	addiu $2, $0, 3			# $2 = 3

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	add $3, $1, $2			# $3 = 1 + 3 = 4
	addu $4, $1, $2			# t4 = 1 + 2 = 4

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

andTest:
	andi $5, $3, 3			# $5 = 4 % 4 = 0
	and  $6, $4, $4			# $6 = 4 & 4 = 4

orTest:
	addi $1, $0, 1		        # $1 = 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	or $3, $1, $1 			# 1 OR 1 = 1, $3 = 1
	ori $3, $0, 0		        # 1 OR 0 = 0, $3 = 0
	nor $3, $1, $1			# 1 NOR 1 = 0, $3 = -2? => $3 = 0xfffffffe
	xor $3, $1, $0		        # 1 XOR 0 = 1, $3 = 1
	xori $3, $1, 0			# 1 XOR 0 = 1, $3 = 1

sltTest:
	addi $1, $0, 0		        # $1 = 0
	addi $2, $0, 1		        # $2 = 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	slt $3, $1, $2			# $3 = 0 < 1, $3 = 1
	slti $3, $2, 0			# $3 = 1 < 1, $3 = 0
	sltiu $3, $0, 1		        # $3 = 0 < 1, $3 = 1
	sltu $3, $2, $1			# $3 = 1 < 0, $3 = 0

shiftTest:
	addi $1, $0, 2		        # $1 = 2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sll $2, $1, 2 			# $2 = 2 x (2^2) = 8

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	srl $2, $2, 2 			# $2 = 8/4 = 2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sra, $2, $2, 1			# $2 = 2 / 2 = 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sllv $2, $2, $1			# $2 = 1 * 2^2 = 4

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	srlv $2, $2, $1			# $2 = 4/4 = 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	srav $2, $1, $2, 		# $2 = 2/2 = 1

subTest:
	addi $1, $0, 2		        # $1 = 2
	addi $2, $0, 1		        # $2 = 1
	addi $3, $0, 4		        # $3 = 4

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sub $4, $1, $2			# $4 = 2 - 1 = 1
	subu $4, $3, $2			# $4 = 4 - 1 = 3

beqTest:
	addi $1, $0, 0		        # $1 = 0
	addi $2, $0, 0		        # $2 = 0

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j beqCond                       # jump to beqCond -> test for branch equal

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

beqCond:
	beq $1, $2, beqTrue             # if ($1 == $2) -> goto beqTrue;

beqTrue:
	addi $1, $0, 1                  # $1 = 1 if true
	j bneTest                       # goto bneTest;

bneTest:
	addi $1, $0, 0                  # $1 = 0
	addi $2, $0, 0                  # $2 = 0

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j bneCond                       # jump to bneCond -> test for branch not equal

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

bneCond:
	bne $1, $2, bneTrue             # if ($1 != $2) -> goto bneTrue // In this case I test for false

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j bneFalse                      # bne will fail cause 0 != 0 -> hence we jump to bneFalse

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

bneTrue:
	addi $1, $0, 1                  # $1 = 1 if bne succeeds

bneFalse:
	addi $2, $0, 1                  # $2 = 1 if bne fails
	jal simpleFunc                  # Jump and link to simpleFunc(tion), after this $2 will be set to 2. // PC = 0x000000ac

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j loadAndStoreTest              # After our JAL, proceed to loadAndStoreTest

simpleFunc:
	addi $2, $0, 2                  # $2 = 2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	jr $31                          # 0x000000ac + 4 = 0x000000b0

loadAndStoreTest:
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	lui $1, 4097 			# 4097 = 1001 hex. The upper 16 bits is stored in $1 - Results in 0x10010000 in hex


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
	