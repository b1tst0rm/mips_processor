# Joel16 - Bubblesort
# Uses an initally unsorted array stored in data mem to procedurally sort using bubble sort.	
.text		
.globl main
main:
	addiu $16, $28, 0           # get the intial point to save array 
	addi $8, $0, 4             # $8 = 4 (word addressing)
	add $9, $0, $0
	add $10, $0, $0		 
	add $11, $0, $0
	add $14, $0, $0 
	add $12, $0, $0
	add $17, $16, $0            # copy the pointer to array in $17
	

# Store values in memory
initValues:
	addi $2, $0, -5
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	addi $2, $0, 4
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $2, $0, 9
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	addi $2, $0, 0
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	addi $2, $0, 1
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $2, $0, 8
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $2, 0($17)              # Store the value at the mem location pointed by $17 + 0
	addi $17, $17, 4            # Move the $17 pointer by 4 - Word addressing (i++)
	add $13, $17, $0            # $13 stores the end value 
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	j bubblesort                # Begin sort
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

bubblesort:
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	add $12, $16, $0            # Put $16, in $12
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $14, $14, 4            # Add 4 to $14 (Word addressing)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sub $17, $17, $8           # $17 = s1 - 4
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	beq $17, $16, end          # if s1 == s0, we have sorted everything
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	add $18, $16, $0            # $18 = $16
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

internalLoop:
	lw $9, 0($18)              # first element at mem location $18 + 0
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	lw $10, 4($18)              # second element at mem location $18 + 4
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	slt $11, $10, $9           # if ($10 < $9) -> $11 = 1
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	beq $11, $0, next           # if ($11 == 0) goto next;
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $10, 0($18)              # store first element in t2
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	sw $9, 4($18)              # store second element in t1

next:
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $18, $18, 4            # $18 = $18 + 4
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	bne $18, $17, internalLoop  # if ($18 != $17) goto internalLoop;
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

printValues:
	addiu $2, $0, 1            # print value
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	lw $4, 0($12)              # load it from memory $12 + 0
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $12, $12, 4            # add 4 to memory (word address)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	bne $12, $13, printValues   # if ($12 != $13) goto printValues; (if it's not the end value)
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	jal bubblesort              # jump and link to bubblesort
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

end:
	addiu $2, $0, 1             # Set $2 to 1 once we're done.
	
#.data
#.word 3,5,1,2