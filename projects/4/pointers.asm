// Usage of pointer demonstrated using the 'arr' and 'i' index;


//Initializing the values of the array
@100
D=A
@arr     //array starts at 100th position
M=D      //store the 100 value i.e. 100 is the memory location to 'arr' variable  

@10
D=A     
@n
M=D     //store '10' in the 'n' variable

@i
M=0     //start of the for loop


//for loop

//checking the condition of for loop is 'i' < 'n'
(LOOP)
@i
D=M
@n
D=D-M // if value of 'i' == 'n' then jump to 'END'
@END
D;JEQ //jump when the D == 0

//performing the operations when the condition is valid

@arr
D=M
@i
A=D+M // [Usage of pointer here 'D' is the base address 'i' stores the index]
M=-1  //set the value of the 'arr + i' to '-1'

@i
M=M+1
@LOOP    //do the process again until 'i' < 'n'
0;JMP

(END)
@END
0;JMP
