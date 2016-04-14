/*
* Function constantly prints the given character (in ASCII code) to terminal
* start from the a pointer to the stack printing until the stack pointer
*/

.equ JTAG_TRANSMITTER, 0xFF201000
.global PRINT_INPUT

PRINT_INPUT:
    #save callee-saved registers (r16 - r23)
	mov r15, sp
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
    
    movia r8, JTAG_TRANSMITTER

WAIT_MOVE_RESET_1:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_RESET_1
    movi r10, 0x1b
    stwio r10, 0(r8)
WAIT_MOVE_RESET_2:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_RESET_2
    movi r10, 0x5b
    stwio r10, 0(r8)
WAIT_MOVE_RESET_3:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_RESET_3
    movi r10, 0x48
    stwio r10, 0(r8)
	
    #first thing to do, clear the line that is previously displayed on the terminal
    # esc [ 2 K   Erase a whole line corresponding ascii code 27 91 50 75
WAIT_ERASE_1:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_ERASE_1
    movi r10, 0x1b
    stwio r10, 0(r8)
WAIT_ERASE_2:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_ERASE_2
    movi r10, 0x5b
    stwio r10, 0(r8)
WAIT_ERASE_3:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_ERASE_3
    movi r10, 0x32
    stwio r10, 0(r8)
WAIT_ERASE_4:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_ERASE_4
    movi r10, 0x4b
    stwio r10, 0(r8)
    
    # esc [ H     Move the cursor to home position
    # Loop for polling for availability to write 
WAIT_MOVE_CUR_1:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_CUR_1
    movi r10, 0x1b
    stwio r10, 0(r8)
WAIT_MOVE_CUR_2:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_CUR_2
    movi r10, 0x5b
    stwio r10, 0(r8)
WAIT_MOVE_CUR_3:
    ldwio r9, 4(r8)
    srli r9, r9, 16
    beq r9, r0, WAIT_MOVE_CUR_3
    movi r10, 0x48
    stwio r10, 0(r8)
    
    #After clearing the line and resetting the cursor, print the character
    #stored on the stack
    
    mov r9, r4                  #the starting place on stack. stack tracker
KEEP_PRINT:
    subi r9, r9, 4
PRINT_WAIT:
    ldwio r10, 4(r8)
    srli r10, r10, 16
    beq r10, r0, PRINT_WAIT
    ldb r11, 0(r9)              #temp value to be printed, copied from the stack
    stwio r11, 0(r8)
    bne r15, r9, KEEP_PRINT
    
RESTORE_REG_JTAG:
    #restore callee-saved registers
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