# Group: T05G04
# Lee Sing Yuan
# Benjamin Leong Tjen Ho
# Lim Jing Kai
# Loh Zhun Guan
# Assignment 1 - Task 3

	.globl get_multiples

	.data	
strA: 		.asciiz "The number of multiples of "
strB: 		.asciiz " is: "
newline:	.asciiz "\n"

	.text
###############################################
##############################################################
#	 			MAIN'S STACK FRAME (+ Argument(s))
#	what is inside							where is the pointer
#	n (argument 2)							$sp
#	address of the_list (argument 1)		
#	address of my_list
#	n
#	original $fp							$fp
##############################################################
###############################################

main:
	addi $fp, $sp, 0
	
	# 2 bytes, 1 for arr address, 1 for n
	addi $sp, $sp, -8
	
	# initializing local variables
	# list
	addi $v0, $0, 9 		# allocate
	addi $a0, $0, 16 		# (3*4)+4, 12 bytes for 3 integers in list, another 4 for length
	syscall
	sw $v0, -8($fp) 		## array address in stack ##
	
	# store elements in the heap
	lw $t0, -8($fp) 		## load array address ##
	addi $t1, $0, 3	
	sw $t1, ($t0)    		# len of array = 3
	
	addi $t1, $0, 2 		# [0] is 2
	sw $t1, 4($t0)
	
	addi $t1, $0, 4			# [1] is 4
	sw $t1, 8($t0)
	
	addi $t1, $0, 6 		# [2] is 6
	sw $t1, 12($t0)
	
	# n
	addi $t0, $0, 3
	sw $t0, -4($fp) 		# n = 3
	
	# print ("The number of multiples of ")
	la $a0, strA 			# part 1 of print statement
	addi $v0, $0, 4
	syscall
	
	# print (n)
	lw $a0, -4($fp) 		# load n = 3
	addi $v0, $0, 1 		# print
	syscall
	
	# print (" is: ")
	la $a0, strB 			# part 2 of print statement
	addi $v0, $0, 4
	syscall
	
	# calling get_multiples 
	# 2 arguments (8 bytes)
	addi $sp, $sp, -8
	
	# arg 1 = my_list -- 4($sp)
	lw $t0, -8($fp)			# load address of my_list
	sw $t0, 4($sp)
	
	# arg 2 = n -- 0($sp)
	lw $t0, -4($fp) 		# load n
	sw $t0, 0($sp)
	
	jal get_multiples
	
	# Return from function
	addi $sp, $sp, 8 		# remove 2 arguments, the_list and n
	
	# get values
	add $a0, $0, $v0
	addi $v0, $0, 1
	syscall
	
	la $a0, newline
	addi $v0, $0, 4
	syscall
	
	# remove locals
	addi $sp, $sp, 8
	
	# exit
	addi $v0, $0, 10
	syscall
	
###############################################
##############################################################
#	 			GET_MULTIPLE'S STACK FRAME
#	what is inside							where is the pointer
#	count									$sp
#	i (counter for get_multiples for loop)
#	saved address of $fp					$fp
#	saved address of $ra	 				$ra
#	n (argument 2)
#	address of the_list (argument 1)		
##############################################################
###############################################

get_multiples:	
	# save $fp and $ra in stack
	addi $sp, $sp, -8  		# make space
	sw $fp, 0($sp) 			# save $fp
	sw $ra, 4($sp) 			# save $ra
	
	# copy $sp to $fp
	addi $fp, $sp, 0
			
	# allocating 8 bytes for local variable count
	addi $sp, $sp, -8
	
	# initializing local variables  
	addi $t0, $0, 0 
	sw $t0, -8($fp) 		# count = 0
	
	addi $t0, $0, 0
	sw $t0, -4($fp) 		# i = 0
	
	
loop:
	# for i in range(len(the_list)):
	lw $t0, -4($fp)			# load i to $t0
	lw $t2, 12($fp) 		# load address of the array
	lw $t1, ($t2) 			# loads length of array ($t2)
	slt $t2, $t0, $t1 		# if i < len(array) -> True, skip next
	beq $t2, $0, endloop 	# if i < len(array) -> False, jump to endloop
	
	# finding the offset(the_list[i])
	# x + (4 + 4i)
	lw $t0, 12($fp) 		# load array address to $t0
	lw $t1, -4($fp) 		# load i to $t1
	sll $t1, $t1, 2 		# 2^2 = 4, 4 * i 
	add $t1, $t1, $t0 		# array add, x + (4 * i)
	addi $t1, $t1, 4 		# length offset, (x + 4 + (4 * i))
	lw $t0, ($t1) 
	
	# if the_list[i] % n == 0 and the_list[i] != n:
	lw $t0, 12($fp) 		# load array address to $t0
	lw $t1, -4($fp) 		# load i to $t1
	sll $t1, $t1, 2			# 2^2 = 4, 4 * i 
	add $t1, $t1, $t0		# array add, x + (4 * i)
	addi $t1, $t1, 4		# length offset, (x + 4 + (4 * i))
	lw $t0, ($t1) 
	lw $t2, 8($fp) 			# load n
	div $t0, $t2 			# dividing the_list[i] by n
	mfhi $t3 				# getting the remainder 
	
	# both 'and' conditions
	bne $t3, $0, endif 		# if the_list[i] % n != 0, go to endif
	beq $t0, $t2, endif 	# if the_list[i] == n, go to endif
	
	# if both fulfilled
	# (if the_list[i] % n == 0 & the_list[i] != n)
	# count += 1, next loop
	lw $t0, -8($fp) 		# load count to $t0
	addi $t0, $t0, 1 		# count + 1
	sw $t0, -8($fp)
	j endif
	
	
endif: 	
	# i += 1
	lw $t0, -4($fp) 		# load 1
	addi $t0, $t0, 1 		# i + 1
	sw $t0, -4($fp) 

	j loop
	
	
endloop:
	# return count
	lw $v0, -8($fp) 
	
	# Function return
	# deallocate local variable
	addi $sp, $sp, 8
	
	# Restore $fp and $ra
	lw $fp, 0($sp)			# restore $fp
	lw $ra, 4($sp)			# restore $ra
	addi $sp, $sp, 8 		# deallocate space
	jr $ra 					# return
