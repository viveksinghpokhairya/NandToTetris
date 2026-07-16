@R1
D=M    //get the value from the 'R1' register

@temp
M=D  // store the 'R1' value in 'temp'

@R0     // get the 'R0' register
D=M     //get the value from the 'R0' register
@R1     // get the 'R1' register
M=D     //store the value taken from the 'R0' to 'R1'

@temp   //get the 'temp' variable
D=M     //get the value from the 'temp' variable
@R0     //get the 'R0' register 
M=D     //store the value taken from the 'temp' variable to 'R0' 

(END)
@END    //loop back continously
0;JMP
