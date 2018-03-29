# Original author: jmc734
# Modified by: Joel16

.data
# Array contents
eight:	.word	8                    # 1st element
five:	.word	5                    # 2nd element
four:	.word	4                    # 3rd element
nine:	.word	9                    # 4th element

# An array of pointers (indirect array)
length:	.word	4                    # Array length
array:	.word	eight
	.word	five
	.word	four
	.word	nine

.text
.globl main

main:
	la $a0, array                # Load the start address of the array
	lw $t0, length               # Load the array length
	sll $t0, $t0, 2              # Multiple the array length by 4 (the size of the elements)
	add $a1, $a0, $t0            # Calculate the array end address
	jal mergesort                # Call the merge sort function
  	beq $0, $0, sortend          # We are finished sorting
	
##
# Recrusive mergesort function
#
# @param $a0 first address of the array
# @param $a1 last address of the array
##
mergesort:
	addi $sp, $sp, -16           # Adjust stack pointer
	sw $ra, 0($sp)               # Store the return address on the stack
	sw $a0, 4($sp)               # Store the array start address on the stack
	sw $a1, 8($sp)               # Store the array end address on the stack
	
	sub $t0, $a1, $a0            # Calculate the difference between the start and end address (i.e. number of elements * 4)

	addi $t9, $0, 4
	slt $at, $t9, $t0
	beq $at, $0, mergesortend    # If the array only contains a single element, just return 
	
	srl $t0, $t0, 3              # Divide the array size by 8 to half the number of elements (shift right 3 bits)
	sll $t0, $t0, 2              # Multiple that number by 4 to get half of the array size (shift left 2 bits)
	add $a1, $a0, $t0            # Calculate the midpoint address of the array
	sw $a1, 12($sp)              # Store the array midpoint address on the stack
	
	jal mergesort                # Call recursively on the first half of the array
	
	lw $a0, 12($sp)              # Load the midpoint address of the array from the stack
	lw $a1, 8($sp)               # Load the end address of the array from the stack
	
	jal mergesort                # Call recursively on the second half of the array
	
	lw $a0, 4($sp)               # Load the array start address from the stack
	lw $a1, 12($sp)              # Load the array midpoint address from the stack
	lw $a2, 8($sp)               # Load the array end address from the stack
	
	jal merge                    # Merge the two array halves
	
mergesortend:
	lw $ra, 0($sp)               # Load the return address from the stack
	addi $sp, $sp, 16            # Adjust the stack pointer
	jr $ra                       # Return 
	
##
# Merge two sorted, adjacent arrays into one, in-place
#
# @param $a0 First address of first array
# @param $a1 First address of second array
# @param $a2 Last address of second array
##
merge:
	addi $sp, $sp, -16           # Adjust the stack pointer
	sw $ra, 0($sp)               # Store the return address on the stack
	sw $a0, 4($sp)               # Store the start address on the stack
	sw $a1, 8($sp)               # Store the midpoint address on the stack
	sw $a2, 12($sp)              # Store the end address on the stack
	
	addiu $s0, $a0, 0            # Create a working copy of the first half address
	addiu $s1, $a1, 0            # Create a working copy of the second half address           
	
mergeloop:
	lw $t0, 0($s0)               # Load the first half position pointer
	lw $t1, 0($s1)               # Load the second half position pointer
	lw $t0, 0($t0)               # Load the first half position value
	lw $t1, 0($t1)               # Load the second half position value
	
	slt $at, $t0, $t1
	bne $at, $0, noshift         # If the lower value is already first, don't shift
	
	addiu $a0, $s1, 0            # Load the argument for the element to move
	addiu $a1, $s0, 0            # Load the argument for the address to move it to         
	jal shift                    # Shift the element to the new position 
	
	addi $s1, $s1, 4             # Increment the second half index

noshift:
	addi $s0, $s0, 4             # Increment the first half index
	
	lw $a2, 12($sp)              # Reload the end address
	slt $at, $s0, $a2
	beq $at, $0, mergeloopend    # End the loop when both halves are empty 
	slt $at, $s1, $a2
	beq $at, $0, mergeloopend    # End the loop when both halves are empty
	beq $0, $0, mergeloop
	
mergeloopend:
	lw $ra, 0($sp)               # Load the return address
	addi $sp, $sp, 16            # Adjust the stack pointer
	jr $ra                       # Return

##
# Shift an array element to another position, at a lower address
#
# @param $a0 address of element to shift
# @param $a1 destination address of element
##
shift:
	addiu $t0, $0, 10
	slt $at, $a1, $a0
	beq $at, $0, shiftend        # If we are at the location, stop shifting
	addi $t6, $a0, -4            # Find the previous address in the array
	lw $t7, 0($a0)               # Get the current pointer
	lw $t8, 0($t6)               # Get the previous pointer
	sw $t7, 0($t6)               # Save the current pointer to the previous address
	sw $t8, 0($a0)               # Save the previous pointer to the current address
	addiu $a0, $t6, 0            # Shift the current position back	
	beq $0, $0, shift            # Loop again

shiftend:
	jr $ra                       # Return

# Sorting is complete store sorted numbers in registers t2-t5
sortend:
	# Sorted element 1
	addi $t0, $0, 0
	lw $t1, array($t0)
	lw $t2, 0($t1)
	
	# Sorted element 2
	addi $t0, $0, 4
	lw $t1, array($t0)
	lw $t3, 0($t1)

	# Sorted element 3
	addi $t0, $0, 8
	lw $t1, array($t0)
	lw $t4, 0($t1)

	# Sorted element 4
	addi $t0, $0, 12
	lw $t1, array($t0)
	lw $t5, 0($t1)
