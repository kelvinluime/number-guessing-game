# Kin Man (Kelvin) Lui
# Professor Max
# CS270
# 3/15/2017
# Assignment 5 - Guessing Game 
#
#
# createQuestion.s
# implements a function to assemble a question string from three parts
#
#   char * createQuestion(char * first, char * second, char * third);
#
# allocates space for a new string on the heap large enough to hold the 
# question, then fills the space by copying first, second and third, creating
# the concatenated question.
#
#  char * createQuestion( char * first, char * second, char * third) {
    .text
    .globl createQuestion 
createQuestion:
    addiu  $sp,$sp,-40
# home args
    sw  $a0,40($sp)
    sw  $a1,44($sp)
    sw  $a2,48($sp)
    sw  $ra,36($sp)
#  int len1, len2, len3, len ;
#  char * question;
    # question - $s0
    # len1 - $s1
    # len2 - $s2
    # len3 - $s3
    # len - $s4
    sw  $s4,32($sp)
    sw  $s3,28($sp)
    sw  $s2,24($sp)
    sw  $s1,20($sp)
    sw  $s0,16($sp)
#
#  TRANSLATE THE FOLLOWING C CODE TO MIPS ASSEMBLER:
#
#  len1 = strlen(first);
#  len2 = strlen(second);
#  len3 = strlen(third);
#  len = len1 + len2 + len3;
# 
#  question = malloc(len + 1);
#  strcpy(question,first);
#  strcpy(question+len1, second);
#  strcpy(question+len1+len2,third);
#
    jal strlen		# calls strlen(first)   		
    move $s1, $v0       # len1 = strlen(first) 
    move $a0, $a1	# moves second into $a0 to call strlen 
    jal strlen		# calls strlen(second) 
    move $s2, $v0	# len2 = strlen(second) 
    move $a0, $a2	# moves third into $a0 to call strlen
    jal strlen		# calls strlen(third) 
    move $s3, $v0	# len3 = strlen(third) 
    add $s4, $s1, $s2	# len = len1 + len2 
    add $s4, $s4, $s3	# len = len + len3 
    
    addi $a0, $s4, 1	# puts len + 1 into $a0 to call malloc 
    jal malloc		# calls malloc(len + 1) 
    move $s0, $v0	# question* = malloc(len + 1) 
    
    move $a0, $s0	# moves question* into $a0 to call strcpy 
    lw $a1, 40($sp)	# loads first into $a1 to call strcpy 
    jal strcpy		# calls strcpy 
    add $a0, $s0, $s1	# puts question* + len1 into $a0 to call strcpy 
    lw $a1, 44($sp) 	# loads second into $a1 to call strcpy 
    jal strcpy		# calls strcpy
    add $a0, $s1, $s2	# $a0 = len1 + len2 
    add $a0, $a0, $s0	# $a0 = $a0 + question* 
    lw $a1, 48($sp)	# loads third into $a1 to call strcpy 
    jal strcpy 
   
#  return(question);
    move $v0,$s0	# moves question* into $v0 to return 
    lw	$a0,40($sp)	
    lw 	$a1,44($sp) 
    lw	$a2,48($sp)  
    lw  $s4,32($sp)	# restores s-registers 
    lw  $s3,28($sp)
    lw  $s2,24($sp)
    lw  $s1,20($sp)
    lw  $s0,16($sp)
    lw  $ra,36($sp)	# restores $ra 
    addiu  $sp,$sp,40	# deallocates stack 
    jr  $ra		# returns 
# }
