# Writing_Robot

This is the final project of ECE243 Computer Organization, University of Toronto

This project takes in an equation (.ie 2+3, 3^4, 18/6) from a PS2 keyboard, supporting five operators: +, -, *, /, ^. And then the program will calculate the result and display on the command line and 7-segment display on the board. User can trigger the robot anytime to let it write the last result on a paper.

The whole project is written in assembly language running on De1-SoC Altera Board using Nios II architecture.<br/>
	PS2 keyboard is used to take in the problem from the user.<br/> 
	Algorithm that supports multifunctional calculation and converts between hexadecimal and decimal representation is used.<br/>
	The robot is controlled using LEGO Controller. <br/>
	A VGA display is used to display the instructions.<br/>
	An interrupt is used to trigger the robot to draw the result.<br/>

Note: The majority of the project (programming side of the project) is fully functional. Result cannot be properly drawn due to mechanical defect of the LEGO motor.
