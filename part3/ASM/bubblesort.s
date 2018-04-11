# Bubble Sort 
# Joel16

# Some references:
# $9 - $12 = $t1 - $t4
# $19 - $20 = $s3 - $s4
# $31 = $ra

.text
.globl main

main:
# Initial values
addi $9, $0, -5 # 1
addi $10, $0, 4  # 2
addi $11, $0, 0  # 3
addi $12, $0, 1  # 4

# Should sort to -5, 0, 1, 4

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

# First check
slt $20, $9, $10 # if ($9 < $10) $20 = 1 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, firstcheck # branch to firstcheck if $9 < $10

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_1_2

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

firstcheck:
addi $20, $0, 0 # reset

# Second check
slt $20, $10, $11 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, secondcheck 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_2_3

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

secondcheck:
addi $20, $0, 0 # reset

# Third check
slt $20, $11, $12 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, secondcheck 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_3_4

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

thirdcheck:
addi $20, $0, 0 # reset

# First check
slt $20, $9, $10 # if ($9 < $10) $20 = 1 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, firstcheck_2 # branch to firstcheck_2 if $9 < $10

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_1_2

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

firstcheck_2:
addi $20, $0, 0 # reset

# Second check
slt $20, $10, $11 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, secondcheck_2 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_2_3

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

secondcheck_2:
addi $20, $0, 0 # reset

# First check
slt $20, $9, $10 # if ($9 < $10) $20 = 1 

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

bne $20, $0, firstcheck_2 # branch to firstcheck_2 if $9 < $10

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jal swap_1_2

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

firstcheck_3:
addi $20, $0, 0 # reset

j done

# Swap elements 1 and 2
swap_1_2:
add $19, $10, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $10, $9, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $9, $19, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jr $31

# Swap elements 2 and 3
swap_2_3:
add $19, $11, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $11, $10, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $10, $19, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jr $31

# Swap elements 3 and 4
swap_3_4:
add $19, $12, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $12, $11, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

add $11, $19, $0

# nop
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0
addi $0, $0, 0

jr $31


# no ops
done:
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
add $0, $0, $0
