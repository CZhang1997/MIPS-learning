#	Churong Zhang
#	Dr. Mazidi
#	CS 3340 Homework #1
#	09/02/2018
	.data
a:   		.word 1
b:		.word 2
c:   		.word 3
ans1: 		.word 1
ans2: 		.word 1
ans3: 		.word 1
name: 		.space 20
nameP: 		.asciiz "What is your name? "
integers: 	.asciiz "Please enter an integer between 1-100: "
results: 	.asciiz "Your answers are: "
	.text
main:	# ask for name
	li 	$v0, 4
	la	$a0, nameP
	syscall
	# store name
	li	$v0, 8
	la	$a0, name
	li	$a1, 20
	syscall
	
	# ask for integers 1
	li 	$v0, 4
	la	$a0, integers
	syscall
	
	li	$v0, 5
	syscall
	sw 	$v0, a
	# ask for integers 2
	li 	$v0, 4
	la	$a0, integers
	syscall
	li	$v0, 5
	syscall
	sw 	$v0, b
	# ask for integers 3
	li 	$v0, 4
	la	$a0, integers
	syscall
	li	$v0, 5
	syscall
	sw 	$v0, c
	# load word for a b c 
	lw	$t1, a
	lw	$t2, b
	lw 	$t3, c
	# get ans1  a + b + c 
	add 	$t0, $t1, $t2
	add	$t0, $t0, $t3
	sw	$t0, ans1
	# get ans2  c + b - a 
	add	$t0, $t3, $t2
	sub	$t0, $t0, $t1
	sw	$t0, ans2
	# get ans3 (a + 2) + (b - 5) - (c – 1) 
	addi	$t1, $t1, 2 # add 2 to a
	subi	$t2, $t2, 5 # sub 5 from b
	subi	$t3, $t3, 1 # sub 1 from c
	# add a, b minus c
	add 	$t0, $t1, $t2
	sub 	$t0, $t0, $t3
	sw	$t0, ans3
	# print user name
	li 	$v0, 4
	la	$a0, name
	syscall
	# print the results message
	li	$v0, 4
	la	$a0, results
	syscall
	# print answer 1
	li 	$v0, 1
	lw	$a0, ans1
	syscall
	# print a space
	li	$v0, 11
	li	$a0, ' '
	syscall
	# print answer 2
	li 	$v0, 1
	lw	$a0, ans2
	syscall
	# print a space
	li	$v0, 11
	li	$a0, ' '
	syscall
	# print answer 3
	li 	$v0, 1
	lw	$a0, ans3
	syscall
	
	# end the program
	li 	$v0, 10
	syscall
	
	
#	What is your name? Jack
#	Please enter an integer between 1-100: 12
#	Please enter an integer between 1-100: 6
#	Please enter an integer between 1-100: 24
#	Jack
#	Your answers are: 42 18	-8	
#	-- program is finished running --
	
#	What is your name? Churong
#	Please enter an integer between 1-100: 18
#	Please enter an integer between 1-100: 28
#	Please enter an integer between 1-100: 35
#	Churong
#	Your answers are: 81 45	 9	S
#	-- program is finished running --
	
	
