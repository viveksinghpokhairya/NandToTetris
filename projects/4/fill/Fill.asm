// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/4/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, 
// the screen should be cleared.

//// Replace this comment with your code.
@8192
D=A
@n
M=D         // setting the value of 'n' == 8192

(LOOP)
@KBD
D=M
@SETSCREEN
D;JGT
@CLRSCREEN
D;JEQ
@LOOP
0;JMP


(SETSCREEN)
@i
M=0
(SETCONTINUE)

@i
D=M
@n
D=D-M
@LOOP
D; JEQ      //if i==n goback to main loop

@SCREEN
D=A         // D = 16384 (Base address)
@i
A=D+M       // A = 16384 + i
M=-1        // Fill 16 pixels black

@i
M=M+1       //increment 'i'
@SETCONTINUE
0; JMP


(CLRSCREEN)
@i
M=0
(CLRCONTINUE)

@i
D=M
@n
D=D-M
@LOOP
D; JEQ      //if i==n goback to main loop

@SCREEN
D=A         // D = 16384 (Base address constant)
@i          // Select the index variable
A=D+M       // A = 16384 + value of i
M=0         // Set all 16 pixels to white

@i
M=M+1       //increment 'i'
@CLRCONTINUE
0;JMP

