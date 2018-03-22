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
	
	# load values into memory
	addi $8, $0, 5
	sw   $8, 0($4)
	add $14, $0, $8  # $t6 holds unsorted element 1
	
	addi $8, $0, 1
	sw   $8, 4($4)
	add $15, $0, $8  # $t7 holds unsorted element 2

	addi $8, $0, 4
	sw   $8, 8($4)
	add $24, $0, $8  # $t8 holds unsorted element 3

	addi $8, $0, 2
	sw   $8, 12($4)
	add $25, $0, $8  # $t6 holds unsorted element 4
		
	addi $4, $4, 0   # pointer to original array
	addi $5, $4, 20  # pointer to the sorted array
	
	# begin sorting
		
	# 5 1 4 2
	lw $8, 0($4)
	add $0, $0, $0    # nop
	lw $9, 4($4)
	add $0, $0, $0    # nop
	slt $10, $8, $9   # if (5 < 1) set $10 to 1
	beq $10, $0, swap_1 # stops here mips_single_cycle.vhd 148 Architecture structure
	j next_1

swap_1:
	sw $8 4($4)
	sw $9 0($4)

next_1:	
	# 1 5 4 2
	lw $8, 8($4)
	add $0, $0, $0    # nop
	lw $9, 12($4)
	add $0, $0, $0    # nop
	slt $10, $8, $9   # if (4 < 2) set $10 to 1
	beq $10, $0, swap_2
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
	
loop:
	beq $16, $0, storeLastElement	
	lw $11, 0($8)                     # dereference left
	add $0, $0, $0                    # nop
	lw $12, 0($9)	                  # dereference right
	add $0, $0, $0                    # nop
	slt $13, $11, $12                 # if (1 < 2) set $13 to 1
	beq $13, $0, store_right
	sw $11, 0($10)                    # store left elemnt first
	addi $8, $8, 4                    # left++
	j next_3
	     
store_right:
	sw $12, 0($10)                    # store right element first
	addi $9, $9, 4                    # right++

next_3:	
	addi $10, $10, 4                  # increment new array pointer
	addi $16, $16, -1                 # decrement size
	j loop

storeLast_rightHalf:	
	sw $12, 0($10)
	j done

storeLast_leftHalf:	
	sw $11, 0($10)
	j done	
			
storeLastElement:
	slt $13, $11, $12                 # if (1 < 2) set $13 to 1
	beq $13, $0, storeLastElement_left
	sw $12, 0($10)                    # store right elemnt first
	j done
	        
storeLastElement_left:
	sw $11, 0($10)                    # store left element first 
		
done:		
	lw $16, 0($5)
	add $14, $0, $16    # $t6 holds sorted element 1 
	lw $17, 4($5)
	add $15, $0, $17    # $t7 holds sorted element 2
	lw $18, 8($5)
	add $24, $0, $18    # $t8 holds sorted element 3
	lw $19, 12($5)
	add $25, $0, $19    # $t9 holds sorted element 4
