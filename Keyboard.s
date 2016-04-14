.equ PS2_PORT, 0xFF200100  #PS/2 port address
.equ Timer, 0xFF202000     #Timer address
.equ ADDR_PUSHBUTTONS, 0XFF200050

.section .exceptions, "ax"
HANDLER:
rdctl et, ctl4
srli et, et, 1
andi et, et, 1
beq et, r0, EXIT

BUTTONHANDLER:
subi sp, sp, 4
stw r7, 0(sp)
movia r7, ADDR_PUSHBUTTONS
movi r15, -1
stwio r15, 12(r7)
ldw r7, 0(sp)
addi sp, sp, 4
br EXIT


EXIT:
subi ea, ea, 4
eret

.global _start

_start:
	movia r7, ADDR_PUSHBUTTONS
	stwio r0, 12(r7)
	movia r8, 2
	stwio r8, 8(r7)
	wrctl ctl3, r8
	movia r8, 1
	wrctl ctl0, r8

	movia r7, PS2_PORT  # r7 is now the base address of ps/2 port

	movia sp, 0x00114710   #Initialize sp

	mov r8, sp   #Store the value of sp in order to restore everything later

	movia r13, Timer
#Read from keyboard

read_loop:
	call count_threshold
	ldwio r9, 0(r7)
	andi r12, r9, 0xff
	movia r11, 0xffff0000
	and r9, r9, r11      #Store the 31:8 bits

	bgt r9, r0, read	     #When there is something waiting to be read

	br read_loop


#Start to read

read:
#The following 10 cases are corresponding to different number keys
movi r11, 0x45
beq r12, r11, read0

movi r11, 0x16
beq r12, r11, read1

movi r11, 0x1E
beq r12, r11, read2

movi r11, 0x26
beq r12, r11, read3

movi r11, 0x25
beq r12, r11, read4

movi r11, 0x2E
beq r12, r11, read5

movi r11, 0x36
beq r12, r11, read6

movi r11, 0x3D
beq r12, r11, read7

movi r11, 0x3E
beq r12, r11, read8

movi r11, 0x46
beq r12, r11, read9


#When left shift is pressed
movi r11, 0x12
beq r12, r11, readShift


#When “-” or “/” is pressed
movi r11, 0x4E
beq r12, r11, readMin
movi r11, 0x4A
beq r12, r11, readDiv


#Throw out the break code
movi r11, 0xF0
beq r12, r11, throwOut



#When enter is pressed
movi r11, 0x5A
beq r12, r11, readEnter










#0 is pressed

read0:

movi r10, 0x30  #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#1 is pressed

read1:

movi r10, 0x31 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#2 is pressed

read2:

movi r10, 0x32 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#3 is pressed

read3:

movi r10, 0x33 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#4 is pressed

read4:

movi r10, 0x34 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#5 is pressed

read5:

movi r10, 0x35 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#6 is pressed

read6:

movi r10, 0x36 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#7 is pressed

read7:

movi r10, 0x37 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#8 is pressed

read8:

movi r10, 0x38 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop



#9 is pressed

read9:

movi r10, 0x39 #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




#Left shift is pressed

readShift:

#Read the next

ldwio r9, 0(r7)

andi r9, r9, 0xff



#The following cases are corresponding to different combo with shift pressed
movi r11, 0x55
beq r9, r11, readPlus
movi r11, 0x3E
beq r9, r11, readMult
movi r11, 0x36
beq r9, r11, readPwe




# + is pressed

readPlus:

movi r10, 0x2B #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




# * is pressed

readMult:

movi r10, 0x2A #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




# ^ is pressed

readPwe:

movi r10, 0x5E #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




# - is pressed

readMin:

movi r10, 0x2D #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop




# / is pressed

readDiv:

movi r10, 0x2F #The ascii code corresponding to it

addi sp, sp, -4

stw r10, 0(sp)

br read_loop





#Throw out break code

throwOut:

ldwio r9, 0(r7)

br read_loop



# Enter is pressed

readEnter:

#Throw out the break code of enter

ldwio r9, 0(r7)

ldwio r9, 0(r7)

br recoverEquation



# Finish the read of equation

recoverEquation:
#To recover the equation
#Store two numbers in r4, r5 and pass them to drawing program
#The position of the initial sp still stored in r8
mov r11, r8
#Initialize r4 with 0
movi r4, 0
recoverEquation2:
addi r8, r8, -4
ldw r9, 0(r8)
#Plus
movia r10, 43 
beq r9, r10, plusMode
#Multiply
movia r10, 42
beq r9, r10, multiMode
#Minus
movia r10, 45
beq r9, r10, minusMode
#Division
movia r10, 47
beq r9, r10, divMode
#Power
movia r10, 94
beq r9, r10, pweMode

#If here, a number was read
#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r4, r4, 10

#Add them together
add r4, r4, r9
br recoverEquation2

#Five different modes
#The first number should already stored in r4
plusMode:
movi r5, 0
plusMode2:
addi r8, r8, -4
ldw r9, 0(r8)

#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r5, r5, 10

#Add them together
add r5, r5, r9
#Check if finished
beq r8, sp, plusEnd
br plusMode2
#
plusEnd:
movi r6, 0
call CALCULATION
br restoreSp


minusMode:
movi r5, 0
minusMode2:
addi r8, r8, -4
ldw r9, 0(r8)

#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r5, r5, 10

#Add them together
add r5, r5, r9
#Check if finished
beq r8, sp, minusEnd
br minusMode2
#
minusEnd:
movi r6, 1
call CALCULATION
br restoreSp


multiMode:
movi r5, 0
multiMode2:
addi r8, r8, -4
ldw r9, 0(r8)

#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r5, r5, 10

#Add them together
add r5, r5, r9
#Check if finished
beq r8, sp, multiEnd
br multiMode2
#
multiEnd:
movi r6, 2
call CALCULATION
br restoreSp


divMode:
movi r5, 0
divMode2:
addi r8, r8, -4
ldw r9, 0(r8)

#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r5, r5, 10

#Add them together
add r5, r5, r9
#Check if finished
beq r8, sp, divEnd
br divMode2

divEnd:
movi r6, 3
call CALCULATION
br restoreSp


pweMode:
movi r5, 0
pweMode2:
addi r8, r8, -4
ldw r9, 0(r8)

#Subtract r9 with 0's ascii code
#And multiply 10 to r4
subi r9, r9, 48
muli r5, r5, 10

#Add them together
add r5, r5, r9
#Check if finished
beq r8, sp, pweEnd
br pweMode2
#
pweEnd:
movi r6, 4
call CALCULATION


br restoreSp


#To restore sp
restoreSp:

mov r4, r11
call PRINT_INPUT


mov sp, r11
mov r4, r2
call HEX_TO_SEVEN_SEGMENT_DISPLAY

br endRead

#Read finished
endRead:
br _start



#To prevent from repeatedly reading
count_threshold:
    movui r14, %lo(50000000)
    stwio r14, 8(r13)                          /* Set the period to be 1000 clock cycles */
    movui r14, %hi(50000000)
    stwio r14, 12(r13)
    movui r14, 4
    stwio r14, 4(r13)
loop:
	ldwio r14, 0(r13)
	andi r14, r14, 1
	beq r14, r0, loop
	stwio r0, 0(r13)
    ret