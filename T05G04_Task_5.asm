# Group: T05G04
# Lee Sing Yuan
# Benjamin Leong Tjen Ho
# Lim Jing Kai
# Loh Zhun Guan
# Assignment 1 - Task 5

	.globl binary_search
	
	.data
newline: 	.asciiz "\n"

	.text
###############################################
##############################################################
#	 			MAIN'S STACK FRAME (+ Argument(s))
#	what is inside							where is the pointer
#	high (argument 4)						$sp
#	low (argument 3)
# 	target (argument 2)
#	address of the_list (argument 1)		
#	index
#	address of arr
#	original $fp							$fp
##############################################################
###############################################

		
main:
	addi $fp, $sp, 0
	addi $sp, $sp, -8 		# 8 bytes of memory, 1 for arr address, 1 for index
	
	addi $v0, $0, 9			# allocate heap for arr
	addi $a0, $0, 24		# 5 elements in array plus one array size, (5 * 4) + 4
	syscall
	sw $v0, -4($fp)			# store the address for arr in stack
	
	# store element in heap
	lw $t0, -4($fp)			# load address for arr
	addi $t1, $0 5
	sw $t1, 0($t0)			# len(arr) = 5
	
	addi $t1, $0, 1
	sw $t1, 4($t0)			# arr[0] = 1 
		
	addi $t1, $0, 5
	sw $t1, 8($t0)			# arr[1] = 5
	
	addi $t1, $0, 10
	sw $t1, 12($t0)			# arr[2] = 10
	
	addi $t1, $0, 11
	sw $t1, 16($t0)			# arr[3] = 11
	
	addi $t1, $0, 12
	sw $t1, 20($t0)			# arr[4] = 12
	
	# store index in stack
	sw $0, -8($fp)			# index = 0
	
	# call binary_search, pass arguments into stack
	addi $sp, $sp, -16		# allocate space (4 * 4 for arguments)
	lw $t0, -4($fp)			# load address of arr
	lw $t1, 0($t0)			# load len(arr) to $t1
	addi $t1, $t1, -1		# len(arr) - 1
	sw $t1, 0($sp)			# pass len(arr) - 1 into arg high
	
	sw $0, 4($sp)			# pass 0 into arg low
	addi $t1, $0, 11		###### change target here #######
	sw $t1, 8($sp)			# pass 11 into arg target
	lw $t0, -4($fp)			# load address of arr
	sw $t0, 12($sp)			# pass arr address into arg the_list
	
	jal binary_search
	
	addi $sp, $sp, 16		# remove arguments
	
	# index = binary_search
	sw $v0, -8($fp)			# store result from function into index
	
	# print result
	addi $v0, $0, 1
	lw $a0, -8($fp)			# load index
	syscall
	
	# printing new line
	addi $v0, $0, 4
	la $a0, newline
	syscall
	
	# remove locals
	addi $sp, $sp, 8
	
	# exit
	addi $v0, $0, 10
	syscall


###############################################
##############################################################
#				BINARY_SEARCH'S STACK FRAME
#	what is inside							where is the pointer
#	mid										$sp
#	saved address of $fp					$fp
#	saved address of $ra	 				$ra
#	high (argument 4)
#	low (argument 3)
# 	target (argument 2)
#	address of the_list (argument 1)		
##############################################################
###############################################
	
binary_search:
	# function entry
	addi $sp, $sp, -8
	sw $fp, 0($sp)			# save $fp
	sw $ra, 4($sp)			# save $ra
	
	addi $fp, $sp, 0
	
	addi $sp, $sp, -4		# create memory for local variable mid
	sw $0, -4($fp)			# mid = 0
	
	# if low > high, return -1
	lw $t0, 12($fp)			# low
	lw $t1, 8($fp)			# high
	slt $t0, $t1, $t0		# if high < low, $t0 = 1
	beq $t0, $0, else
	
	# return -1
	addi $v0, $0, -1
	
	# function return
	j end
	
	
	# mid = (high + low) // 2
else:
	lw $t0, 8($fp)			# load high
	lw $t1, 12($fp)			# load low
	add $t0, $t0, $t1		# high + low
	addi $t1, $0, 2
	div $t0, $t1
	lw $t2, -4($fp)
	mflo $t2				# (high + low) // 2
	sw $t2, -4($fp)			# store in mid
	
	# if the_list[mid] == target:
	lw $t1, -4($fp)			# load mid
	lw $t0, 20($fp)			# load arr address
	sll $t1, $t1, 2 		# offset
	add $t1, $t0, $t1
	addi $t1, $t1, 4		# offset + 4
	lw $t1, ($t1)			# the_list[mid]
	
	lw $t2, 16($fp)			# load target
	
	bne $t1, $t2, elif_high	# if the_list[mid] != target, jump elif_high
	
	# return mid
	lw $t1, -4($fp)			# load mid
	addi $v0, $t1, 0		

	# function retutn
	j end
	
	
	# elif the_list[mid] > target
elif_high:
	lw $t1, -4($fp)			# load mid as usual
	lw $t0, 20($fp)			# load arr address
	sll $t1, $t1, 2 		# offset
	add $t1, $t0, $t1
	addi $t1, $t1, 4		# offset + 4
	lw $t1, ($t1)			# the_list[mid]
	
	lw $t2, 16($fp)			# load target
	
	# if not target < the_list[mid], $t0 = 0, jump to else_low
	slt $t0, $t2, $t1		
	beq $t0, $0, else_low
	
	# recursive call
	addi $sp, $sp, -16		# 4 arguments
	
	lw $t1, -4($fp)			# load mid as usual
	addi $t1, $t1, -1		# mid - 1
	sw $t1, 0($sp)
	
	lw $t1, 12($fp)			# load low
	sw $t1, 4($sp)
	
	lw $t1, 16($fp)			# load targer
	sw $t1, 8($sp)
	
	lw $t0, 20($fp)			# load address of arr
	sw $t0, 12($sp)	

	jal binary_search
	
	# return binary_search
	# deallocate local variable
	addi $sp, $sp, 16	
	
	j end
	
	
	# else
else_low:
	# recursive call
	addi $sp, $sp, -16		# 4 arguments
	
	lw $t1, 8($fp)			# load high
	sw $t1, 0($sp)
	
	lw $t1, -4($fp)			# load mid
	addi $t1, $t1, 1		# mid + 1
	sw $t1, 4($sp)
	
	lw $t1, 16($fp)			# load target
	sw $t1, 8($sp)
	
	lw $t0, 20($fp)			# load address of arr
	sw $t0, 12($sp)	
	
	jal binary_search
	
	# return binary_search
	# dealocate local variable
	addi $sp, $sp, 16
	
	
end:	
	addi $sp, $sp, 4		# deallocate local variable
	
	lw $fp, 0($sp)			# restore $fp
	lw $ra, 4($sp)			# restore $ra
	addi $sp, $sp, 8		# deallocate space
	
	# return
	jr $ra