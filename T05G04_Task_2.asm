# Group: T05G04
# Lee Sing Yuan
# Benjamin Leong Tjen Ho
# Lim Jing Kai
# Loh Zhun Guan
# Assignment 1 - Task 2

	.data
size_prompt: 	.asciiz "Enter array length: "
n_prompt: 		.asciiz "Enter n: "
element_prompt: .asciiz "Enter the value: "
print_prompt: 	.asciiz "\nThe number of multiples (excluding itself) = "
newline: 		.asciiz "\n"

size: 			.word 0
the_list: 		.word 0
n: 				.word 0
count: 			.word 0
i: 				.word 0

	.text
	# size = int(input("Enter array length: "))
	addi $v0, $0, 4								# using callcode 4
	la $a0, size_prompt							# printing size_prompt
	syscall

	# storing input int in size
	addi $v0, $0, 5								# using callcode 5
	syscall
	sw $v0, size								# storing input integer in size

	# the_list = [None]*size
	addi $v0, $0, 9								# using callcode 9 t0 allocate memory for the_list
	lw $t0, size								# loading size to $t0
	addi $t0, $0, 1								# adding 1 to $t0
	sll $a0, $t0, 2								# number of bytes = (size + 1) * 4
	syscall			
	sw $v0, the_list							# storing the address of the array in the_list

	# storing size = len(the_list) at the first addr of the_list
	lw $t0, size								# loading size to $t0
	lw $t1, the_list							# loading the address of the_list in $t1
	sw $t0, 0($t1)								# storing the size in the first address of the_list

	# n = int(input("Enter n: "))
	addi $v0, $0, 4								# using callcode 4
	la $a0, n_prompt							# printing n_prompt
	syscall

	# storing input int in n
	addi $v0, $0, 5								# using callcode 5
	syscall
	sw $v0, n									# storing input integer in n

	# count = 0
	sw $0, count								# storing 0 in count


	# for i in range(len(the_list)):
while_i_lt_len_the_list:
	# checking loop condition
	lw $t0, i									# loading i in $t0
	lw $t1, the_list 							# loading the address of the_list in $t1
	lw $t1, 0($t1)								# loading len(the_list) to $t1
	slt $t0, $t0, $t1							# if i < len(the_list), $t0 = 1
	beq $t0, $0, end_while_i_lt_len_the_list	# if i >= len(the_list), jump to end_while_i_lt_len_the_list
		
	# the_list[i] = int(input("Enter the value: "))
	addi $v0, $0, 4								# using callcode 4
	la $a0, element_prompt						# printing element_prompt
	syscall
	
	# storing input int in the_list[i]
	addi $v0, $0, 5								# using callcode 5
	syscall	
	lw $t0, i									# loading i to $t0
	sll $t0, $t0, 2								# $t0 = 4 * i
	lw $t1, the_list							# loading address of the_list to $t1
	add $t0, $t0, $t1							
	sw $v0, 4($t0)								# storing input integer in the_list[i]
	
	
	# if the_list[i] % n == 0 and the_list[i] != n:
if_cond_1:
	# the_list[i]
	lw $t0, i									# loading i to $t0
	sll $t0, $t0, 2								# $t0 = 4 * i			
	lw $t1, the_list							# loading the address of the_list to $t1
	add $t0, $t0, $t1
	lw $t0, 4($t0)								# loading the_list[i] to $t0
	
	# n
	lw $t1, n									# loading n to $t1
	
	div $t0, $t1								# dividing the_list[i] by n
	mfhi $t2									# $t2 = remainder of the_list[i] / n
	bne $t2, $0, endif							# if remainder != 0, jump to endif
	
	
if_cond_2:
	beq $t0, $t1, endif 						# if the_list[i] == n, jump to endif
	
	# count += 1
	lw $t0, count								# loading count to $t0
	addi $t0, $t0, 1							# adding 1 to count and saving new value to $t0
	sw $t0, count								# storing new value in count


endif:
	# i += 1	
	lw $t0, i									# loading i to $t0
	addi $t0, $t0, 1							# adding 1 to i and saving new value to $t0
	sw $t0, i									# storing new value in i
	
	j while_i_lt_len_the_list					# jumping back to loop
	    	
	    	
end_while_i_lt_len_the_list:
	# print("\nThe number of multiples (excluding itself) = " + str(count))
	# print print_prompt
	addi $v0, $0, 4								# using callcode 4
	la $a0, print_prompt						# printing print_prompt
	syscall
	
	# print count
	addi $v0, $0, 1								# using callcode 1
	lw $a0, count								# printing count
	syscall
	
	# print newline
	addi $v0, $0, 4								# using callcode 4
	la $a0, newline								# printing newline
	syscall
		
	# end execution
	addi $v0, $0, 10							# using callcode 10
	syscall
