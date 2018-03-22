# Original author: jmc734
# Modified by: Joel16
.text
.globl main
main:
	addiu $sp, $0, 256 # li $sp, 256        # Adjust the stack pointer
	addiu $a0, $0, 56  # li $a0, 56         # Load the start address
	addiu $t0, $0, 4   # li $t0, 4          # Load the array length
	sll $t0, $t0, 2    # Multiple the array length by 4 (the size of the elements)
	add $a1, $a0, $t0  # Calculate the array end address
	jal mergesort      # Call the merge sort function
  	j sortend          # We are finished sorting

##
# Recrusive mergesort function
#
# @param $a0 first address of the array
# @param $a1 last address of the array
##
mergesort:
	addi $sp, $sp, -16        # Adjust stack pointer
	sw $ra, 0($sp)            # Store the return address on the stack
	sw $a0, 4($sp)            # Store the array start address on the stack
	sw $a1, 8($sp)            # Store the array end address on the stack

	sub $t0, $a1, $a0         # Calculate the difference between the start and end address (i.e. number of elements * 4)

	addi $t8, $0, 4           # $t8 = 4;
	slt $t9, $t8, $t0         # if (t8 < t0) -> put it in t9
	beq $t9, $0, mergesortend # If the array only contains a single element, just return

	srl $t0, $t0, 3           # Divide the array size by 8 to half the number of elements (shift right 3 bits)
	sll $t0, $t0, 2           # Multiple that number by 4 to get half of the array size (shift left 2 bits)
	add $a1, $a0, $t0         # Calculate the midpoint address of the array
	sw $a1, 12($sp)           # Store the array midpoint address on the stack

	jal	mergesort             # Call recursively on the first half of the array

	lw $a0, 12($sp)           # Load the midpoint address of the array from the stack
	lw $a1, 8($sp)            # Load the end address of the array from the stack

	jal mergesort             # Call recursively on the second half of the array

	lw $a0, 4($sp)            # Load the array start address from the stack
	lw $a1, 12($sp)           # Load the array midpoint address from the stack
	lw $a2, 8($sp)            # Load the array end address from the stack

	jal merge                 # Merge the two array halves

mergesortend:
	lw $ra, 0($sp)            # Load the return address from the stack
	addi $sp, $sp, 16         # Adjust the stack pointer
	jr $ra                    # Return

##
# Merge two sorted, adjacent arrays into one, in-place
#
# @param $a0 First address of first array
# @param $a1 First address of second array
# @param $a2 Last address of second array
##
merge:
	addi $sp, $sp, -16       # Adjust the stack pointer
	sw $ra, 0($sp)           # Store the return address on the stack
	sw $a0, 4($sp)           # Store the start address on the stack
	sw $a1, 8($sp)           # Store the midpoint address on the stack
	sw $a2, 12($sp)          # Store the end address on the stack
	
	addiu $s0, $a0, 0        # Create a working copy of the first half address
	addiu $s1, $a1, 0        # Create a working copy of the second half address

mergeloop:
	lw $t0, 0($s0)           # Load the first half position value
	lw $t1, 0($s1)           # Load the second half position value

	slt $t9, $t0, $t1
	bne $t9, $0, noshift     # If the lower value is already first, don't shift
    
	addiu $a0, $s1, 0        # Load the argument for the element to move
	addiu $a1, $s0, 0        # Load the argument for the address to move it to
	jal shift                # Shift the element to the new position

	addi $s1, $s1, 4         # Increment the second half index

noshift:
	addi $s0, $s0, 4            # Increment the first half index
	
	lw $a2, 12($sp)             # Reload the end address
	
	slt $t9, $s0, $a2
	beq $t9, $0, mergeloopend   # End the loop when both halves are empty
	
	slt $t9, $s1, $a2
	beq $t9, $0, mergeloopend   # End the loop when both halves are empty
	
	beq $0, $0, mergeloop

mergeloopend:
	lw $ra, 0($sp)             # Load the return address
	addi $sp, $sp, 16          # Adjust the stack pointer
	jr $ra                     # Return

##
# Shift an array element to another position, at a lower address
#
# @param $a0 address of element to shift
# @param $a1 destination address of element
##
shift:
	addiu $t0, $0, 10       # li $t0, 10
	slt $t9, $a1, $a0
	beq $t9, $0, shiftend   # If we are at the location, stop shifting

	addi $t6, $a0, -4       # Find the previous address in the array
	lw $t7, 0($a0)          # Get the current pointer
	lw $t8, 0($t6)          # Get the previous pointer
	sw $t7, 0($t6)          # Save the current pointer to the previous address
	sw $t8, 0($a0)          # Save the previous pointer to the current address
	addiu $a0, $t6, 0       # Shift the current position back
	beq $0, $0, shift       # Loop again

shiftend:
	jr $ra                  # Return

sortend:                    # Point to jump to when sorting is complete
