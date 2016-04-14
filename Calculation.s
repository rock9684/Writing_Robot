/*
* This function is used after prompting the input from the user
* 
* Given two numbers (stored in r4 and r5) and a signal (stored in r6) 
* that indicates which arithmetic to use
* The program calcualtes the result and return the value in r2
*/

.global CALCULATION
CALCULATION:
    #save callee-saved registers (r16 - r23)
    addi sp, sp, -36
    stw ra, 0(sp)
    stw r16, 4(sp)
    stw r17, 8(sp)
    stw r18, 12(sp)
    stw r19, 16(sp)
    stw r20, 20(sp)
    stw r21, 24(sp)
    stw r22, 28(sp)
    stw r23, 32(sp)
    
    #only use caller-saved registers
    #based on the signal go to the dedicated branch
    movi r8, 0
    beq r6, r8, ADDITION
    movi r8, 1
    beq r6, r8, SUBTRACTION
    movi r8, 2
    beq r6, r8, MULTIPLICATION
    movi r8, 3
    beq r6, r8, DIVISION
	movi r8, 4
    beq r6, r8, POWER
    
DONE_CALCULATION:
   
    #restore callee-saved registers and return address
    ldw ra, 0(sp)
    ldw r16, 4(sp)
    ldw r17, 8(sp)
    ldw r18, 12(sp)
    ldw r19, 16(sp)
    ldw r20, 20(sp)
    ldw r21, 24(sp)
    ldw r22, 28(sp)
    ldw r23, 32(sp) 
    addi sp, sp, 36
    ret
    
ADDITION:
    add r2, r4, r5
    br DONE_CALCULATION
SUBTRACTION:
    sub r2, r4, r5
    br DONE_CALCULATION
MULTIPLICATION:
    mul r2, r4, r5
    br DONE_CALCULATION
DIVISION:
    div r2, r4, r5          #Verified this would work
    br DONE_CALCULATION
POWER:
	movi r2, 1
	mov r16, r5
POWER2:
	subi r16, r16, 1
    mul r2, r2, r4
	bne r16, r0, POWER2
    br DONE_CALCULATION