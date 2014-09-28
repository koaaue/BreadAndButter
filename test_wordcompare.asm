.data
UserOutput: .asciiz "Come Play The Lexathon Game of Death Muaha!!! " ###Random Line
butter: .align 2		# word to compare against
	.asciiz "butter"
buffer: .align 2		# word to read in from user	
	.space 12
newline:.align 2
	.asciiz "\n"
true:	.asciiz "Match"
false:	.asciiz "Doesn't Match"
.text

start:
li $v0, 8	
la $a0, buffer
li $a1, 10	# read 10 characters (9 including null)
syscall

###############################################################

###
# tested byte matching here
###
#li $v0 1
#la $t0, buffer
#addi $t0, $t0, 2
#lb $a0, 0($t0)
#syscall

#li $v0, 4
#la $a0, newline
#syscall

#li $v0 1
#la $t0, butter
#lb $a0, 0($t0)
#syscall

#li $v0, 4
#la $a0, newline
#syscall

###############################################################

###
#	$t0 has address to input/buffer
#	$t1 has address to static/butter
#	$t2 stores current character of input
#	$t3 stores current character of static
#	$t8 stores string for true/false (match/notmatch)
#	$t9 has loop counter
###
li $t9, 9	# 9 characters to scan through
la $t8, true	# init to true
la $t0, buffer	# load buffer string address in $t0
la $t1, butter	# load butter string address in $t1
loop:
	beqz $t9, end		# run through this for each char, I might be overshooting by 1
	lb $t2, 0($t0)		# store current letter of buffer
	lb $t3, 0($t1)		# store current letter of butter
	beqz $t3, nullfound	# when original word (butter) hits \0, go to nullfound to check state of user word
	bne $t2, $t3, nope	# if letters are not the same, false
	addi $t9, $t9, -1	# decrement loop counter
	add $t0, $t0, 1		# shift buffer char index by 1
	add $t1, $t1, 1		# shift butter char index by 1
	b loop
nope:
	la $t8, false		# difference was found
	b end
nullfound:
	beqz $t2, end		# if user word index is also \0, success
	bne $t2, 10, nope	# else if user word index isn't \n
end:
	li $v0, 4		# output if match was or wasn't found
	move $a0, $t8
	syscall
	
	la $a0, newline		# newline to console between runs
	syscall
	
	b start			# try more words
	
	#li $v0, 10		# this would have been exit call
	#syscall
