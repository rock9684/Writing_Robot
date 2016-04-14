/*
* This function takes in a number and display it on the seven segment display
*
* Note, that the number stored in the register is in hexadecimal
* Convert the thing to decimal and find its corresponding 7-seg configuration 
*
* Dealing with the device is an easy thing, mostly the algorithm convert hex to decimal
*/


.equ SEVEN_SEGMENT_DISPLAY, 0xFF200020
.global HEX_TO_SEVEN_SEGMENT_DISPLAY


HEX_TO_SEVEN_SEGMENT_DISPLAY:
	addi sp, sp, -4
	stw ra, 0(sp)

	movia r7, SEVEN_SEGMENT_DISPLAY
	
	mov r11, r4    #A temporary variable to store the value
	#Find 1s and store the thing into r8
	#Recursively substract 10 from the original input
GET_ONES:
	subi r11, r11, 10
	bge r11, r0, GET_ONES
	#add 16 and store the value to r8
	addi r11, r11, 10
	mov r8, r11			#ones digit get its value
	
	
	mov r11, r4		#Restore the value in r11
	#Find 10s and store the thing into r9
	#Recursively subtract 100 from the original input. At the end of it substract the ones
GET_TENS:
	subi r11, r11, 100
	bge r11, r0, GET_TENS
	addi r11, r11, 100
	sub r11, r11, r8
	movi r12, 10
	div r9, r11, r12  #tens digit get its value
	
	
	mov r11, r4		#Restore the value in r11
	#Find 100s and store the thing into r10
GET_HUNDREDS:
	subi r11, r11, 1000
	bge r11, r0, GET_HUNDREDS
	addi r11, r11, 1000
	sub r11, r11, r8
	movi r12, 10
	mul r12, r9, r12
	sub r11, r11, r12
	movi r12, 100
	div r10, r11, r12 #hundreds digit get its value
	
	mov r11, r4
GET_THOUSANDS:
	subi r11, r11, 10000
	bge r11, r0, GET_THOUSANDS
	addi r11, r11, 10000
	sub r11, r11, r8
	movi r12, 10
	mul r12, r9, r12
	sub r11, r11, r12
	movi r12, 100
	mul r12, r10, r12
	sub r11, r11, r12
	movi r12, 1000
	div r11, r11, r12
	
	#Use a look-up table, combine three numbers
	#the original value won't be used in this function anymore
	mov r5, r8
	call HEX_TO_SEVEN_SEGMENT_LOOK_UP
	mov r8, r2
	
	mov r5, r9
	call HEX_TO_SEVEN_SEGMENT_LOOK_UP
	mov r9, r2
	
	mov r5, r10
	call HEX_TO_SEVEN_SEGMENT_LOOK_UP
	mov r10, r2
	
	mov r5, r11
	call HEX_TO_SEVEN_SEGMENT_LOOK_UP
	mov r11, r2
	
	#Combine three values by using logic shift and 
	slli r11, r11, 24
	slli r10, r10, 16
	slli r9, r9, 8
	or r8, r8, r9
	or r8, r8, r10
	or r8, r8, r11
	
	
	
	#Directly load the value to the HEX display
	stwio r8, 0(r7)
	
	ldw ra, 0(sp)
	addi sp, sp, 4
	ret
	

/*
* Takes in the number in r5
* Return its 7-segment display configuration in r2 
*/
#The display configuration is guaranteed to be correct, tested.
HEX_TO_SEVEN_SEGMENT_LOOK_UP:
	
	#Goes to its dedicated branch
	#Set up the configuration to r2
	movui r16, 0
	beq r5, r16, ZERO_DISPLAY
	movui r16, 1
	beq r5, r16, ONE_DISPLAY
	movui r16, 2
	beq r5, r16, TWO_DISPLAY
	movui r16, 3
	beq r5, r16, THREE_DISPLAY
	movui r16, 4
	beq r5, r16, FOUR_DISPLAY
	movui r16, 5
	beq r5, r16, FIVE_DISPLAY
	movui r16, 6
	beq r5, r16, SIX_DISPLAY
	movui r16, 7
	beq r5, r16, SEVEN_DISPLAY
	movui r16, 8
	beq r5, r16, EIGHT_DISPLAY
	movui r16, 9
	beq r5, r16, NINE_DISPLAY
	
	#Based on its case, assign different value
ZERO_DISPLAY:
	movia r2, 0x0000003F
	ret
ONE_DISPLAY:
	movia r2, 0x00000006
	ret
TWO_DISPLAY:
	movia r2, 0x0000005B
	ret
THREE_DISPLAY:
	movia r2, 0x0000004F
	ret
FOUR_DISPLAY:
	movia r2, 0x00000066
	ret
FIVE_DISPLAY:
	movia r2, 0x0000006D
	ret
SIX_DISPLAY:
	movia r2, 0x0000007D
	ret
SEVEN_DISPLAY:
	movia r2, 0x00000007
	ret
EIGHT_DISPLAY:
	movia r2, 0x0000007F
	ret
NINE_DISPLAY:
	movia r2, 0x0000006F
	ret
	