.text
.globl main

main:
	addiu $sp, $sp, -32
	sw $fp, 24($sp)
	addiu $fp, $sp, 0

# Load and store test:
lw_sw:
	addi $2, $0, 4
	sw $2, 8($fp)
	lw $2, 8($fp)
	sw $2, 16($fp)

# Read after write data hazard
raw_test:
	addi $2, $0, 1	# $2 = 1
	addi $3, $2, 1	# $3 = 1 + 1 = 2

# Write after write data hazard
waw_test:
	addi $2, $0, 1	# $2 = 1
	addi $2, $0, 2	# $2 = 2

# Write after read data hazard
war_test:
	addi $1, $0, 1	# $1 = 1
	addi $2, $1, 1	# $2 = 1 + 1 = 2
	addi $1, $0, 2	# $1 = 2

# Control hazards

# branch to test2 if $3 = $2 (4 == 4)?
	addi $2, $0, 4
	lw $3, 16($fp)
	beq $3, $2, $test2

# branch to test3 if $3 = $2 (4 == 10)?
	addi $2, $0, 10
	lw $3, 16($fp)
	beq $3, $2, $test3

# branch to test1 if $3 = $2 (4 == 1)?
	addi $2, $0, 1
	lw $3, 16($fp)
	beq $3, $2, $test1

# branch to test4
	beq $0, $0, $test4

# Test cases used:
	$test1:
	lw $2, 8($fp)
	addiu $2, $2, 2
	sw $2, 8($fp)
	beq $0, $0, $test4

	$test2:
	lw $2, 8($fp)		# lw used as branch delays slot
	sll $2, $2, 2
	sw $2, 8($fp)
	beq $0, $0, $test4

	$test3:
	lw $2, 8($fp)		# lw used as branch delays slot
	srl $2, $2, 2
	sw $2, 8($fp)
	
	$test4:
	addiu $sp, $fp, 0
	lw $fp, 24($sp)
	addiu $sp, $sp, 32
	jr $31
	