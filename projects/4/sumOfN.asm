@R0
D=M

@n
M=D

@i
M=1

@SUM
M=0

(LOOP)
@i
D=M     // get the value from the 'i' variable stored at some place in RAM
@n      // get the value from the 'n' variable stored at some place in RAM
D=D-M   //check when the D == M means the we completed 'n' loops
@STOP
D;JGT   // when stop condition is reached move to (STOP) 

@SUM    //get the 'sum' from the memory using the SUM variable
D=M     //get the 'sum' from the memory in D register 
@i      //get the 'ith' value from the 'i' memory
D=D+M   //sum the 'ith' value with 'sum'
@SUM    
M=D     //store the sum in the 'SUM' memory location
@i      //get 'i'
M=M+1   //increment 'i' by 1
@LOOP   //go back to (LOOP)
0;JMP   


(STOP)  //reached here when the D == M meaning i == n  
@SUM    //get the sum memory
D=M     //store the sum in the memory
@R1     //get 'R1' register
M=D     //store the value in the 'R1' register
      //stop the loop
(END)
@END
0;JMP