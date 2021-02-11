#----------------------------------------------------------------------------------------
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
	
	prompt: .asciiz  "\n\nEnter up to 10 characters: "  # Prompt asking for user input
	newLine: .asciiz "\n"                               # Newline character

	#main variables
	LIST_SIZE:			.word 20
	NUMBER_OF_LISTS:	.word 4
	nextEmptyArrIndex: 	.word 0
	lastUpdatedIndex: 	.word -1
	list: 				.word 0
	indexInList: 		.word 0
	ListChoice: 		.word 0
	requestPriority:	.word 0
	requestSize: 		.word 0
	del_priority: 		.word 0
	search_priority: 	.word 0
	pr: 				.word 0
	listScan: 			.word 0
	ch: 				.word 0
	itr:				.word 0
		
        
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
		beq    		$t0, 5, BinarySearch_By_Request 
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


per_post_binarySearch:

binarySearch:

BinarySearch_By_Request:	
			j bubbleSort

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

QuickSort_list:

	jal cleanArrayFUNCTION
	
	la $t0, letterArr 		# Moves the address of array into register $t0.
		  
        addi $a0, $t0, 0 	# Set argument 1 to the array.
        addi $a1, $zero, 0 	# Set argument 2 to (low = 0)
        lw $t6, itr			# itr carries the index of the last element
       
		
		
		
		addi $t7, $t6, -4 	# Set argument 3 to (high = itr - 1, last index in array)
        div $a2, $t7, 4		# $t7 = itr - 1 (logical number - not in bytes)
        #addi $a2, $zero, 7 	# Set argument 3 to (high = 7, last index in array)
	  
       


		jal quicksort
        addi $t2, $zero, 0
        addi $t1, $zero, 0
        lw $t6, itr
        div $t6, $t6, 4		# $t6 = itr	(logical number - not in bytes)
          
        while:
             bge $t1, $t6, exit     #replace 8 with itr
             #bge $t1, 8, exit     #replace 8 with itr
             lw $t0, letterArr($t2)
             li $v0, 11
             move $a0, $t0
             syscall
             li $v0, 4
             la $a0, space
             syscall
             addi $t2, $t2, 4
             addi $t1, $t1, 1
             j while  
           
        exit: 
             #li $v0, 10 
             #syscall

	j main

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
	
pre_post_QuickSort:

swap:				

	  addi $sp, $sp, -12	# Make stack room for three

	  sw $a0, 0($sp)		# Store a0
	  sw $a1, 4($sp)		# Store a1
	  sw $a2, 8($sp)		# store a2
	
	  sll $t1, $a1, 2 		#t1 = 4a
	  add $t1, $a0, $t1		#t1 = arr + 4a
	  lw $s3, 0($t1)		#s3  t = array[a]

	  sll $t2, $a2, 2		#t2 = 4b
	  add $t2, $a0, $t2		#t2 = arr + 4b
	  lw $s4, 0($t2)		#s4 = arr[b]

	  sw $s4, 0($t1)		#arr[a] = arr[b]
	  sw $s3, 0($t2)		#arr[b] = t 


	  addi $sp, $sp, 12	#Restoring the stack size
	  jr $ra			#jump back to the caller
	


partition: 				#partition method

	addi $sp, $sp, -16	#Make room for 5

	sw $a0, 0($sp)		#store a0
	sw $a1, 4($sp)		#store a1
	sw $a2, 8($sp)		#store a2
	sw $ra, 12($sp)		#store return address
	
	move $s1, $a1		#s1 = low
	move $s2, $a2		#s2 = high

	sll $t1, $s2, 2		# t1 = 4*high
	add $t1, $a0, $t1	# t1 = arr + 4*high
	lw $t2, 0($t1)		# t2 = arr[high] //pivot

	addi $t3, $s1, -1 	#t3, i=low -1
	move $t4, $s1		#t4, j=low
	addi $t5, $s2, -1	#t5 = high - 1

	forloop: 
		slt $t6, $t5, $t4			#t6=1 if j>high-1, t7=0 if j<=high-1
		bne $t6, $zero, endfor		#if t6=1 then branch to endfor

		sll $t1, $t4, 2				#t1 = j*4
		add $t1, $t1, $a0			#t1 = arr + 4j
		lw $t7, 0($t1)				#t7 = arr[j]

		slt $t8, $t2, $t7			#t8 = 1 if pivot < arr[j], 0 if arr[j]<=pivot
		bne $t8, $zero, endfif		#if t8=1 then branch to endfif
		addi $t3, $t3, 1			#i=i+1
	
		move $a1, $t3				#a1 = i
		move $a2, $t4				#a2 = j
		jal swap					#swap(arr, i, j)
		
		addi $t4, $t4, 1			#j++
		j forloop

	    endfif:
		addi $t4, $t4, 1		#j++
		j forloop				#junp back to forloop

	endfor:
		addi $a1, $t3, 1		#a1 = i+1
		move $a2, $s2			#a2 = high
		add $v0, $zero, $a1		#v0 = i+1 return (i + 1);
		jal swap				#swap(arr, i + 1, high);

		lw $ra, 12($sp)			#return address
		addi $sp, $sp, 16		#restore the stack
		jr $ra				#junp back to the caller

quicksort:					#quicksort method

	addi $sp, $sp, -16		# Make room for 4

	sw $a0, 0($sp)			# a0
	sw $a1, 4($sp)			# low
	sw $a2, 8($sp)			# high
	sw $ra, 12($sp)			# return address

	move $t0, $a2			#saving high in t0

	slt $t1, $a1, $t0		# t1=1 if low < high, else 0
	beq $t1, $zero, endif	# if low >= high, endif

	jal partition			# call partition 
	move $s0, $v0			# pivot, s0= v0

	lw $a1, 4($sp)			#a1 = low
	addi $a2, $s0, -1		#a2 = pi -1
	jal quicksort			#call quicksort

	addi $a1, $s0, 1		#a1 = pi + 1
	lw $a2, 8($sp)			#a2 = high
	jal quicksort			#call quicksort

 endif:

 	lw $a0, 0($sp)			#restore a0
 	lw $a1, 4($sp)			#restore a1
 	lw $a2, 8($sp)			#restore a2
 	lw $ra, 12($sp)			#restore return address
 	addi $sp, $sp, 16		#restore the stack
 	jr $ra				    #return to caller
	



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










bubbleSort:

	jal cleanArrayFUNCTION

################################################################################################################
#####   Procedure: Main
#####   Info:      Asks user for input, gets input, and then call 
#####              procedures to manipulate the input and output.
################################################################################################################

    #############################################
    #  Read User Input into address of theString
    #############################################
	
    #la $a0,theString  # Load address of theString into syscall argument a0 
    la $a0,letterArr  # Load address of letterArr into syscall argument a0 #bassem
	

    ##############################
    #  Define total num of chars
    ##############################
	
    #li $s7,10           # s7 upper index
    lw  $t1, itr
	
	addi $t1, $t1, -8 	# Set argument 3 to (high = itr - 1, last index in array)
    div $t1, $t1, 4		# $t1 = itr - 1 (logical number - not in bytes)
    add $s7, $zero, $t1            # s7 upper index #bassem

    ##############################
    #  Call procedures 
    ##############################
    
    #jal uppercase  
    jal sort
    jal print
	
	
    j main
################################################################################################################
############################################# main END   #######################################################
################################################################################################################


################################################################################################################
#####   Procedure: uppercase
#####   Info:      Loops through the ten elements of chars gathered from 
#####              user input and if ascii is in range between 97  
#####              and 122, it will subtract 32 and store back
################################################################################################################
uppercase:

    #la $s0, theString    # Load base address to theString into $t0
   #la $s0, letterArr    # Load base address to letterArr into $t0
    add $t6,$zero,$zero  # Set index i = 0 ($t6)



    lupper:
        #####################################
        #  Check for sentinal val and if true
        #  branch to done to jump back to ra
        #####################################
        beq $t6,$s7,done 



        #####################################
        #  Load Array[i]
        #####################################
        add $s2,$s0,$t6 
        lb  $t1,0($s2)

        isUpper:
        #####################################
        #  increment and Jump back 
        #####################################
        addi $t6,$t6,1
		
		
        j lupper
		
		
		
################################################################################################################
############################################# uppercase END   ##################################################
################################################################################################################

#s7 size of array
#t0 i = 0
#t7 ( 10 - i - 1 ) 


################################################################################################################
#####   Procedure: sort
#####   Info:      Bubble sorts whatever is contained within 
#####              theString based on ascii values
################################################################################################################
sort:   

    ####################################
    #  Initialize incrementer for outer
    #  loop
    ####################################
    add $t0,$zero,$zero 

    ####################################
    #  Outer Loop
    #################################### 
    loop:
        #####################################
        #  Check for sentinal val and if true
        #  branch to done
        #####################################
        beq $t0,$s7,done

        ####################################
        #  Initialize upper bound of inner
        #  loop ( 10 - i - 1 ) 
        ####################################
        sub $t7,$s7,$t0
        addi $t7,$t7,-1

        ####################################
        #  Initialize incrementer for inner
        #  loop
        ####################################
        add $t1,$zero,$zero    
		
		
		
	####################################
        #  Initialize incrementer for
        #  array_index
        ####################################
        move $t3,$zero 

        ####################################
        #  Inner Loop
        #################################### 
        jLoop:
            #####################################
            #  Check for sentinal val and if true
            #  branch to continue
            #####################################
            beq $t1,$t7,continue

            ####################################
            #  Load Array[i] and Array[i+1]
            ####################################
			la $s0, letterArr    # Load base address to letterArr into $t0
            add $t6,$s0,$t3
			
			la $s0, arrI    	 # Load base address to letterArr into $t0
            add $t7,$s0,$t3
			
			la $s0, arrP    	 # Load base address to letterArr into $t0
            add $t8,$s0,$t3
			
			
            lw  $s1,0($t6)
            lw  $s2,4($t6)
			
			lw  $s3,0($t7)
            lw  $s4,4($t7) 
			
			lw  $s5,0($t8)
            lw  $s6,4($t8)

            #########################################
            #  If ascii(Array[i]) > ascii(Array[i+1])
            #  then swap and store
            #########################################
            sgt $t2, $s1,$s2
            #########################################
            #  Else,  don't swap and store
            #########################################
            beq $t2, $zero, NoSwap
            sw  $s2,0($t6)
            sw  $s1,4($t6)
		
			sw  $s4,0($t7)
            sw  $s3,4($t7)
			
			sw  $s6,0($t8)
            sw  $s5,4($t8)
		
		
            NoSwap:
            #########################################
            #  increment and Jump back 
            #########################################
            addi $t1,$t1,1
            addi $t3,$t3,4
            j jLoop

        continue:
        #####################################
        #  increment and Jump back 
        #####################################
        addi $t0,$t0,1
        j loop
################################################################################################################
############################################# sort END   #######################################################
################################################################################################################




################################################################################################################
#####   Procedure: Print
#####   Info:      Prints whatever is stored inside theString
#####              
################################################################################################################
print:

    ####################################
    # Print a new line
    ####################################
    la $a0,newLine
    li $v0,4
    syscall 

    ####################################
    #  Initialize incrementer for loop
    ####################################
    add $t6,$zero,$zero # Set index i = 0 $t6

    lprint:
        #####################################
        #  Check for sentinal val and if true
        #  branch to done
        #####################################
        beq $t6,$s7,done  

        ####################################
        #  Load Array[i] into t1 and print
        ####################################
        add $t1,$s0,$t6 
        lb $a0, 0($t1)  # Load argument
        li $v0, 11      # Load opcode
        syscall         # Call syscall

        #########################################
        #  increment and Jump back 
        #########################################
        addi $t6,$t6,1  
        j lprint
################################################################################################################
############################################# print END   ######################################################
################################################################################################################


################################################################################################################    
#####  Procedure: done
#####       Info: Jumps to $ra. Only one procedure is needed to jump back to ra
################################################################################################################

done:
    jr $ra
