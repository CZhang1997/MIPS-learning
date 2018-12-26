#	Churong Zhang
#	Dr. Mazidi
#	CS 3340 Homework #2
#	09/15/2018

	.data

text: 		.space 50
input: 		.asciiz "Enter some text: "
output1:	.asciiz	" words "
output2:	.asciiz " charaters"
bye: 		.asciiz "Bye, "
thank:		.asciiz "thank you for playing!"
spaces:		.word	0
characters:	.word	0

	.text
main:	# show input dialog
	li	$v0, 54		# vo code 
	la	$a0, input	# message to display to user
	la	$a1, text	# buffer store in a1
	li	$a2, 50		#max space provide
	syscall
	# 	load text(argument) into a0
	beq 	$a1, -2, exit	# a1 is -2 if user click cancel
	beq	$a1, -3, exit	# a1 is -3 if user click ok but no input data
	la 	$a1, text	# store data from a1 to text
	jal	count		# call funtion count

	# 	move the return value to spaces and characters
	sw	$v1, spaces	# move number of spaces + 1 to spaces
	sw	$v0, characters	# move number of characters to characters
	
	# 	Display the text
	li 	$v0, 4		# v0 code is 4 for displaying string
	la	$a0, text	# a0 contain the data to print
	syscall
	
	# 	Display the words and characters count
	li	$v0, 1		# v0 cide is 1 for printing an integer
	lw	$a0, spaces	# a0 data to print
	syscall
	li	$v0, 4		# v0 code is 4 for displaying string
	la	$a0, output1	# a0 contain the data to print
	syscall
	li	$v0, 1		# v0 cide is 1 for printing an integer
	lw	$a0, characters	# a0 data to print
	syscall
	li	$v0, 4		# v0 code is 4 for displaying string
	la	$a0, output2	# a0 contain the data to print
	syscall	
	li	$v0, 11		# v0 code is 11 for displaying a character
	li	$a0, '\n'	# a0 data to print
	syscall
	
	j main			# loop again
	
exit:	
	li 	$v0, 59		# show message dialogstring v0 is 59
	la	$a0, bye	# a0 first string 
	la	$a1, thank	# a1 follow by a0
	syscall
	# end the program
	li 	$v0, 10		# end program
	syscall
	
	
count:
	# start a funtion
	# save s1, s2, s3 to the stack
	addi	$sp, $sp, -12		# push 3 items to stack
	sw	$s3, 8($sp)		# store s3 to the stack
	sw	$s2, 4($sp)		# store s2 to the stack
	sw	$s1, 0($sp)		# store s1 to the stack
	# funtion body
	add	$s3, $zero, 1		# space number counter
	add	$s2, $zero, -1		# characters counter
	add	$s1, $zero, $zero 	# index position counter
	
loop:	
	add	$t1, $s1, $a1 		# put the s1 position address as the as the first character on t1
	lbu	$t2, 0($t1)		# put the charactor on t2
	addi	$s1, $s1, 1		# increase index position by 1
	
	beq	$t2, $zero, end		# check if t2 is equal to zero(end of string mark), if true, go to end label
	addi	$s2, $s2, 1		# increase s2 by 1 for each character it check
	beq	$t2, ' ', space		# check if the character is space, go to space label if is true
	j 	loop			# loop again
space:
	addi 	$s3, $s3, 1		# increase space counter by 1
	j 	loop			# go back to loop
	# end of a funtion
end:	
	add	$v0, $zero, $s2 	# move charaters number to v0
	add	$v1, $zero, $s3 	# move space number to v1
	lw	$s1, 0($sp)		# restore s1 from stack
	lw	$s2, 4($sp)		# restore s2 from stack
	lw	$s3, 8($sp)		# restore s3 from stack
	addi	$sp, $sp, 12		# pop 3 items from stack
	jr	$ra			# go back to where function was called
	
	
