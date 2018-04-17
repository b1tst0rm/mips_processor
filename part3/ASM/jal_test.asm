jal_test:
	addi $2, $0, 1                  # $2 = 1 if bne fails
	jal simpleFunc                  # Jump and link to simpleFunc(tion), after this $2 will be set to 2. // PC = 0x000000ac
		
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	addi $3, $0, 3                  # $2 = 1 if bne fails

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	
	j exit              # After our JAL, proceed to loadAndStoreTest

simpleFunc:
	addi $2, $0, 2                  # $2 = 2

	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0

	jr $31                          # 0x000000ac + 4 = 0x000000b0

exit:
	
	# nop
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
