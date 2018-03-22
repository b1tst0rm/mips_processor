# Copyright 2002 Manu Datta (gmail.com ID Manu dot Datta)
# All rights reserved
	
.data
#msg1: .asciiz "\nEnter integer values followed by return (-1 terminates input): \n"
msg2: .asciiz ","
msg5: .asciiz "\n"
.text 				
		
.globl main
main:
	addiu $s0, $gp, 0           # get the intial point to save array 
	addi $t0, $0, 4             # $t0 = 4
	add $t1, $0, $0             # initializing...
	add $t2, $0, $0             # initializing...		 
	add $t3, $0, $0             # initializing...		 
	add $t6, $0, $0             # initializing...  
	add $t4, $0, $0             # initializing...
	sub $t7, $0, 1              # terminate at -1 (-1 should be the last element of the array)        
	#addiu $v0, $0, 5            # sycall for enter value string
	#la $a0, msg1                # sycall for enter value string
	#syscall                     # sycall for enter value string
	add $s1, $s0, $0            # copy the pointer to array in $s1

getValues:     
	addiu $v0, $0, 5            # get input value in v0 
	syscall                     # syscall 
	beq $v0, $t7, bubblesort    # Once we find -1 (end of array), branch to bubblesort
	sw $v0, 0($s1)              # Store the value at the mem location pointed by $s1 + 0
	addi $s1, $s1, 4            # Move the $s1 pointer by 4 - Word addressing (i++)
	add $t5, $s1, $0            # $t5 stores the end value
	j getValues                 # keep looping until we get -1

bubblesort:
	add $t4, $s0, $0            # Put $s0, in $t4
	addi $t6, $t6, 4            # Add 4 to $t6 (Word addressing)
	#s1-4 -> s0
	sub $s1, $s1, $t0           # $s1 = s1 - 4
	beq $s1, $s0, endSort       # if s1 == s0, we have sorted everything
	#s0 -> s1
	add $s2, $s0, $0            # $s2 = $s0

internalLoop:
	lw $t1, 0($s2)              # first element at mem location $s2 + 0
	lw $t2, 4($s2)              # second element at mem location $s2 + 4
	slt $t3, $t2, $t1           # if ($t2 < $t1) -> $t3 = 1
	beq $t3, $0, next           # if ($t3 == 0) goto next;
	sw $t2, 0($s2)              # store first element in t2
	sw $t1, 4($s2)              # store second element in t1

next:
	addi $s2, $s2, 4            # $s2 = $s2 + 4
	bne $s2, $s1, internalLoop  # if ($s2 != $s1) goto internalLoop;
	addiu $v0, $0, 4            # system call to put the string
	la $a0, msg5                # print string
	syscall                     # syscall
	addiu $v0, $0, 4            # system call to put the string
	la $a0, msg5                # print string
	syscall                     # syscall

printValues:
	addiu $v0, $0, 1            # print value
	lw $a0, 0($t4)              # load it from memory $t4 + 0
	syscall                     # syscall
	addiu $v0, $0, 4            # system call to string "," for separating values
	la $a0, msg2                # print string
	syscall                     # syscall
	addi $t4, $t4, 4            # add 4 to memory (word address)
	bne $t4, $t5, printValues   # if ($t4 != $t5) goto printValues; (if it's not the end value)
	jal bubblesort              # jump and link bubblesort

endSort:
	addiu $v0, $0, 5            #
	syscall                     # syscall
	