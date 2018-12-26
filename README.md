# MIPS-learning
learning how to use MIPS

# hw1
•	in the .data section: 
o	3 variables to hold input values: a, b, c
o	3 variables to hold output values (name them whatever you like)
o	a variable to hold the user’s name
o	3 variables for messages:
	A prompt for name
	A prompt for integers
	A message for results (similar to the sample run below)
•	in the .text section write instructions to:
o	prompt the user for their name and save it in memory
o	3 times: 
	prompt user for an integer between 1-100 
	read and store the integers in a, b, and c
	no input checking required 
o	calculate ans1 = a + b + c and store the result
o	calculate ans2 = c + b - a and store the result
o	calculate ans3 = (a + 2) + (b - 5) - (c – 1) and store the result
o	display the user name and message for results
o	display the 3 results but print a space character in between for readability

# hw2
1.	use the dialog syscall (#54) to input a string from the user
2.	call a function which counts the number of characters and number of words in the string and returns these in $v0 and $v1; store these in memory
3.	output (console) the string and counts to the user (see example below)
4.	repeat from 1 until the user enters a blank string or hits “cancel”
5.	additionally, use $s1 in your function so that you must save it on the stack at the top of your function and restore it before the function exits
6.	output a dialog message (syscall #59) to say goodbye before the program ends

# hw3
calculate the bmi

# hw4
•	create a plain text file with the sentence: The quick brown fox jumped over the lazy river. This file must be in the same folder from which you run MARS.
•	specify the name of your file in an asciiz string in the data section
•	use SYSCALLs to open the file, then read it into a buffer in data, then close the file; allocate space for another buffer to contain the text+parity
•	since the ASCII characters only use 7 bits (6-0), bit 7 is unused; we will use this bit to store parity
•	even parity bit: set bit 7 to 0 if the ascii code contains an even number of bits; otherwise set to 1
•	loop through the buffers:
o	read a byte from the first buffer into a register
o	set bit 7 for even parity 
o	write the byte to the second buffer
•	put the code that determines 1 or 0 for the parity bit in a function
•	then write another function to check the parity 
•	run the program once to check that you get the “ok” message if the data has not been corrupted
•	run the program again, set a breakpoint before you jump to the check function and manually corrupt the data as seen in the screen shot below; the first a “1010” was changed to 2 “0010” which changed the parity; now the program will print the “not ok” message
