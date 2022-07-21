# Group: T05G04
# Lee Sing Yuan
# Benjamin Leong Tjen Ho
# Lim Jing Kai
# Loh Zhun Guan
# Assignment 1 - Task 4

# registers $t0 --> $t7 is used for address allocation 
# registers #s0 --> $s7 is used for calculation 
# uses [6, -2, 7, 4, -10] as example 
### instruction ###
## header 
# subheader 

	.globl insertion_sort

	.data 
emptyS: 	.asciiz " " 
newline: 	.asciiz "\n"

	.text 
###############################################
##############################################################
#	 			MAIN'S STACK FRAME (+ Argument(s))
#	what is inside							where is the pointer
#	address of the_list (argument 1)		$sp
#	i (counter for main for loop)  				
#	address of arr
#	original $fp							$fp
##############################################################
###############################################

main:	
	## main requires 4 * 2 (arr and i) space in the stack   
	# setting frame pointer to stack pointer 
	addi $fp, $sp, 0
	
	# allocation of space in stack
	addi $sp, $sp, -8	

		
	### arr = [6, -2, 7, 4, -10] ###
	## Array space allocation 

	# calculating size				# input size here
	addi $s0, $0, 5	# $s0 = size
	
	# add 1 because must store the length of the array at 
	# the address itself 
	addi $s1, $s0, 1				# $s1 = size + 1
	
	# size * 4
	sll $s1, $s1, 2 				# $s1 = (size + 1) * 4
	
	# allocating space
	addi $v0, $0, 9
	add $a0, $0, $s1	
	syscall 

	# storing address of array in stack
	sw $v0, -4($fp)
	
	
	### i ###
	# storing i = 0
	sw $0, -8($fp)
	
	## storing elements in array
	# retrieve address of array 
	lw $t0, -4($fp)					# $t0 = address of array
	
	# storing size at address
	sw $s0, 0($t0)
		
	# storing array[0]				# input elements here 
	addi $s1, $0, 6
	sw $s1, 4($t0)
	
	# storing array[1]
	addi $s1, $0, -2
	sw $s1, 8($t0)
	
	# storing array[2]
	addi $s1, $0, 7
	sw $s1, 12($t0)
	
	# storing array[3]
	addi $s1, $0, 4
	sw $s1, 16($t0)
	
	# storing array[4]
	addi $s1, $0, -10
	sw $s1, 20($t0)
	
	
	### insertion_sort(arr) ###
	## calling function 
	# allocating space to push in argument in stack
	addi $sp, $sp, -4
	
	# retrieve address of array
	lw $t0, -4($fp)					# $t0 = address of array
	
	# pushing in array address as argument
	sw $t0, -12($fp)
	
	# calling function	
	jal insertion_sort
	
	## dealloaction of locals and arguments
	addi $sp, $sp, 4
	
	
	### for i in range(len(arr)): ###
	forPrint: 
		# load ar 
		lw $t0, -4($fp)				# $t0 = address of array
	
		# load length
		lw $s0, 0($t0)				# $s0 = length
	
		# load i 
		lw $s1, -8($fp)				# $s1 = i
	
		# if i == length
		beq $s0, $s1, endForPrint	# if i == length, break
	
	
	### print(arr[i], end=" ") ### 
	## printing
	# obtain the address 
	lw $t0, -4($fp)
	
	# loading i
	lw $s1, -8($fp)					# $s1 = i
	
	# calculate offset
	sll $s2, $s1, 2					# $s2 = i * 4
	
	# adding offset to address
	add $t0, $t0, $s2
	
	# loading that element
	lw $a0, 4($t0)					# 4 because need to jump over length
	
	addi $v0, $0, 1
	syscall
	
	# printing space
	addi $v0, $0, 4
	la $a0, emptyS
	syscall
	
	# increment
	lw $s0, -8($fp)
	addi $s0, $s0, 1
	sw $s0, -8($fp)
	
	j forPrint
	
	
endForPrint: 
	### print() ###
	# printing empty line
	addi $v0, $0, 4
	la $a0, newline
	syscall
	
	# end
	addi $v0, $0, 10
	syscall
	
	
################################################################################################

###############################################
##############################################################
#	 		INSERTION_SORT'S STACK FRAME (+ Argument(s))
#	what is inside							where is the pointer
#	j										$sp
#	key					
#	i (counter for insertion_sort for loop)
#	length
#	saved address of $fp					$fp
#	saved address of $ra	 				$ra
#	address of the_list (argument 1)		
##############################################################
###############################################

# insertion_sort requires 4 * 4 (length, i, key, j)
insertion_sort:	
	## allocation of $ra and $fp on stack
	# allocate space in stack
	addi $sp, $sp, -8
	
	# store $ra 
	sw $ra, 4($sp)
	
	# store $fp
	sw $fp, 0($sp)
	
	# copying $sp into $fp
	add $fp, $0, $sp
	
	## allocation of 2 local variables (length and i)
	# allocation of space 
	addi $s0, $0, -4 				# $s0 = -4
	# (why -4 ? because the stack pushes towards the heap or smaller addresses)
	
	sll $s0, $s0, 2 				# $s0 = -4 * 4 
	add $sp, $sp, $s0				# $sp = $sp - 16
	
	
	
	### length = len(the_list) ### 
	# storing of length
	lw $t0, 8($fp)					# $t0 = address of array
	lw $t1, 0($t0)					# $t1 = length of array
	sw $t1, -4($fp)					# -4($fp) = length
	
	
	
	### i ###
	# storing of i
	addi $s0, $0, 1
	sw $s0, -8($fp)	# -8($fp) = i
	
	
	### for i in range(1, length): ###
	for: 
		# load i and load length and check if it has reached range
		lw $s0, -8($fp)				# $s0 = i 
		lw $s1, -4($fp)				# $s1 = length
		beq $s0, $s1, endFor		# if i == length , break
		
		
		### key = the_list[i] ### 
		## obtain the_list[i] 
		# load array 
		lw $t0, 8($fp)				# $t0 = address of array
		
		## calculate index 
		# load i 
		lw $s0, -8($fp)				# $s0 = i
		
		# offset = multiply i with 4
		sll $s1, $s0, 2				# $s1 = i * 4
		
		# adding offset to address
		add $t1, $t0, $s1			# $t1 = address - 4
	
		# loading element 
		# add 4 to address because need to skip over
		# the size which is stored exactly on the address
		lw $s2, 4($t1)
			
		# storing of key
		sw $s2, -12($fp)
		
		
		### j = i-1 ###   
		# load i 
		lw $s0, -8($fp)				# $s0 = i
		
		# subtract i 
		addi $s1, $s0, -1			# $s1 = i - 1
		
		# storing of j 
		sw $s1, -16($fp)	

	
		### while j >= 0 and key < the_list[j]: ### 
		while: 
			### while j >= 0 ### 
			# load j 
			lw $s0, -16($fp)		# $s0 = j 
			slt $s1, $s0, $0		# the negation is j < 0 
			bne $s1, $0, endWhile	# if j < 0 endWhile
			
		
			### and key < the_list[j]: ###
			# loading key 
			lw $s0, -12($fp)		# $s0 = key
			
			## calculating offset
			# load j
			lw $s1, -16($fp)		# $s1 = j
		
			# offset = j * 4
			sll $s2, $s1, 2			# $s2 = j * 4
		
			# loading the address of array
			lw $t0, 8($fp)
		
			# adding address with offset
			add $s3, $s2, $t0		# $s3 = the_list[j] - 4 
									# because it still included the length
		
			# retrieving the element
			lw $s4, 4($s3)			# must add 4 because must jump over length which is stored at
									# at the address itself
									# $s4 = the_list[j]
											
			# key < the_list[j]:
			slt $s2, $s0, $s4		# if key < the_list[j]
			beq $s2, $0, endWhile	# if key > the_list[j], go to endWhile 
			
			
			### the_list[j + 1] = the_list[j] ###
			## obtaining the element at j
			# loading j
			lw $s1, -16($fp)		# $s1 = j
			
			# offset = j * 4
			sll $s2, $s1, 2			# $s2 = j * 4
		
			# loading the address of array
			lw $t0, 8($fp)			# $t0 = address of array
		
			# adding address with offset
			add $s3, $s2, $t0		# $s3 = the_list[j] - 4 
									# because it still included the length
				
			# retrieving the element
			lw $s4, 4($s3)			# must add 4 because must jump over length which is stored at
									# at the address itself
									# $s4 = the_list[j]		
							
			## storing at the_list[j + 1]
			# loading j
			lw $s1, -16($fp)		# $s1 = j
		
			# adding because its j+1
			addi $s2, $s1, 1		# $s2 = j + 1
		
			# offset = j * 4
			sll $s2, $s2, 2			# $s2 = (j + 1) * 4
			
			# loading the address of array
			lw $t0, 8($fp)			# $t0 = address of array
		
			# adding address with offset
			add $s3, $s2, $t0		# $s3 = the_list[j+1] - 4
			
			
			# storing the_list[j] at the_list[j+1]
			sw $s4, 4($s3)


			
			### j -= 1 ###
			# load j and store j 
			lw $s0, -16($fp)	 	# $s0 = j
			addi $s0, $s0, -1		# j = j - 1
			sw $s0, -16($fp)
			
			# go back to while
			j while
			
			
		endWhile: 
			### the_list[j + 1] = key ###
			## storing at the_list[j + 1]
			# loading j
			lw $s1, -16($fp)		# $s1 = j
		
			# adding 1 because its j+1
			addi $s2, $s1, 1		# $s2 = j + 1
		
			# offset * 4
			sll $s2, $s2, 2			# $s2 = (j + 1) * 4
			
			# loading the address of array
			lw $t0, 8($fp)			# $t0 = address of array
		
			# adding address with offset
			add $s3, $s2, $t0		# $s3 = the_list[j+1]
			
			# load key 
			lw $s0, -12($fp)		# $s0 = key
			
			# storing of key at the_list[j+1]
			sw $s0, 4($s3)			# 4($s3) because need to jump over length
		
			# inrement of i 
			lw $s0, -8($fp)
			addi $s0, $s0, 1
			sw $s0, -8($fp)
		
			# go back to for
			j for
			
			
	endFor:	
		# deallocation of local variables 
		addi $sp, $sp, 16			# because 4 variables * 4 
	
		# restoration of $fp 
		lw $t0, 0($sp)				# $t0 = saved $fp
		add $fp, $0, $t0
	
		# restoration of $ra
		lw $t0, 4($sp)				# $t0 = saved $ra
		add $ra, $0, $t0
	
		# deallocate the space
		addi $sp, $sp, 8
	
		jr $ra
