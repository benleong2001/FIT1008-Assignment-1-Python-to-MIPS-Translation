# Group: T05G04
# Lee Sing Yuan
# Benjamin Leong Tjen Ho
# Lim Jing Kai
# Loh Zhun Guan
# Assignment 1 - Task 1

	.data
number_prompt: 			.asciiz "Enter the number: "
first_divisor_prompt: 	.asciiz "Enter the first divisor: "
second_divisor_prompt: 	.asciiz "Enter the second divisor: "
print_prompt:			.asciiz "\nDivisors: "
newline: 				.asciiz "\n"

number: 				.word 0
first_divisor: 			.word 0 
second_divisor: 		.word 0
divisors: 				.word 0

	.text
	# number = int(input("Enter the number: "))
	addi $v0, $0, 4					# using callcode 4
	la $a0, number_prompt			# printing number_prompt
	syscall

	addi $v0, $0, 5					# using callcode 5
	syscall					
	sw $v0, number					# storing input integer in number

	# first_divisor = int(input("Enter the first divisor: "))
	addi $v0, $0, 4					# using callcode 4
	la $a0, first_divisor_prompt	# printing first_divisor_prompt
	syscall

	addi $v0, $0, 5					# using callcode 5
	syscall							
	sw $v0, first_divisor			# storing input integer in first_divisor

	# second_divisor = int(input("Enter the second divisor: "))
	addi $v0, $0, 4					# using callcode 4
	la $a0, second_divisor_prompt	# printing second_divisor_prompt
	syscall

	addi $v0, $0, 5					# using callcode 5
	syscall
	sw $v0, second_divisor			# storing input integer in second_divisor

	# divisors = 0
	sw $0, divisors					# storing 0 in divisors


	# if number % first_divisor == 0 and number % second_divisor == 0:
if_cond_1:
	lw $t0, number					# loading number in $t0
	lw $t1, first_divisor			# loading first_divisor in $t1
	div $t0, $t1					# dividing number by first_divisor
	mfhi $t1						# $t1 = remainder of number / first_divisor
	bne $t1, $0, elif_cond_1		# if number % first_divisor != 0, jump to elif_cond_1

if_cond_2:
	lw $t1, second_divisor			# loading second_divisor in $t1
	div $t0, $t1					# dividing number by second_divisor
	mfhi $t1 						# $t1 = remainder of number / second_divisor
	bne $t1, $0, elif_cond_1		# if number % second_divisor != 0, jump to elif_cond_1

if_true:
	# divisors = 2
	addi $t0, $0, 2					# $t0 = 2
	sw $t0 divisors					# storing 2 in divisors
	j endif


	# elif number % first_divisor == 0 or number % second_divisor == 0:
elif_cond_1:
 	lw $t0, number					# loading number in $t0
	lw $t1, first_divisor			# loading first_divisor in $t1
	div $t0, $t1					# dividing number by first_divisor
	mfhi $t1						# $t1 = remainder of number / first_divisor
	beq $t1, $0, elif_true 			# if number % first_div == 0, jump to elif_true

elif_cond_2:
	lw $t1, second_divisor			# loading second_divisor in $t1
	div $t0, $t1					# dividing number by second_divisor
	mfhi $t1						# $t0 = remainder of number / second_divisor
	bne $t1, $0, else				# if number % second_divisor == 0, jump to else

elif_true:
	# divisors = 1
	addi $t0 $0 1					# $t0 = 1
	sw $t0 divisors					# storing 1 in divisors
	j endif
	
	
	# else:
	# divisors = 0
else:
	sw $0, divisors					# storing 0 in divisors

	# print("\nDivisors: " + str(divisors))
endif:
 	addi $v0, $0, 4					# using callcode 4
	la $a0, print_prompt			# printing print_prompt
	syscall
	
	# printing number of divisors
	addi $v0, $0, 1					# using callcode 1
	lw $a0, divisors				# printing divisors
	syscall
	
	# printing new line
	addi $v0, $0, 4					# using callcode 4
	la $a0, newline					# printing newline
	syscall
	
	# ending execution
	addi $v0, $0, 10				# using callcode 10
	syscall
