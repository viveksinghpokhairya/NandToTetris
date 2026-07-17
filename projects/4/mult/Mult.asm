// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
// The algorithm is based on repetitive addition.

//// Replace this comment with your code.


@R2
M=0 //Store the first value in 'R2' register

@R1
D=M
@LOOP
D; JGE  //if R1 >= 0 then go to loop without changing signs 


@R0
D=M
M=-D   // negate the value of R0 i.e. R0 = -1*R0

@R1
D=M
M=-D  // similary negate R1


// getting the mulitplication ans
@R0
D=M
@R2
M=D
@i
M=1 // Initializing the 'i' with 1

(LOOP)
@R1
D=M
@END
D;JEQ  // if R1 == 0 no need to continue exit

@R0
D=M
@R2
M=M+D  // R2 = R2 + R0

@R1
M=M-1  // reduce the count of R1 by 1

@LOOP
0,JMP  // continue

(END)
@END
0;JMP