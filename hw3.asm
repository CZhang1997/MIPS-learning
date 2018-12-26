#	Churong Zhang
#	Dr. Mazidi
#	CS 3340 Homework #3
#	10/07/2018

.data
nameP: 		.asciiz "What is your name? "
heightP:	.asciiz "Please enter your height in inches: "
weightP:	.asciiz "Now enter your weight in pounds (round to whole number): "
name:		.space 25
height:		.word 0
weight:		.word 0
bmi:		.double 0.0
under:		.float 18.5
underP:		.asciiz "This is considered underweight. \n"
normal:		.float 25.0
normalP: 	.asciiz "This is a normal weight. \n"
over:		.float 30.0
overP:		.asciiz "This is considered overweight. \n"
obese:		.asciiz "This is considered obese. \n"
bmiP:		.asciiz ", your bmi is: "

.text
main:
	li	$v0, 4
	la	$a0, nameP # ask for name
	syscall
	
	li	$v0, 8
	la	$a0, name # store name
	li	$a1, 25
	syscall
	
	#ask for height
	li	$v0, 4	
	la	$a0, heightP
	syscall
	#store height as int
	li	$v0, 5
	syscall
	sw	$v0, height
	
	#ask for weight
	li	$v0, 4
	la	$a0, weightP
	syscall
	#store weight as int
	li	$v0, 5
	syscall
	sw	$v0, weight
	
	lw	$t1, height
	lw	$t2, weight
	li	$t3, 703
	# weight * 703
	mult	$t2, $t3
	mflo	$t2
	sw	$t2, weight
	# height * height
	mult	$t1, $t1
	mflo	$t1
	sw	$t1, height

	# weight*703($f2) divide by height^2($f1)
	lwc1	$f2, weight
	lwc1	$f1, height
	div.s	$f0,  $f2, $f1
	swc1	$f0, bmi
	
	# print user name
#	li 	$v0, 4
#	la	$a0, name
#	syscall
	
	# print user name
	la	$t1, name
printName:
	lbu	$a0, 0($t1)
	beq	$a0, '\n', doneName
	li	$v0, 11
	syscall
	addi	$t1, $t1, 1
	j	printName
	
doneName:	
	# print ", your bmi is: "
	li	$v0, 4
	la	$a0, bmiP
	syscall
	# print bmi
	li	$v0, 2
	lwc1	$f12,bmi
	syscall
	# print a new line
	li	$v0, 11
	li	$a0, '\n'
	syscall
	
	# compare if bmi is less than 18.5
	lwc1	$f3, under
	c.lt.s	$f0, $f3
	bc1t	underWeight
	
	# compare if bmi is less than 25
	lwc1	$f3, normal
	c.lt.s	$f0, $f3
	bc1t	normalWeight
	
	# compare if bmi is less than 30
	lwc1	$f3, over
	c.lt.s	$f0, $f3
	bc1t	overWeight
	# else if bmi greater than or equal to 30
	li 	$v0, 4
	la	$a0, obese
	syscall
	j	exit
	# jump to here if bmi is less than 18.5
underWeight:
	li 	$v0, 4
	la	$a0, underP
	syscall
	j 	exit
	# jump to here if bmi is less than 25
normalWeight:
	li 	$v0, 4
	la	$a0, normalP
	syscall
	j 	exit
	# jump to here if bmi is less than 30
overWeight:
	li 	$v0, 4
	la	$a0, underP
	syscall
	j 	exit

exit:	# exit the program
	li	$v0, 10
	syscall
	
########Sample input and output	#############

#	What is your name? Jack Smit
#	Please enter your height in inches: 70
#	Now enter your weight in pounds (round to whole number): 150
#	Jack Smit, your bmi is: 21.520409
#	This is a normal weight. 
#
#	-- program is finished running --
#	What is your name? your name
#	Please enter your height in inches: 66
#	Now enter your weight in pounds (round to whole number): 160
#	your name, your bmi is: 25.821856
#	This is considered underweight. 
#
#	-- program is finished running --
	

