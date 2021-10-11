##############################################################################
#
#  KURS: 1DT038 2018.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10					# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "Hunden, Katten, Glassen"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#				elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#				$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:  

DBG:							##### DEBUGG BREAKPOINT ######

    addi    $v0, $zero, 0       # Initialize Sum to zero.
	add		$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	#$v0 = Sum
	#$t0 = i
	#$a0 = array start address
	#$a1 = array.size()
	#$t3 = i*4 array iterator
	#$t4 = array(i)
	#$t5 = iterated array adress
loop:
	beq		$t0, $a1, end_for_all	# Done if i == N
	sll 	$t3, $t0, 2				# 4*i
	add 	$t5, $a0, $t3			# address = ARRAY + 4*i
	lw		$t4, 0($t5)				# n = A[i]
	add 	$v0, $v0, $t4			# Sum = Sum + n
	addi 	$t0, $t0, 1				# i++ 
	j loop							# next element

end_for_all:
	
	jr	$ra							# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####
	#$v0 = length
	#$a0 = string address
	#$t0 = string address with offset
	#$t1 = char at address
	add		$v0, $zero, $zero	# Initialize string index i to zero.
loop_string:
	add		$t0, $v0, $a0		# string adress - offset in bytes
	lb		$t1, 0($t0)			# character
	beq		$t1, $zero, end_string_length
	add		$v0, $v0, 1			# i++
	j loop_string				# next character (byte)
end_string_length:	
	jr		$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	sw		$ra, -4($sp)			# PUSH return address to caller
	sw		$s0, -8($sp)			# Save $s0 as callee
	sw		$s1, -12($sp)			# Save $s1 as callee	
	sw		$s2, -16($sp)			# Save $s2 as callee	
	sw		$s3, -20($sp)			# Save $s3 as callee	
	sw		$a1, -24($sp)			# Save $a1 as callee
	addi	$sp, $sp, -24		
	
	#### Write your solution here ####
	#$s0 = char
	#$s1 = i
	#$s2 = $a0 = string address
	#$s3 = $a1 = function address
	
	add		$s1, $zero, $zero	# Initialize string index i to zero.
	add		$s2, $a0, $zero		# save $a0
	add		$s3, $a1, $zero		# save $a1
loop_char:
	lb		$s0, 0($s2)			# character
	beq		$s0, $zero, end_char
	add		$a0, $zero, $s2
	jalr 	$s3					#subfunction call
	add		$s1, $s1, 1			# i++
	addi		$s2, $s2, 1			# string adress++
	j loop_char					# next character (byte)
end_char:		
	
	addi	$sp, $sp, 24	
	lw		$ra, -4($sp)			# PUSH return address to caller
	lw		$s0, -8($sp)			# return $s0 as callee
	lw		$s1, -12($sp)			# return $s1 as callee	
	lw		$s2, -16($sp)			# return $s2 as callee	
	lw		$s3, -20($sp)			# return $s3 as callee	
	lw		$a1, -24($sp)			# return $a1 as callee

	jr		$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####
	## Ascii('a') = 97
	#Ascii('z') = 122
	#Ascii('A') = 65
	#Ascii('Z') = 90
	#ONLY WORKS WITH STANDARD ASCII CHARACTERS aA TO zZ
	lb		$t0, 0($a0)			# character
	addi 	$t1, $t0, -90 		# ascii 90 is cutoff point from upper to lowercase
	

	bltz 	$t1, end_upper 		# om $t0 - 90 < 0 char is upper
	addi 	$t0, $t0, -32		#-32 is difference between upper and lower
	sb 		$t0, 0($a0)			#save modified char
	end_upper:
	jr		$ra

##############################################################################
#
#  DESCRIPTION: Reverses the input string.
#	
#        INPUT: $a0 - address of a character
#				$a1 -
#				$a2	- string length
#				$a3 - 
##############################################################################		
reverse:
	

	add $t0, $a2, $a0 	# end char address
	add $t1, $zero, $a0 # start char address
	
	sub $t4, $t1, $t0	# start - end

	bgez $t4, end_reverse 
	lb $t2, 0($t1) # load left char
	lb $t3, 0($t0) # load right char
	sb $t3, 0($t1) # save right -> left
	sb $t2, 0($t0) # vice versa

	#$a0 iterates in caller
	addi $a2, $a2, -2 #-2 because $a0 iterates +1

	end_reverse:
	jr $ra

##############################################################################
#
#  DESCRIPTION: Alternate Transforming lower case character [a-z] to 
#  upper case [A-Z]. AaAaAaAa
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
camel:

	#### Write your solution here ####
	## Ascii('a') = 97
	#Ascii('z') = 122
	#Ascii('A') = 65
	#Ascii('Z') = 90
	#ONLY WORKS WITH STANDARD ASCII CHARACTERS aA TO zZ
	
	lb		$t0, 0($a0)			# character
	addi 	$t1, $t0, -90 		# ascii 90 is cutoff point from upper to lowercase

	beq		$a2, $zero, to_lower	
	add 	$a2, $zero, $zero 	#Change upper/lower status flag

	bltz 	$t1, end_camel 		# om $t0 - 90 < 0 char is upper
	addi 	$t0, $t0, -32		#-32 is difference between upper and lower
	sb 		$t0, 0($a0)			#save modified char

	j end_camel
	
	to_lower:
	bgtz 	$t1, end_camel 		# om $t0 - 90 < 0 char is upper
	addi 	$t0, $t0, +32		#+32 is difference between upper and lower
	sb 		$t0, 0($a0)			#save modified char
	addi 	$a2, $zero, 1 	#Change upper/lower status flag

	end_camel:
	jr		$ra


##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

STR_for_each_reverse:
	.asciiz "\n\nstring_for_each(str, reverse)\n\n"

STR_for_each_camel:
	.asciiz "\n\nstring_for_each(str, camel)\n\n"

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4		# PUSH return address
	sw		$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li		$v0, 4
	la		$a0, STR_sum_of_fibonacci_a
	syscall

	lw 		$a0, ARRAY_SIZE
	li		$v0, 1
	syscall

	li		$v0, 4
	la		$a0, STR_sum_of_fibonacci_b
	syscall
	
	la		$a0, FIBONACCI_ARRAY
	lw		$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add		$a0, $v0, $zero
	li		$v0, 1
	syscall

	li		$v0, 4
	la		$a0, NLNL
	syscall
	
	la		$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li		$v0, 4
	la		$a0, STR_string_length
	syscall

	la		$a0, STR_str
	jal 	string_length

	add		$a0, $v0, $zero
	li		$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li		$v0, 4
	la		$a0, STR_for_each_ascii
	syscall
	
	la		$a0, STR_str
	la		$a1, ascii
	jal		string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li		$v0, 4
	la		$a0, STR_for_each_to_upper
	syscall

	la		$a0, STR_str
	la		$a1, to_upper
	jal		string_for_each
	
	la		$a0, STR_str
	jal		print_test_string

	##
	### string_for_each(string, reverse )________________________
	##

	li		$v0, 4
	la		$a0, STR_for_each_reverse
	syscall

	#get string length
	la		$a0, STR_str
	jal 	string_length
	add		$a2, $zero, $v0		#string length as input
	addi	$a2, $a2, -1		#exclude null

	la		$a0, STR_str
	la		$a1, reverse
	jal		string_for_each

	la		$a0, STR_str
	jal		print_test_string

	##
	### String_for_each(string, camel)_____________________
	##
	li		$v0, 4
	la		$a0, STR_for_each_camel
	syscall

	la		$a0, STR_str
	la		$a1, camel
	add		$a2, $zero, $zero #upper/lower status flag
	jal		string_for_each

	la		$a0, STR_str
	jal		print_test_string

	#_____________________________________________
	lw		$ra, 0($sp)	# POP return address
	addi	$sp, $sp, 4	
	jr		$ra


##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add		$t0, $a0, $zero
	
	li		$v0, 4
	la		$a0, STR_str_is
	syscall

	add		$a0, $t0, $zero
	syscall

	li		$v0, 4	
	la		$a0, STR_quote
	syscall
	
	jr		$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add		$t1, $t0, 8				# Position of X
	lb		$t2, 0($a0)				# Get the Ascii value
	sb		$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add		$a0, $t0, $zero 
	li		$v0, 4
	syscall

	# Append the Ascii value
	
	add		$a0, $t2, $zero
	li		$v0, 1
	syscall


	jr		$ra 
