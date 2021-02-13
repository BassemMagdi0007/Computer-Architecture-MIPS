#----- Constants

.data
	Enter_Value: 	.asciiz "Enter Size Of Request (Max 10) : "
	Enter_request: 	.asciiz "Enter Request : "
	Enter_Priority: .asciiz "Enter Request Priority :"
	error_msg: 		.asciiz "Error!"
	Delete_Msg: 	.asciiz "Delete request(s) with the following priority: \n"
	emptyList:  	.asciiz "The List Is Empty"
	Process_Msg: 	.asciiz "Fetch request(s) given the following priority: \n"
	Sorted:			.asciiz "The List Was Sorted"
	sep:            .asciiz "  "
	valueDeleted: 	.asciiz "Element  deleted successfully \n"
	options:   		.asciiz "\n1. Insert request.\n2. Delete all requests with specific priority.\n3. Process all requests with specific priority.\n4. Empty all lists.\n5. Binary Search by request.\n6. Binary Search by priority.\n7. Quick Sort list(s).\n8. Exit.\n"
	insertmsg:    	.asciiz "\nEnter Your Choice: "
	space: 			.asciiz ", "
	enterLetter:	.asciiz "\nEnter character to search for: "
	
	prompt: .asciiz  "\n\nEnter up to 10 characters: "  # Prompt asking for user input
	newLine: .asciiz "\n"                               # Newline character
	
	msg_before:	.asciiz	"before : "
	msg_after:	.asciiz "after : "
	msg_space:	.asciiz " "
	msg_newL:	.asciiz "\n"
	
	str:    .asciiz "Searching from index "
	to:     .asciiz " to "
	endl:   .asciiz "\n"


	#main variables
	LIST_SIZE:				.word 20
	NUMBER_OF_LISTS:		.word 4
	nextEmptyArrIndex: 		.word 0
	lastUpdatedIndex: 		.word -1
	list: 					.word 0
	indexInList: 			.word 0
	ListChoice: 			.word 0
	requestPriority:		.word 0
	requestSize: 			.word 0
	del_priority: 			.word 0
	search_priority: 		.word 0
	pr: 					.word 0
	listScan: 				.word 0
	ch: 					.word 0
	itr:					.word 0
	binarySearchRequest:	.word 0
		
        
	#Global arrays, reserves a block of 1000 bytes
	temp_arr_Letters: 		.space 1000
	main_arr_Letters: 		.space 1000

	arr_priority: 			.space 1000
	arr_indices: 			.space 1000
	
	letterArr: 				.space 1000
	arrP:					.space 1000
	arrI:					.space 1000
	
	to_sort_arr_letters:   	.space 1000
	to_sort_arr_priority:	.space 1000   
	to_sort_arr_indices:	.space 1000
	to_sort_integers:		.space 1000
	#theString: 				.space 1000   # A ten character string initially filled with whitespace
	
	
	#array: 				.word 12,20,10,5,7,3,2,1 
	#array: 				.word 'g','g','u','r','b','a','k','q' 


#------------------------------------------------------------------------------------------------------------------------------------------#
#----- Constants

	
.text

main:

jal Scan_Input 
	
		
#--------------------------------------------------------#
# optionMenu Choose what to do based on user choice in t0
#--------------------------------------------------------#

		beq		$t0, 1, Insert_request
		beq		$t0, 2, Delete_By_Pirority 
		beq		$t0, 3, Process_By_Pirority 
		beq		$t0, 4, Empty_All_Lists
		beq    	$t0, 5, BinarySearch_By_Request 
		beq		$t0, 6, BinarySearch_By_Priority 
		beq		$t0, 7, QuickSort_list
		beq		$t0, 8, Exit


#--------------------------------------------------------#
# Syscall to exit the program 
#--------------------------------------------------------#	

Exit:
	li	$v0, 10
	syscall
	
	
	
#--------------------------------------------------------#
#----- Functions Implementation		

Insert_request:
#----------------------

 Scan_Insert_Value:
#----------------------

	#Print "Enter Size Of Request (Max 10): " 
	#_______________________________
	li $v0,4 
	la $a0,Enter_Value
	syscall 
	
	#scan size of request from user
	#_______________________________
	li $v0, 5
	syscall

	#store the size of request in $v0 into requestSize word
	#_______________________________
	sw $v0,requestSize
	
	#Print "Enter Request : "
	#________________________
	li $v0,4 
	la $a0,Enter_request
	syscall 
	
	#Scan request with max 10 characters into temp_arr_Letters
	#li instruction loads a specific numeric value into that register.
	# 8 for reading string
	li $v0, 8
	la $a0,temp_arr_Letters
	li $a1,12
	syscall
 
	#scan priority from user
	#________________________
	
	#Print "Enter Request Priority :" 
	li $v0,4 
	la $a0,Enter_Priority
	syscall

	#Scan Value 
	li $v0, 5
	syscall

	#store the priority of request in $v0 into requestPriority word
	sw $v0,requestPriority
	#________________________

	add $t0, $zero, $zero   		# i is initialized to 0, $t0 = 0
		
	
loopOfPriority:
	#stuff
	
	la $t3, temp_arr_Letters		# $t3 = &temp_arr_Letters[0]
	la $t6, main_arr_Letters		# $t6 = &main_arr_Letters[0]
	#la $t7, arr_indices			# $t7 = &arr_indices[0]


	lw $t5, nextEmptyArrIndex		# nextEmptyArrIndex = 0	
	
	#Array of letters______________________
	#The lb instruction loads a byte from memory and sign extends to the size of the register
	add $t3, $t0, $t3  			# $t3 = &(temp_arr_Letters + i)
	lb $t4, 0($t3)				# fetch the value in the address of $t3 + 0 into $t4
	add $t6, $t5, $t6			# $t6 = &(main_arr_Letters + nextEmptyArrIndex)
	sw $t4, 0($t6) 				# store the value from $t4 into the address of $t6 + 0
	#______________________________________
	
	#Array of priorities___________________
	la $t6, arr_priority		# $t6 = &arr_priority[0]
	lw $t3, requestPriority		# get the priority user entered into $t3
	add $t6, $t5, $t6			# $t6 = &(arr_priority + nextEmptyArrIndex)
	sw $t3, 0($t6) 				# store the value from $t3 into the address of $t6 + 0
	#______________________________________

	#Array of Indices___________________
	la $t6, arr_indices			# $t6 = &arr_indices[0]
	add $t6, $t5, $t6			# $t6 = &(arr_indices + nextEmptyArrIndex)
	lw $t7, lastUpdatedIndex	# $t7 = lastUpdatedIndex;
	addi $t7, $t7, 1 			# lastUpdatedIndex++;
	sw $t7, lastUpdatedIndex	# store the new value of lastUpdatedIndex in memory
	sw $t7, 0($t6) 				# store the value from $t3 into the address of $t6 + 0
	#______________________________________

	#Loop Iterators and check_____________
	addi $t5, $t5, 4					# nextEmptyArrIndex++ (4 bytes)
	sw $t5, nextEmptyArrIndex			# store it to save its value 		
	addi $t0, $t0, 1 					# i++ (increment 1 byte only) to index temp_arr_letters (saved byte by byte when received from user)
	lw $t2, requestSize					# $t2 = requestSize
	slt $t1, $t0, $t2 					# $t1 = 1 if i < requestSize
	bne $t1, $zero, loopOfPriority 		# go to Loop if i < requestSize
	#______________________________________

	j main

#END OF Insert_request:
#----------------------
#_____________________________________________________________________________________________

update_indices:

	move $t2, $zero 	#i = 0; $t2 loop iterator
	move $t0, $zero 	# int update_val= 0; ($t0 = update_val)
loop_1_OfUpdateIndices:
	
	la $t6, arr_indices			# $t6 = &arr_indices[0]
	add $t6, $t2, $t6			# $t6 = &(arr_indices + i)
	lw  $t7, 0($t6)				# $t7 = arr_indices[i]
		
	bne $t7, -1, Condition_1_NotSatisfied  	#branch if not (-1 == arr_indices[i])
		
		addi $t0, $t0, -1 		#update_val--;
		addi $t1, $zero, -2		#$t1 = -2
		sw  $t1, 0($t6)			#arr_indices[i] = -2;
		j loop_conditions	        #continue;
		
Condition_1_NotSatisfied:
		
		bne $t7, -2, Condition_2_NotSatisfied  	#branch if not (-1 == arr_indices[i])
		j loop_conditions        	#continue;
		
Condition_2_NotSatisfied:
	add $t7, $t0, $t7				# $t7 = arr_indices[i] + update_val;
	sw  $t7, 0($t6)					#arr_indices[i] = $t7 (store in memory)
							
loop_conditions:
	#__________________ LOOP CONDITION and INCREMENT _______________________	
	addi $t2, $t2, 4 			# i++ (increment 4 bytes)
	lw $t3, nextEmptyArrIndex		# $t3 = nextEmptyArrIndex
	slt $t3, $t2, $t3 			# $t1 = 1 if i < nextEmptyArrIndex
	bne $t3, $zero, loop_1_OfUpdateIndices 		# go to Loop if i < nextEmptyArrIndex
	#end of loop_1_OfUpdateIndices

#All registers free to use again

	lw $t0, nextEmptyArrIndex	# $t3 = nextEmptyArrIndex
	addi $t1, $t0, -4 		#i = nextEmptyArrIndex-1
	
loop_2_OfUpdateIndices:
	
	la $t6, arr_indices			# $t6 = &arr_indices[0]
	add $t6, $t1, $t6			# $t6 = &(arr_indices + i)
	lw  $t7, 0($t6)				# $t7 = arr_indices[i]
		
	blt $t7, $zero, loop2_conditions 	#continue if (arr_indices[i] < 0)
		
		sw $t7, lastUpdatedIndex	#lastUpdatedIndex = arr_indices[i];
		jr $ra	        		#return;
		
							
loop2_conditions:
	#__________________ LOOP CONDITION and INCREMENT _______________________	
	addi $t1, $t1, -4 				# i-- (decrement 4 bytes)
	slt $t1, $t1, $zero 				# $t1 = 1 if i < 0
	bne $t1, 1, loop_2_OfUpdateIndices 		# exit Loop if i < 0
	
	#list is empty. must reset lastUpdateIndex
	addi $t1, $zero, -1				# $t0 = -1
	sw $t1, lastUpdatedIndex			#lastUpdatedIndex = -1;
	jr $ra
	#end of loop_2_OfUpdateIndices
  
	 		
#____________________________________________________________________________________________#

Delete_By_Pirority:

	
	#Print "Delete request(s) with the following priority: "
	#_______________________________________________________
	li $v0,4 
	la $a0, Delete_Msg
	syscall 
	
	#scan priority from user
	#_______________________
	li $v0, 5
	syscall

	#store the requested priority in $v0 into del_priority word
	#__________________________________________________________
	sw $v0, del_priority
	
	
	
#____________________________________################_________________________________________#

deleteByPriorityFUNCTION:
	
	move $t0, $v0  		#$t0 = del_priority
	move $t1, $zero 	#$t1 = 0 (int deletePerformed = 0;)
	move $t2, $zero 	#i = 0; $t2 loop iterator
	
loopOfDelete:
	
	la $t6, arr_priority					# $t6 = &arr_priority[0]
	add $t6, $t2, $t6						# $t6 = &(arr_priority + i)
	lw  $t7, 0($t6)							# $t7 = arr_priority[i]	
	bne $t0, $t7, ConditionNotSatisfied  	#branch if not (del_priority == arr_priority[i])
	
		addi $t1, $zero, 1			#deletePerformed = 1; 
		addi $t8, $zero, -1 		#$t8 = -1
		sw $t8, 0($t6)				#arr_priority[i] = -1
		la $t6, arr_indices			# $t6 = &arr_indices[0]
		add $t6, $t2, $t6			# $t6 = &(arr_indices + i)
		sw $t8, 0($t6)				#arr_indices[i] = -1
		
ConditionNotSatisfied:
		
	addi $t2, $t2, 4 			# i++ (increment 1 byte only) to index temp_arr_letters (saved byte by byte when received from user)
	lw $t3, nextEmptyArrIndex		# $t3 = nextEmptyArrIndex
	slt $t3, $t2, $t3 			# $t1 = 1 if i < nextEmptyArrIndex
	bne $t3, $zero, loopOfDelete 		# go to Loop if i < nextEmptyArrIndex
	#end of loopOfDelete
	
	bne $t1, 1, endDelete  	# if (deletePerformed != 1) don't call update_indices
	jal update_indices
	
endDelete:
	j main		
#____________________________________________________________________________________________#

#____________________________________################_________________________________________#

Process_By_Pirority:

	#Print "Fetch request(s) given the following priority: "
	#_______________________________________________________
	li $v0,4 
	la $a0, Process_Msg
	syscall 
	
	#scan priority from user
	#_______________________________
	li $v0, 5
	syscall

	#store the size of request in $v0 into search_priority word
	#___________________________________________________________
	sw $v0, search_priority

#____________________________________################_________________________________________#	

ProcessByPriorityFUNCTION:

	move $t0, $v0  		#$t0 = search_priority	
	move $t2, $zero 	#i = 0; $t2 loop iterator
	move $t5, $zero
loopOfProcess:
	
	la $t6, arr_priority			# $t6 = &arr_priority[0]
	add $t6, $t2, $t6			# $t6 = &(arr_priority + i)
	lw  $t7, 0($t6)				# $t7 = arr_priority[i]	
	bne $t0, $t7, Condition_Process_NotSatisfied  	#branch if not (del_priority == arr_priority[i])
		
		move $a0, $t5	 		#load $a0 with the logical index to send to listNumber
		jal listNumber
		#PRINT HERE
		
Condition_Process_NotSatisfied:
		
	addi $t2, $t2, 4 			# i++ (increment 1 byte only) to index temp_arr_letters (saved byte by byte when received from user)
	addi $t5, $t5, 1			#increment logical index
	lw $t3, nextEmptyArrIndex		# $t3 = nextEmptyArrIndex
	slt $t3, $t2, $t3 			# $t1 = 1 if i < nextEmptyArrIndex
	bne $t3, $zero, loopOfProcess 		# go to Loop if i < nextEmptyArrIndex
	#end of loopOfDelete
	
	j main

#____________________________________________________________________________________________#

#____________________________________################_________________________________________#



#____________________________________################_________________________________________#

Empty_All_Lists:

	move $t2, $zero 	#i = 0; $t2 loop iterator
	
loopOfEmptyLists:
	
	addi $t8, $zero, -2 			#$t8 = -2
	
	la $t6, arr_priority			# $t6 = &arr_priority[0]
	add $t6, $t2, $t6			# $t6 = &(arr_priority + i)
	sw  $t8, 0($t6)				# arr_priority[i] = -2	
	
	#$t6 is free to use now. Using $t6 for the indices array. 
	la $t6, arr_indices			# $t6 = &arr_indices[0]
	add $t6, $t2, $t6			# $t6 = &(arr_indices + i)
	sw  $t8, 0($t6)				# arr_indices[i] = -2	
		
	addi $t2, $t2, 4 			# i++ (increment 1 byte only) to index temp_arr_letters (saved byte by byte when received from user)
	lw $t3, nextEmptyArrIndex		# $t3 = nextEmptyArrIndex
	slt $t3, $t2, $t3 			# $t1 = 1 if i < nextEmptyArrIndex
	bne $t3, $zero, loopOfEmptyLists 		# go to Loop if i < nextEmptyArrIndex
	#end of loopOfDelete
	
	addi $t0, $zero, -1 			# $t0 = -1
	sw $t0, lastUpdatedIndex
	
	#print
	j main
#____________________________________################_________________________________________#


BinarySearch_By_Request:	


		jal BubbleSort
		
		
BinarySearch_By_Priority:


#____________________________________################_________________________________________#

cleanArrayFUNCTION:
	
#Save Context for the caller. In this function the following registers are locally used ($t0, $t1, $t2) and must be saved on the stack first

	sub $sp, $sp, 12 	#Move the stack pointer by 16 bytes. 16/4 = 4 words for the 4 registers
	sw $t0, 8($sp)
	sw $t1, 4($sp)
	sw $t2, 0($sp)
	
	move $t2, $zero 	#i = 0; $t2 loop iterator
	sw $zero, itr		# initialize itr = 0
	move $t1, $zero 	#$t1 = 0 to hold final value of itr
loopOfCleanArray:
	

	lw $t0, arr_indices($t2)   # $t0 = arr_indices[i];
	
	blt $t0, $zero, cleanArrayConditionCheck  	#continue if arr_indices[i] < 0
	
		#usable registers $t0, $t3, $t4, $t5, $t6, $t7, $t8, $t9
		lw $t0, main_arr_Letters($t2)   # $t0 = main_arr_Letters[i];
		sw $t0, letterArr($t1)		# letterArr[itr] = main_arr_Letters[i];
		
		lw $t0, arr_priority($t2)   	# $t0 = arr_priority[i];
		sw $t0, arrP($t1)		# arrP[itr] = arr_priority[i];
		
		lw $t0, arr_indices($t2)   	# $t0 = arr_indices[i];
		sw $t0, arrI($t1)		# arrI[itr] = arr_indices[i];
		
		addi $t1, $t1, 4		#itr++;
		
		
cleanArrayConditionCheck:
		
	addi $t2, $t2, 4 			# i++ (increment 1 byte only) to index temp_arr_letters (saved byte by byte when received from user)
	lw $t0, nextEmptyArrIndex		# $t3 = nextEmptyArrIndex
	blt $t2, $t0, loopOfCleanArray 		# go to Loop if i < nextEmptyArrIndex
	#end of loopOfDelete	
	
	sw $t1, itr
	
	#restore registers from stack  
	
	lw $t0, 8($sp)
	lw $t1, 4($sp)
	lw $t2, 0($sp)
	addi $sp, $sp, 12 	#Move the stack pointer back by 16 bytes
		
	jr $ra	
	
#____________________________________################_________________________________________#


listNumber:

#Save Context for the caller. In this function the following registers are locally used ($t1, $t2, $t3, $t4) and must be saved on the stack first
	
	sub $sp, $sp, 16 	#Move the stack pointer by 16 bytes. 16/4 = 4 words for the 4 registers
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t4, 0($sp)
	
	
	move $t2, $zero 	#i = 0; $t2 loop iterator
	
loopOf_listNumber:
	
	
	lw $t3, LIST_SIZE
	mul $t1, $t3, $t2			#firstIndex = LIST_SIZE * i ; firstIndex is $t1
	addi $t4, $t2, 1			# $t4 = i + 1
	mul $t3, $t3, $t4			#lastIndex = LIST_SIZE * (i + 1); lastIndex is $t3

	blt $a0, $t1, loopConditionANDIncrement  #if first condition not satisfied, goto next iteration
	blt $a0, $t3, ConditionsSatisfied	 #first condition satisfied (index >= firstIndex). Now check the second condition

	j loopConditionANDIncrement

ConditionsSatisfied:	
	addi $t3, $t2, 1			# $t3 = i + 1
	sw $t3, list				# list = i + 1;
	sub $t3, $a0, $t1			# $t3 = index - (LIST_SIZE * i);
	sw $t3, indexInList			#indexInList = index - (LIST_SIZE * i);	
	j exit_listNumber	

loopConditionANDIncrement:				
	addi $t2, $t2, 1 			# i++ (increment 1 byte only) [Logical increment, not address related]
	lw $t3, NUMBER_OF_LISTS			# $t3 = NUMBER_OF_LISTS
	slt $t3, $t2, $t3 			# $t3 = 1 if i < NUMBER_OF_LISTS
	bne $t3, $zero, loopOf_listNumber 	# go to Loop if i < NUMBER_OF_LISTS
	
	#end of loopOf_listNumber
	
exit_listNumber:		
	lw $t1, 12($sp)
	lw $t2, 8($sp)
	lw $t3, 4($sp)
	lw $t4, 0($sp)
	addi $sp, $sp, 16 	#Move the stack pointer back by 16 bytes
		
	jr $ra	
#____________________________________################_________________________________________#


 Scan_Input: 
#----------------------
	#Print The Options
	li $v0, 4
	la $a0, options
	syscall
	
	#Ask For The Input 
	li $v0, 4
	la $a0, insertmsg
	syscall
	
	#Get The User Input
	li $v0, 5
	syscall
	
	#Store The Input in t0 
   	 move $t0, $v0
		
	jr $ra 		#return 


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------

    
    
    
#################################################
############################################

QuickSort_list:

    jal cleanArrayFUNCTION    
# print "before : "
	li		$v0, 4
	la		$a0, msg_before
	syscall
# print Array
	jal		PRINT
	
# Call quick sort
	#la		$a0, Array
	la		$a0, letterArr															
	li		$a1, 0    
	# a2 = Array_size - 1
	#lw		$t0, Array_size 
	lw		$t0, itr 
	srl		$t0, $t0, 2													
	addi	$t0, $t0, -1
	move	$a2, $t0
	# function call
	jal		QUICK
	
# print "after : "
	li		$v0, 4
	la		$a0, msg_after
	syscall
# print Array
	jal		PRINT

	
# end program
	j main

PRINT:
## print Array
	#la		$s0, Array letterArr
	#lw		$t0, Array_size
	la		$s0, letterArr
	lw		$t0, itr
	srl		$t0, $t0, 2
Loop_main1:
	beq		$t0, $zero, Loop_main1_done
	# make space
	li		$v0, 4
	la		$a0, msg_space
	syscall
	# printing Array elements
	li		$v0, 11    			#change print from int to char -- Bassem
	lw		$a0, 0($s0)
	syscall
	
	addi	$t0, $t0, -1
	addi	$s0, $s0, 4
	
	j		Loop_main1
	
Loop_main1_done:
	# make new line
	li		$v0, 4
	la		$a0, msg_newL
	syscall
	jr		$ra

QUICK:
## quick sort

# store $s and $ra
	addi	$sp, $sp, -24	# Adjest sp
	sw		$s0, 0($sp)		# store s0
	sw		$s1, 4($sp)		# store s1
	sw		$s2, 8($sp)		# store s2
	sw		$a1, 12($sp)	# store a1
	sw		$a2, 16($sp)	# store a2
	sw		$ra, 20($sp)	# store ra

# set $s
	move	$s0, $a1		# l = left
	move	$s1, $a2		# r = right
	move	$s2, $a1		# p = left

# while (l < r)
Loop_quick1:
	bge		$s0, $s1, Loop_quick1_done
	
# while (arr[l] <= arr[p] && l < right)
Loop_quick1_1:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t0				# t0 =  l * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[l]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult	$s2, $t7
	mflo	$t1				# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[l] <= arr[p]
	bgt		$t0, $t1, Loop_quick1_1_done
	# check l < right
	bge		$s0, $a2, Loop_quick1_1_done
	# l++
	addi	$s0, $s0, 1
	j		Loop_quick1_1
	
Loop_quick1_1_done:

# while (arr[r] >= arr[p] && r > left)
Loop_quick1_2:
	li		$t7, 4			# t7 = 4
	# t0 = &arr[r]
	mult	$s1, $t7
	mflo	$t0				# t0 =  r * 4bit
	add		$t0, $t0, $a0	# t0 = &arr[r]
	lw		$t0, 0($t0)
	# t1 = &arr[p]
	mult	$s2, $t7
	mflo	$t1				# t1 =  p * 4bit
	add		$t1, $t1, $a0	# t1 = &arr[p]
	lw		$t1, 0($t1)
	# check arr[r] >= arr[p]
	blt		$t0, $t1, Loop_quick1_2_done
	# check r > left
	ble		$s1, $a1, Loop_quick1_2_done
	# r--
	addi	$s1, $s1, -1
	j		Loop_quick1_2
	
Loop_quick1_2_done:

# if (l >= r)
	blt		$s0, $s1, If_quick1_jump
# SWAP (arr[p], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[p]
	mult	$s2, $t7
	mflo	$t6				# t6 =  p * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[p]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6				# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
# quick(arr, left, r - 1)
	# set arguments
	move	$a2, $s1
	addi	$a2, $a2, -1	# a2 = r - 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# quick(arr, r + 1, right)
	# set arguments
	move	$a1, $s1
	addi	$a1, $a1, 1		# a1 = r + 1
	jal		QUICK
	# pop stack
	lw		$a1, 12($sp)	# load a1
	lw		$a2, 16($sp)	# load a2
	lw		$ra, 20($sp)	# load ra
	
# return
	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra

If_quick1_jump:

# SWAP (arr[l], arr[r])
	li		$t7, 4			# t7 = 4
	# t0 = &arr[l]
	mult	$s0, $t7
	mflo	$t6				# t6 =  l * 4bit
	add		$t0, $t6, $a0	# t0 = &arr[l]
	# t1 = &arr[r]
	mult	$s1, $t7
	mflo	$t6				# t6 =  r * 4bit
	add		$t1, $t6, $a0	# t1 = &arr[r]
	# Swap
	lw		$t2, 0($t0)
	lw		$t3, 0($t1)
	sw		$t3, 0($t0)
	sw		$t2, 0($t1)
	
	j		Loop_quick1
	
Loop_quick1_done:
	
# return

	lw		$s0, 0($sp)		# load s0
	lw		$s1, 4($sp)		# load s1
	lw		$s2, 8($sp)		# load s2
	addi	$sp, $sp, 24	# Adjest sp
	jr		$ra
            
##########################################################################################################
##########################################################################################################


BubbleSort:
	jal cleanArrayFUNCTION
	lw $t0, itr
	srl $t0, $t0, 2
	move $a0, $t0 	# set count arg
	la $a1, letterArr # load address of first points 
	jal sortInts



# count (int) of bytes in wordd
# address
printInts: 
	move $t0, $a0 		# save count to t0 so a0 can be used in syscall 
	li $v0, 11 		# set v0 1 for syscall 
	loop: 
		ble $t0, $zero, exit 	# check if count is 0 
		lw $a0, ($a1)		# get word at current address based on count 
		syscall 		# stdout word
		addi $a1, $a1, 4 	# increment word address by 4 bytes 
		subi  $t0, $t0, 1 	# decreament count by 1 
	j loop

# a0 length 
# a1 address to first value 
sortInts:
	li $t7, 0 		 	# swapped. 0 = true, 1 = false 
	swappedLoop:   
		move $t6, $a0 	 	# move count to t6 so it can be decremeanted
		subi $t6, $t6, 1 	# Decrement count by 1 since nTh byte is 4 * length - 1
		bgtz $t7, printInts 	# if swapped is false go to print ints
		li $t7, 1 		# set swapped to false
	loopCount:
	beq $t6, $zero, swappedLoop	# if count = 0, exit to while loop
	subi $t5, $t6, 1 		# t5 is t6- 1 to get length - 2 value
	mul $t0, $t6, 4 		# * 4 bytes to get distance from a1 
	mul $t1, $t5, 4 		# * 4 bytes to get (distance from a1) - 1 
	
	add $t2, $t0, $a1 		# add to a1 address to get actual address
	add $t3, $t1, $a1 		# value at t2 is now the count - 1 item of the list
	
	#arrP
	la $s0, arrP    	 # Load base address to arrP into $s0
	add $s2, $t0, $s0 		# add to a1 address to get actual address
	add $s3, $t1, $s0 		# value at t2 is now the count - 1 item of the list
	
	#arrI
	la $s4, arrI	    	 # Load base address to arrI into $s4
	add $s5, $t0, $s4 		# add to a1 address to get actual address
	add $s6, $t1, $s4 		# value at t2 is now the count - 1 item of the list
	
	
	 
	lw $t4, ($t2)			# load actual value at t2 address into t4 
	lw $t5, ($t3)			# load actual value at t3 address into t5
	
 
	
	
	blt $t4, $t5, swapPositions 	# branch if t2 is less than t3
	# fall through
	subi $t6, $t6, 1 		# decreament count
	j loopCount 			# return for loop
	
# t5 is the lesser value word
# t4 is the greate value word	
# t3 the lesser value address 
# t2 is the greater value address 
swapPositions: 
	sw  $t5, ($t2) 			# store the word value of t5 into the address of t2 
	sw  $t4, ($t3)			# store the word value of t4 into the address of t3
	
	#arrP
	lw $t4, ($s2)			# load actual value at t2 address into t4 
	lw $t5, ($s3)			# load actual value at t3 address into t5  
	sw $t5, ($s2) 			# store the word value of t5 into the address of t2 
	sw $t4, ($s3)			# store the word value of t4 into the address of t3
	
	#arrI
	lw $t4, ($s5)			# load actual value at t2 address into t4 
	lw $t5, ($s6)			# load actual value at t3 address into t5
	
	sw $t5, ($s5) 			# store the word value of t5 into the address of t2 
	sw $t4, ($s6)			# store the word value of t4 into the address of t3
	
	subi $t6, $t6, 1 		# decreament count
	li $t7, 0 			# set swapped to true
	j loopCount			# return to 4 loop


exit: 
	
	#jal BinarySearch
	#jr $ra									# Jump back to caller
	
######################################################################################
######################################################################################
######################################################################################

BinarySearch:

		#Ask For The Input 
		li $v0, 4
		la $a0, enterLetter
		syscall
		
		li $v0, 8
		la $a0, binarySearchRequest
		syscall
	
    
        # This code loads arguments into $a registers and calls the search routine.
        # Once we get back from sorting it prints the returned value and exits.
        #
        li $a0, 0      		 # left index value
		
		
		# size is right index value	
        lw $t0, itr  	
		srl $t0, $t0, 2		
		move $a1, $t0  
		
        la $a2, letterArr    	 # pass array's base address in $a2	
#------------------------------------------------------------------------------------------------------------------------------------------		
        lw $a3, binarySearchRequest	     		 # value to search for in array
#------------------------------------------------------------------------------------------------------------------------------------------
		
        # Args are all loaded into $a register -- time to jump to search procedure
        jal binary_search    
		
        # Now we're back, with the return value in $v0
        move $a0, $v0  		 # Move result into $a0 to print
        li $v0, 1
        syscall        		 # Print the result
		
		
		j main        
    
        
# PROCEDURE:  print_status
#  Prints a line of output that describes current search region.  
#  NOTE: This routine alters the $a register values.
#
# Inputs:
#  $a0  Low index of search region
#  $a1  High index of search region
# 
# Outputs:
#  None
        
print_status:
        addi $sp, $sp, -8   # Make room for two words on stack
        sw   $a0, 0($sp)    # Store initial $a0 value on stack
        sw   $a1, 4($sp)    # Store initial $a1 value on stack
		
        # Get on with the printing
        la $a0, str     # put address of str in $a0 for syscall
        li $v0, 4       # print string syscall #
        syscall         # print the bulk of the string
		
        lw $a0, 0($sp)  # bring $a0 (low) in from stack
        li $v0, 1       # print integer syscall #
        syscall
		
        la $a0, to      # put address of " to " string in $a0
        li $v0, 4       # print string syscall #
        syscall
		
        lw $a0, 4($sp)  # bring in $a1 (high) from stack, put in $a0
        li $v0, 1       # print integer syscall #
        syscall
		
        la $a0, endl    # put address of newline string in $a0
        li $v0, 4
        syscall
		
 #       lw $a0, 0($sp)	# reload caller's $a0
        addi $sp, $sp, 8
        jr $ra
        

# PROCEDURE:  binary_search
#  Searches for a specific value in an array using binary search.
#
# Inputs:
#  $a0  Index where search begins (inclusive)
#  $a1  Index where search ends (exclusive)
#  $a2  Base address of array
#  $a3  Value to search for
# 
# Outputs:
#  $v0  Contains the position within the array at which value occurs, or
#       where it *would* be located if it's not in the array currently.


binary_search:
        # Begin with stack management code here - 
        # Need to save $a0, $a1, and $ra because of call to print_status and need to return 
        # Also need to save s registers
        addi $sp, $sp, -28					# make room for 7 (changing arguments, return address, and former $s registers
        sw $s0, 12($sp)						# storing s registers out of the way of current procedure (MIPS convention)
        sw $s1, 16($sp)
        sw $s2, 20($sp)
        sw $s3, 24($sp)
		
		
        # Move arguments to s registers just in case other methods don't play nice with arguments
        move $s0, $a0
        move $s1, $a1
        move $s2, $a2
        move $s3, $a3			
        sw $s0, 0($sp)						# save a copy of $a0 (low index value)
        sw $s1, 4($sp)						# save a copy of $a1 (high index value)
        sw $ra, 8($sp)						# save a copy of $ra  

		
        # Body			
        jal print_status					# $a0 and $a1 registers should be in place
        addi $t0, $s0, 1					# $t0 = low + 1
        beq  $t0, $s1, end_search			# if low+1 == high, end the search
		
        # else...		
        add $s4, $s0, $s1					# $s4 = low + high (s4 is mid)
        srl $s4, $s4, 1						# $s4 = low + high / 2 (shift is needed to lose the remainder)
        sll $t0, $s4, 2						# $t0 = mid * 4 (multiply mid by 4 for the proper address)
        add $t0, $t0, $s2					# $t0 = nums + (mid * 4) --> $t0 is address of nums[mid]
        lw $t1, 0($t0)						# $t1 = nums[mid]
        slt $t0, $s3, $t1					# if (value < nums[mid] $t0 = 1; otherwise it equals 0
        beq $t0, $zero, right_half			# jump to searching the right half if we need to search that half   
		
        # binSearch(low, mid, nums, value) - search left half
        move $a1, $s4						# put $s0 (mid) in $a1 (replace high bound) to prepare for call
        move $a0, $s0						# make sure we have the right argument for the low bound
        jal binary_search					# call binary_search with new arguments
        move $a1, $s1						# Restore only caller's former $a1 value when changed
       	j return							# jump to the stack-tidying code

		
right_half:
	# binSearch(mid, high, nums, value) - search right half
	move $a0, $s4							# put $s0 (mid) in $a0 (replace low bound; no need to update high bound)
	jal binary_search						# call binary search with new arguments
	move $a0, $s0							# Restore only caller's $a0 value when changed
	j return								# jump to the stack-tidying code
	
	
end_search:				
        move $v0, $s0						# $v0 = low (only passed once)
        sll $v0, $v0, 2
		lw $v0, arrI($v0)
		
		
		
return:       								# Stack-tidying code here - only what is needed here.
	lw $s0, 12($sp)							# loading s registers (MIPS convention)
	lw $s1, 16($sp)				
	lw $s2, 20($sp)				
	lw $s3, 24($sp)				
	lw $ra, 8($sp)							# Restore $ra to get home
	addi $sp, $sp, 28
	
	
		
	jr $ra									# Jump back to caller     