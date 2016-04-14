/*
* Based on the assumption:
*     CAR_TURN turns right 90 degree while the center remains the same
*     CAR_GO_STRAIGHT goes forward approximately 2 cm
*     At the start of each digit drawing, always start at top left
*     At the start of each digit drawing, the car is facing horizontally right
*
* After each digit drawn, return to the top left corner
*
* For each function. Takes in no parameter and returns nothing.
* There might be a lot of fixing for these functions. For example
*     redrawing the same segments may not be allowed
*     turning while the pen is down on the paper is not allowed
*/
.global DRAW_ZERO
.global DRAW_ONE
.global DRAW_TWO
.global DRAW_THREE
.global DRAW_FOUR

#Draw digit one in HEX display style
DRAW_ZERO:
    #Save all callee-saved registers
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

    #Do I really need to use caller-saved registers?
    #There are no parmeters to pass into the car movement control functions

    call PEN_DOWN:

    call CAR_GO_STRAIGHT            #segment 0
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 1
    call CAR_GO_STRAIGHT            #segment 2
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 3
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 4
    call CAR_GO_STRAIGHT            #segment 5
    call CAR_TURN

    #call PEN_UP

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

#Draw digit one in HEX display style
DRAW_ONE:
    #Save all callee-saved registers
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

    #Do I really need to use caller-saved registers?
    #There are no parmeters to pass into the car movement control functions

    call CAR_GO_STRAIGHT
    call CAR_TURN

    #call PEN_DOWN

    call CAR_GO_STRAIGHT            #segment 1
    call CAR_GO_STRAIGHT            #segment 2

    #call PEN_UP

    call CAR_TURN
    call CAR_GO_STRAIGHT
    call CAR_TURN
    call CAR_GO_STRAIGHT
    call CAR_GO_STRAIGHT
    call CAR_TURN

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

#Draw digit 2 in HEX display style
DRAW_TWO:
    #Save all callee-saved registers
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

    #Do I really need to use caller-saved registers?
    #There are no parmeters to pass into the car movement control functions

     #call PEN_DOWN

    call CAR_GO_STRAIGHT            #segment 0
    call CAR_TURN

    call CAR_GO_STRAIGHT            #segment 1
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 6
    call CAR_TURN
    call CAR_TURN
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 4
    call CAR_TURN
    call CAR_TURN
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 3
     #call PEN_UP
	 
	 
	 call CAR_TURN						#Reset back to the original point
	 call CAR_TURN
	 call CAR_GO_STRAIGHT
	 call CAR_TURN	 
	 call CAR_GO_STRAIGHT
	 call CAR_GO_STRAIGHT
	 call CAR_TURN	 


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

#Draw digit 3 in HEX display style
DRAW_THREE:
    #Save all callee-saved registers
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

    #Do I really need to use caller-saved registers?
    #There are no parmeters to pass into the car movement control functions

     #call PEN_DOWN

    call CAR_GO_STRAIGHT            #segment 0
    call CAR_TURN

    call CAR_GO_STRAIGHT            #segment 1
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 6
    call CAR_TURN
    call CAR_TURN
    call CAR_GO_STRAIGHT            #redraw segment 6
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 2
    call CAR_TURN
    call CAR_GO_STRAIGHT            #segment 3
     #call PEN_UP

    call CAR_TURN
    call CAR_GO_STRAIGHT
    call CAR_GO_STRAIGHT
    call CAR_TURN


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

