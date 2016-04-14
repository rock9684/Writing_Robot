.global CAR_TURN_RIGHT
.global CAR_TURN_LEFT
.global CAR_GO_STRAIGHT
.global CAR_GO_BACK

/*
* Implement basic car movements
* 
* Going straight for one unit length
* Turn 90 degree
*/

#Motion parameters
.equ GOSTRAIGHT, 5000000
.equ TURNRIGHT, 33000000
.equ COOLDOWN, 100000000

#Device parameters
.equ TIMERBASE, 0xFF202000
.equ LEGOMOTOR, 0xFF200060

/*
* Enables the car to move on for a certain of clock cycles
* So that the car can go straight for a certain length of time
*
* Takes in nothing. Return nothing.
*/
CAR_GO_STRAIGHT:
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
	movia r9, 0x07F557FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0xFFFFFFF0	#Enable motor 0 and motor 1, with same direction
	stwio r9, 0(r8)

	#Call TIMER_HAULT to hold for some time	
	#Save caller-saved registers and push the value to r4 as parameter
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, GOSTRAIGHT
	call TIMER_HAULT
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	#Possibly let the motor to cool down for a bit?	
	movia r9, 0x07F557FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0xFFFFFFFF	#Disable both motors
	stwio r9, 0(r8)
	
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, GOSTRAIGHT
	call HAULT_TIME_CD
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	
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

/*
* Let the car to turn a 90 degree (direction based on its physical connection)
* No parameters Return nothing
*/
CAR_TURN:
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
	movia r9, 0x07F557FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0xFFFFFFF8	#Enable motor 0 and motor 1, with opposite direction
	stwio r9, 0(r8)

	#Call TIMER_HAULT to hold for some time	
	#Save caller-saved registers and push the value to r4 as parameter
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, TURNRIGHT
	call TIMER_HAULT_TURN
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	#Possibly let the motor to cool down for a bit?	
	movia r9, 0x07F557FF	#Set direction for motors to all output (I don't understand this)
	stwio r9, 4(r8)
	movia r9, 0XFFFFFFFF	#Disable both motors
	stwio r9, 0(r8)
	
	#Hold it for a little bit to cool down the motor
	addi sp, sp, -8
	stw r8, 0(sp)
	stw r9, 4(sp)
	movia r4, TURNRIGHT
	call HAULT_TIME_CD
	ldw r8, 0(sp)
	ldw r9, 4(sp)
	addi sp, sp, 8
	
	
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




/*
* Helper functions using clock
* Holds for a certain amount of time and then return back to the caller
* The length will be held in r4
*/
TIMER_HAULT:
	#Only use caller-saved registers r8-r15
	movia r8, 0xFF202000
	movui r10, %lo(GOSTRAIGHT)	#Set clock cycles
	stwio r10, 8(r8)
	movui r10, %hi(GOSTRAIGHT)
	stwio r10, 12(r8)
	movui r10, 4
	stwio r10, 4(r8)

TIMER_LOOP:
	ldwio r11, 0(r8)
	andi r11, r11, 0x1
	beq r0, r11, TIMER_LOOP
	stwio r0, 0(r8)
	
	ret
	
TIMER_HAULT_TURN:
	#Only use caller-saved registers r8-r15
	movia r8, 0xFF202000
	movui r10, %lo(TURNRIGHT)	#Set clock cycles
	stwio r10, 8(r8)
	movui r10, %hi(TURNRIGHT)
	stwio r10, 12(r8)
	movui r10, 4
	stwio r10, 4(r8)

TIMER_LOOP_TURN:
	ldwio r11, 0(r8)
	andi r11, r11, 0x1
	beq r0, r11, TIMER_LOOP_TURN
	stwio r0, 0(r8)
	
	ret

#for each segment of movement, hold for 1 second to let the car become steady
HAULT_TIME_CD:
	#Only use caller-saved registers r8-r15
	movia r8, 0xFF202000
	movui r10, %lo(COOLDOWN)	#Set clock cycles
	stwio r10, 8(r8)
	movui r10, %hi(COOLDOWN)
	stwio r10, 12(r8)
	movui r10, 4
	stwio r10, 4(r8)

TIMER_LOOP_CD:
	ldwio r11, 0(r8)
	andi r11, r11, 0x1
	beq r0, r11, TIMER_LOOP_CD
	stwio r0, 0(r8)
	
	ret
	
	

