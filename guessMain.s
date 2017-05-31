# Kin Man (Kelvin) Lui
# Professor Max
# CS270
# 3/15/2017
# Assignment 5 - Guessing Game 
	.data 
max: .word 9 # max value - change it here :)
intro:	    	.asciiz "Please enter a guess of hexadecimal value between 0x1 and 0x" 
asksForNum: 	.asciiz "\nEnter your guess (q  to quit): " 
exception:  	.asciiz "The number you entered is out of range.\nPlease enter it again."  
yourGuessIsIncorrect: 	.asciiz "Sorry, your guess is incorrect.\nPlease try again." 
congratuation:   .asciiz "Congratuation ! Your guess is correct." 
lowGuess: 	.asciiz "The guess is too low, please try again."
highGuess: 	.asciiz "The guess is too high, please try again." 
boringGame: 	.asciiz "Please come back anytime !" 
welcome: 	.asciiz "Welcome to the guessing game !" 	
	.text
	.globl main 
main: 
	addiu $sp, $sp, -36	# allocates 36 bytes on stack (8 bytes for the buffer) 
	sw $ra, 32($sp) 	# homes $ra 
	sw $s0, 24($sp)		# stores $s0
	sw $s1, 28($sp)		# stores $s1 
	sw $a0, 36($sp) 	# homes $a0 
	sw $a1, 40($sp) 	# homes $a1
	sw $a2, 44($sp) 	# homes $a2  
	li $a1, 1 		# loads 1 before calling Me
	la $a0, welcome 	# loads welcome message
	jal MessageDialog	# calls MessageDialog to display welcome message 
	la $a1, 16($sp) 	# loads address of the string buffer (stores max)
	lw $a0, max 		# loads the integer value being converted into string 
	jal itoax 		# converts the interger into string, and puts into buffer 
	la $a0, intro  		# loads the intro (part1) 
	la $a1, 16($sp) 	# loads the max value from buffer (part2) 
	la $a2, asksForNum	# loads the question (part3) 
	jal createQuestion	# combines part1, part2 and part3, then returns the pointer for the combined string  
	move $s0, $v0 		# move the *question into $s0 to temporarily store the pointer
	jal initRandom		# calls initRandom() to initialize the random number generator 
	li $a0, 1 		# loads the min value into $a0 to call randomIntRange(min, max)
	lw $a1, max  		# loads the max value into $a1 to call randomIntRange(min, max) 
	jal randomIntRange 	# calls randomIntRange(1, max) to get a random number 
	move $s1, $v0 		# stores the random number into $s1 for future use  
loop:  
	move $a0, $s0 		# move the *question into $a0 to call getGuess 
	li $a1, 1 		# loads 1 into $a1 to call getGuess, which is the min 
	lw $a2, max 		# loads the max value into $a2 to call getGuess  
	jal getGuess 		# calls getGuess 
	li $t1, -1
	beq $v0, $t1, thisGameIsBoring # if user's input is -1, then ends the game 
	beq $v0, $s1, congrats		# if(guess == randomNumber) congratTheUser(); 
	bgt $v0, $s1, theGuessIsTooHigh	# if(guess > randomNumber) tellsUserTheGuessIsTooHigh();
	blt $v0, $s1, theGuessIsTooLow	# if(guess < randomNumber) tellsUserTheGuessIsTooLow(); 
guessMainEnds:
	lw $a0, 36($sp) 	# restores $a0 
	lw $a1, 40($sp) 	# restores $a1 
	lw $a2, 44($sp) 	# restores $a2 
	lw $ra, 32($sp) 	# restores $ra 
	lw $s0, 24($sp)		# restores $s0
	lw $s1, 28($sp)		# restores $s1 
	addiu $sp, $sp, 36	# deallocates the stack
	jr $ra			# the program ends 
thisGameIsBoring: 
	li $a1, 1		
	la $a0, boringGame 
	jal MessageDialog	# display farewell message 
	j guessMainEnds		# ends the program
theGuessIsTooHigh: 		# tells the user that the guess is too high
	li $a1, 1 		
	la $a0, highGuess
	jal MessageDialog 
	j loop
theGuessIsTooLow:		# tells the user that the guess is too low 
	li $a1, 1
	la $a0, lowGuess
	jal MessageDialog
	j loop
congrats: 		
	li $a1, 1 	      # loads 1 into $a1(type) before calling MessageDialog
	la $a0, congratuation # loads the message to be display before calling MessageDialog
	jal MessageDialog
	j guessMainEnds 			

# int getGuess(char *question, int min, int max) function starts here 	  	  
getGuess: 
	addiu $sp, $sp, -40 	# allocates 40 bytes on stack (8 bytes for buffer for the string and 8 for buffer for the converted int ) 
	sw $ra, 36($sp) 	# homes $ra 
	sw $a0, 40($sp) 	# homes $a0	
	sw $a1, 44($sp) 	# homes $a1 
	sw $a2, 48($sp)		# homes $a2 
	sw $s0, 32($sp) 	# stores the integer guess  
getGuessLoop:
	la $a1, 16($sp) 	# the guess will be stored into 16($sp), which is a buffer for the string
	li $a2, 8		# max characters can be entered is 8
	jal InputDialogString 	# calls InputDialogInt(const char *question, char *buf, int max) 
	li $t1, -1		# loads -1 into to test if the result is equal to -1
	beq $v0, $t1, return 	# if (result == -1) goto thisGameIsBoring; 
	la $a0, 24($sp) 	# loads the address of the buffer(string) to be converted
	la $a1, 16($sp) 	# loads the address of the buffer(int) to be put into after convertion 
	jal axtoi 		# calls axtoi to convert the guess(string) into guess(int) 
	lw $s0, 24($sp) 	# loads the integer guess from the buffer 
	lw $a1, 44($sp)		# loads back the value of min into $a1 
	lw $a2, 48($sp)		# loads back the value of max into $a2
	blt $s0, $a1, throwException # if(guess < min) throw OutOfRangeException;
	bgt $s0, $a2, throwException # if(guess > max) throw OutOfRangeException; 
	move $v0, $s0		# returns the result  
return:  
	lw $ra, 36($sp)		# restores $ra
	lw $a0, 40($sp) 	# restores $a0
	lw $a1, 44($sp) 	# restores $a1 
	lw $a2, 48($sp) 	# restores $a2 
	lw $s0, 32($sp)
	addiu $sp, $sp, 40	# deallocates the stack
	jr $ra 			# returns
throwException:
	la $a0, exception	# loads the address storing the string for exception
	li $a1, 1 		# loads 1 into $a1 
	jal MessageDialog	# calls MessageDialog to output the error message 
	lw $a0, 40($sp)		# loads back $a0 before going back to the loop
	lw $s0, 32($sp)
	j getGuessLoop 		# goes back to the beginning of the function to get the guess again 
# getGuess function ends here 
 
