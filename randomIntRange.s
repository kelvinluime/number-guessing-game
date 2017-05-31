# Kin Man (Kelvin) Lui
# Professor Max
# CS270
# 3/15/2017
# Assignment 5 - Guessing Game 	
	.text 
	.globl initRandom 
	
initRandom: 
	addiu $sp, $sp, -20	# allocates 16 bytes on stack
	sw $a0, 20($sp) 	# home registers 
	sw $a1, 24($sp)
	sw $a2, 28($sp)
	sw $a3, 28($sp)
	sw $ra, 16($sp)		# stores $ra 
	move $a0, $zero		# puts 0 into $a0 to call time 
	jal time		# gets time of day (seed) by calling time(0) 
	move $a0, $v0		# moves the seed into $a0 to call srandom 
	jal srandom		# Calls srandom to seed the random number generator 
	lw $ra, 16($sp) 	# restores $ra
	lw $a0, 20($sp)
	lw $a1, 24($sp)
	lw $a2, 28($sp)
	addiu $sp, $sp, 20 	# deallocates the stack
	jr $ra			# returns 

# int randomIntRange(int low, int high) {
# 	int num = random();				// gets random number from generator 
#	return convertIntoRange(num, low, high); 
# }	
	.globl randomIntRange	
randomIntRange:
	addiu $sp, $sp, -20 	# allocates 20 bytes on stack
	sw $ra, 16($sp) 	# stores $ra 
	sw $a0,	20($sp)		# homes $a0 
	sw $a1, 24($sp)		# homes $a1
	sw $a2, 28($sp)		# homes $a2 
	jal random 		# calls random to get random num
	move $a2, $v0 		# moves the random number into $a2 to call convertIntoRange 
	lw $a0, 20($sp)		# loads the value low into $a0 to call convertIntRange 
	lw $a1, 24($sp) 	# loads the value high into $a1 to call convertIntRange 
	jal convertIntoRange 	# calls the private method convertIntoRange(int num, int low, int high), which returns a random within the range [low, high] #	lw $ra, 16($sp)		# resotres $ra 
	lw $a0, 20($sp)		# restoress $a0 
	lw $a1, 24($sp)		# restores $a1 
	lw $a2, 28($sp) 	# restores $a2 
	lw $ra, 16($sp) 
	addiu $sp, $sp, 20	# deallocates 20 bytes on stack  
	jr $ra 			# returns 

# Java version of the private method convertIntoRange(int num, int low, int high) 
# private int convertIntoRange(int num, int low, int high) {  
#	if(num > high) { 
# 		num = num % high;
#		if(num < min)  
#			num = convertIntRange(num, low, high);	// makes sure the result num % high is above low
#	} else if(num < low) { 
#		num = num + low;
#		if(num > high)  
#			num = convertIntRange(num, low, high); 	// makes sure  the result num + low is below high 
#	} 
#	return num; 
# } 
# 
# //Here is the code after converting to ugly c code: 
# private int convertIntoRange(int num, int low, int high) { 
# 	if (num > high) goto modHigh; 
# 	if (num < low) goto addLow;  
# return: 
# 	return num; 
# modHigh:
# 	num = num % high; 
#	if(num < min) 
#		goto addLow; 
#	goto return; 
# addLow: 
#	num = num + low;
#	if(num > high) 
#		goto modHigh;  
# 	goto return; 
#
	
convertIntoRange: 
	addiu $sp, $sp, -20	# allocates 20 bytes on stack 
	sw $ra, 16($sp)		# home registers  
	sw $a0, 20($sp)
	sw $a1, 24($sp) 
	sw $a2, 28($sp)	
	move $a0, $a2 		# moves the num into $a0 before calling absolute 
	jal absolute
	lw $a0, 20($sp) 
	bgt $v0, $a1, modHigh 	# if(num > high) goto modHigh; 
	blt $v0, $a0, addLow	# if(num < low) goto addLow; 
returnCorrectInt: 
	lw $ra, 16($sp)		# restores registers from the stack
	lw $a0, 20($sp) 	
	lw $a1, 24($sp) 
	lw $a2, 28($sp)
	addiu $sp, $sp, 20	# deallocates 20 bytes 
	jr $ra			# return 
modHigh: 
	divu $v0, $a1 		# hi = num % high 
	mfhi $v0 		# num = num % high 
	blt $v0, $a0, addLow 	# if (num < low) goto addLow;  
	j returnCorrectInt		
addLow: 
	add $v0, $v0, $a1 	# num = num + low 
	bgt $v0, $a1, modHigh	# if(num > high) got modHigh;
	j returnCorrectInt	
######################		 
absolute: 
	addiu $sp, $sp, -20	# allocates 20 bytes for this function
	sw $ra, 16($sp)		# home registers 
	sw $a0, 20($sp) 
	bgt $a0, $zero, returnToConvert # if(num > 0) return num; 
	sub $a0, $zero, $a0		# if(num < 0) num = 0 - num; 
returnToConvert: 
	move $v0, $a0 		# moves $a0 to $v0 before return	
	lw $ra, 16($sp) 	# restores registers
	lw $a0, 20($sp) 
	addiu $sp, $sp, 20 	# deallocates 20 bytes from the stack	
	jr $ra 			# return 
# I realized that low is a constant, which is always 1, 
# so this fuction has some unnecessary code,
# but it does not affect the result 
	
	
