
.data
ok: .asciiz "data is ok" # if checkParity return 0
bad: .asciiz "data has been corrupted" # if checkParity return 1

fout: .asciiz "input.txt"
size: .word 1
buffer: .space 100
buffer2: .space 100

			#"The quick brown fox jumped over the lazy river." length 47
.text
###############################################################
  # Open (for reading) a file that does exist
  li   $v0, 13       # system call for open file
  la   $a0, fout     # input file name
  li   $a1, 0        # Open for writing (flags are 0: read, 1: write)
  li   $a2, 0        # mode is ignored
  syscall            # open a file (file descriptor returned in $v0)
  move $s6, $v0      # save the file descriptor 
  ###############################################################
  #Read file just opened
  li   $v0, 14       # system call for read from the file
  move $a0, $s6      # file descriptor 
  la   $a1, buffer   # address of buffer store which from read
  li   $a2, 47       # hardcoded buffer length
  syscall            # Read to file
  sw	$v0, size	# store the size of the buffer 1 from input
  ###############################################################
  #### check if read the correct text
  #li	$v0, 4
  #la	$a0, buffer
 # syscall
  ####################################
  # Close the file 
  li   $v0, 16       # system call for close file
  move $a0, $s6      # file descriptor to close
  syscall            # close file
  ###############################################################
  
  la	$a0, buffer # $s1 contain the text
  li	$v0, 4
  syscall
  
  li	$a0, '\n'
  li	$v0, 11
  syscall
  
  la	$a0, buffer	# input 1, the address of the string to check
  lw	$a1, size	# input 2 the size of the string
  la	$a3, buffer2	# the string address to store the text + parity
  jal	setParity	# nothing return but change buffer 2 (input 3)
  
  la	$a0, buffer2 # $s1 contain the text
  li	$v0, 4
  syscall
  li	$a0, '\n'
  li	$v0, 11
  syscall
  
  la	$a0, buffer2		# input 1 the address of buffer that need to check
  lw	$a1, size		# input 2 the size of the string
  jal	checkParity		# $v0 return 0 if data is ok else return 1 for corrupted
  beq	$v0, $zero, good	# check if parity return 1 or zero
  la	$a0, bad	# put the bad sentence address to $a0 to print
  j	print	# jump over good to print to print the sentence
good:
	la	$a0, ok	# put the ok sentence address to $a0 to print
print:
  li	$v0, 4	# 4 for print a string
  syscall
  
	# exit
	li $v0, 10	# 10 for end program
	syscall
checkParity:
# start a funtion
	# $a0 is the address of the buffer one
	# $a1 is the size of the text
	# save s1, s2, s3 to the stack
	addi	$sp, $sp, -20		# push 3 items to stack
	sw	$s6, 16($sp)		# store s6 to the stack for byte address
	sw	$s5, 12($sp)		# store s5 to the stack for a byte content
	
	sw	$s3, 8($sp)		# store s3 to the stack
	sw	$s2, 4($sp)		# store s2 to the stack
	sw	$s1, 0($sp)		# store s1 to the stack
	
	# funtion body
	add	$s3, $zero, $zero	# index number counter
	add	$s2, $zero, $a1	# characters counter
	move	$s1, $a0		# address of the sentence
	#add	$t1, $zero, $zero # $t1 as the counter for loop
  loopC:
 	add	$s6, $s1, $s3	# get the address of each byte and store in $s6
 	lbu	$s5, 0($s6)	# store the byte into $s5
 	
 	addi	$sp, $sp, -8	# put $a0 to the stack
 	sw	$a0, 0($sp)	# store $a0 before call the function checkByte
 	sw	$ra, 4($sp)	# store the return address
 	move	$a0, $s5	# move the byte form $t1 to $a0
 	jal	checkByte	# check even or odd number of one
	
	lw	$a0, 0($sp)	# put $a0 back from the stack after checkByte finish
 	lw	$ra, 4($sp)	# put the previous return address back
 	addi	$sp, $sp, 8	# take $a0 away from the stack
 	
 	beq	$v0, $zero, zero	# jump to zer if checkByte return 0
 	and	$s6, $s5, 128	# change the 7th bit when checkByte return 1
 	beq	$s6, $zero, corrupt
 	j	endLoopC
 zero:
  	and	$s6, $s5, 128
  	bne	$s6, $zero,  corrupt
endLoopC:
	
 	addi	$s3, $s3, 1	# increase the char counter
 	bne	$s3, $s2, loopC 	
 	
 	#function end
 	li	$v0, 0
 	j	endCheck
corrupt:
	li	$v0, 1
	#j	endCheck
endCheck:
  	lw	$s1, 0($sp)		# restore s1 from stack
	lw	$s2, 4($sp)		# restore s2 from stack
	lw	$s3, 8($sp)		# restore s3 from stack
	lw	$s5, 12($sp)		# restore s2 from stack
	lw	$s6, 16($sp)		# restore s3 from stack
	addi	$sp, $sp, 20		# pop 3 items from stack
	
	jr	$ra			# go back to where function was called
	


setParity:
	# start a funtion
	# $a0 is the address of the buffer one
	# $a1 is the size of the text
	# $a3 is the address of buffer two
	# save s1, s2, s3 to the stack
	addi	$sp, $sp, -20		# push 3 items to stack
	sw	$s6, 16($sp)		# store s6 to the stack for byte address
	sw	$s5, 12($sp)		# store s5 to the stack for a byte content
	
	sw	$s3, 8($sp)		# store s3 to the stack
	sw	$s2, 4($sp)		# store s2 to the stack
	sw	$s1, 0($sp)		# store s1 to the stack
	
	# funtion body
	add	$s3, $zero, $zero	# index number counter
	add	$s2, $zero, $a1		# characters counter
	move	$s1, $a0		# address of the sentence
	#add	$t1, $zero, $zero # $t1 as the counter for loop
  loop:
 	add	$s6, $s1, $s3	# get the address of each byte and store in $s6
 	lbu	$s5, 0($s6)	# store the byte into $s5
 	
 	addi	$sp, $sp, -8	# put $a0 to the stack
 	sw	$a0, 0($sp)	# store $a0 before call the function checkByte
 	sw	$ra, 4($sp)	# store the return address
 	move	$a0, $s5	# move the byte form $t1 to $a0
 	jal	checkByte	# check even or odd number of one

 	add	$s6, $a3, $s3	# change the byte address for buffer two

 	beq	$v0, $zero, zer	# jump to zer if checkByte return 0
 	or	$s5, 128	# change the 7th bit when checkByte return 1
 zer:
  	sb	$s5, ($s6)	# store the byte to buffer two
 	addi	$s3, $s3, 1	# increase the char counter
 	lw	$a0, 0($sp)	# put $a0 back from the stack after checkByte finish
 	lw	$ra, 4($sp)	# put the previous return address back
 	addi	$sp, $sp, 8	# take $a0 away from the stack
 	
 	bne	$s3, $s2, loop 	
 	
 	#function end
 	move	$v0, $a3
 	lw	$s1, 0($sp)		# restore s1 from stack
	lw	$s2, 4($sp)		# restore s2 from stack
	lw	$s3, 8($sp)		# restore s3 from stack
	lw	$s5, 12($sp)		# restore s2 from stack
	lw	$s6, 16($sp)		# restore s3 from stack
	addi	$sp, $sp, 20		# pop 3 items from stack
	
	jr	$ra			# go back to where function was called
	
checkByte:
	# start a funtion 
	# input $a0 the byte to check
	# save s1, s2, s3 to the stack
	addi	$sp, $sp, -12		# push 3 items to stack
	sw	$s1, 0($sp)		# store s1 to the stack
	sw	$s2, 4($sp)		# store s2 to the stack
	sw	$s3, 8($sp)		# store s3 to the stack
	
	add	$s1, $zero, $zero	# bit number counter 0 to 6
	add	$s2, $zero, $zero	# numbers of bit that has 1 
	addi	$s3, $zero, 1		# check each bit that has one

loopB:
	and	$t6, $a0, $s3		# compare the bit between $a0 and $s3(change from right to left)
	bne	$t6, $zero, one		# increase the bit that has one if $t6 is not zero
backOne:	
	addi	$s1, $s1, 1		# increase the number of bit that is finish
	sll	$s3, $s3, 1		# shift the one bit to the left
	beq	$s1, 7, funcEnd		# check we finish compare all 7 bits(0-6)
	j	loopB			# loop again if not finish
one:	# found one
	addi	$s2, $s2, 1		# increase the number of bit that has one
	j	backOne			# go back to the loop and increase $s1, $s3

funcEnd:	
	addi	$t7, $zero, 2		# put 2 into $t7
	divu	$s2, $t7		# divide $s2(the number of one bits) by $t7(2)
	mfhi	$t7			# store the reminder to $t7
	
	#beq	$t7, $zero, leave	# check if the reminder is zero, which mean $s2(the number of one bits)  is a even number
	#or	$a0, $a0, $s3		# if $s2(the number of one bits)  is a odd number, then change the 7th bit to one
#leave:	
	lw	$s1, 0($sp)		# restore s1 from the stack
	lw	$s2, 4($sp)		# restore s2 from the stack
	lw	$s3, 8($sp)		# restore s3 from the stack
	addi	$sp, $sp, 12		# fix the stack pointer
	move	$v0, $t7		# move the address of the byte to $v0
	jr	$ra			# go back to where the function was call
