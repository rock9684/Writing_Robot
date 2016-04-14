# ECE243-Project-Calculator-Robot

This is a course project from ECE243 Computer Organization.

This project takes in an arithmetic problem (.ie 2+3, 3^4, 18/6) from a PS2 keyboard. And then the program will calculate the result and display on the terminal and 7-segment display on the board. At the same time, the user can trigger the robot and let it write the result on a paper.

The whole project is written in assembly language running on De1-SoC Altera Board using Nios II architecture.
	PS2 keyboard is used to take in the problem from the user. 
	Algorithm that supports multifunctional calculation and converts between hexadecimal and decimal representation is used.
	The robot is controlled using LEGO Controller. 
	A VGA display is used to display the instructions.
	An interrupt is used to trigger the robot to draw the result.

Note: The majority of the project (programming side of the project) is fully functional. Result cannot be properly drawn due to mechanical defect of the LEGO motor.
