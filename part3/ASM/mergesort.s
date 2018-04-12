# Merge Sort
# Joel16

# Some references:
# $4 - $5 = $a0 - $a1
# $8 - $15 = $t0 - $t7
# $16 - $19 = $s0 - $s3
# $24 - $25 = $t8-$t9
.text
.globl main

main:
	addi $4, $0, 8

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	# load values into memory
	addi $8, $0, 5

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sw   $8, 0($4)
	add $14, $0, $8  # $t6 holds unsorted element 1

	addi $8, $0, 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sw   $8, 4($4)
	add $15, $0, $8  # $t7 holds unsorted element 2

	addi $8, $0, 4

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sw   $8, 8($4)
	add $24, $0, $8  # $t8 holds unsorted element 3

	addi $8, $0, 2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sw   $8, 12($4)
	add $25, $0, $8  # $t6 holds unsorted element 4

	addi $4, $4, 0   # pointer to original array

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	addi $5, $4, 20  # pointer to the sorted array

	# begin sorting

	# 5 1 4 2
	lw $8, 0($4)
	add $0, $0, $0    # nop
	lw $9, 4($4)
	add $0, $0, $0    # nop
	slt $10, $8, $9   # if (5 < 1) set $10 to 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	beq $10, $0, swap_1 # stops here mips_single_cycle.vhd 148 Architecture structure

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j next_1

swap_1:
	sw $8 4($4)
	sw $9 0($4)

next_1:
	# 1 5 4 2
	lw $8, 8($4)
	add $0, $0, $0    # nop
	lw $9, 12($4)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	slt $10, $8, $9   # if (4 < 2) set $10 to 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	beq $10, $0, swap_2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j next_2

swap_2:
	sw $8 12($4)
	sw $9 8($4)

next_2:
    # Final sort
    # $8 = left pointer, $9 = right pointer, $10 = sorted array pointer
	# 1 5    2 4

	addi $10, $5, 0                   # new array pointer
	addi $16, $0, 3                   # size

	addi $8, $4, 0                    # left pointer
	addi $9, $4, 8                    # right pointer

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

loop:
	beq $16, $0, storeLastElement

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	lw $11, 0($8)                     # dereference left
	add $0, $0, $0                    # nop
	lw $12, 0($9)	                  # dereference right
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	slt $13, $11, $12                 # if (1 < 2) set $13 to 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	beq $13, $0, store_right

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	sw $11, 0($10)                    # store left elemnt first
	addi $8, $8, 4                    # left++
	j next_3

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

store_right:
	sw $12, 0($10)                    # store right element first
	addi $9, $9, 4                    # right++

next_3:
	addi $10, $10, 4                  # increment new array pointer
	addi $16, $16, -1                 # decrement size TODO: make sure this is doing the right thing in the simulation!!1

# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j loop

storeLast_rightHalf:
	sw $12, 0($10)
	j done

storeLast_leftHalf:
	sw $11, 0($10)
	j done

storeLastElement:
	slt $13, $11, $12                 # if (1 < 2) set $13 to 1

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	beq $13, $0, storeLastElement_left
	sw $12, 0($10)                    # store right elemnt first
	j done

storeLastElement_left:
	sw $11, 0($10)                    # store left element first

done:
	lw $16, 0($5)   # registers $16-$19 hold the final merge-sorted list
	lw $17, 4($5)
	lw $18, 8($5)
	lw $19, 12($5)
