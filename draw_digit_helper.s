/*
* Based on the assumption:
*     CAR_TURN turns right 90 degree while the center remains the same
*     CAR_GO_STRAIGHT goes forward approximately 2 cm
* After each digit drawn, return to the top left corner
*/

/*
* Helper functions that controls the pen up and down.
* Using one motor and uses its traction to control the pen
*
* Both functions take in nothing and have nothing to return
* The implementation of mechanical devices may have an affect on the polarity
*/

.global PEN_UP
.global PEN_DOWN

.equ LEGOMOTOR, 0xFF200060
.equ PEN_MOVEMENT, 5

PEN_UP:
    #Save return address
    #Save return address and callee-saved registers (r16-r23)
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
	
	#Set two motors to go forward
	#Use caller-saved registers
	movia r8, LEGOMOTOR
	#enable motor 0 and motor 1
	movia r9, 0x07F556FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0XFFFFFFEF	#Enable motor 2. Opposite direction compared to PEN_DOWN
	stwio r9, 0(r8)

	#Call HAULT_TIME_PEN to hold for some time	
	#Save caller-saved registers and push the value to r4 as parameter
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, PEN_MOVEMENT
	call HAULT_TIME_PEN
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	#Possibly let the motor to cool down for a bit?	
	
	#Restore callee-saved registers and return address
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

PEN_DOWN:
    #Save return address
    #Save return address and callee-saved registers (r16-r23)
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
	
	#Set two motors to go forward
	#Use caller-saved registers
	movia r8, LEGOMOTOR
	#enable motor 0 and motor 1
	movia r9, 0x07F556FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0XFFFFFFCF	#Enable motor 2. The direction really depends on the assemblation of the car
	stwio r9, 0(r8)

	#Call HAULT_TIME_PEN to hold for some time	
	#Save caller-saved registers and push the value to r4 as parameter
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, PEN_MOVEMENT
	call HAULT_TIME_PEN
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	#Possibly let the motor to cool down for a bit?	
	
	#Restore callee-saved registers and return address
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
	
HAULT_TIME_PEN:
	#Only use caller-saved registers r8-r15
	movia r8, 0xFF202000
	movui r10, %lo(PEN_MOVEMENT)	#Set clock cycles
	stwio r10, 8(r8)
	movui r10, %hi(PEN_MOVEMENT)
	stwio r10, 12(r8)
	movui r10, 4
	stwio r10, 4(r8)

TIMER_LOOP_PEN:
	ldwio r11, 0(r8)
	andi r11, r11, 0x1
	beq r0, r11, TIMER_LOOP_PEN
	stwio r0, 0(r8)
	
	ret