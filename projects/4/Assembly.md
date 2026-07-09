# Assembly Language Notes

---

# Table of Contents

1. Introduction
2. Memory Organization
3. CPU Registers
4. A-Instruction (Address Instruction)
5. C-Instruction (Compute Instruction)
6. Moving Data Around
7. Program Flow and Jump Instructions
8. Symbols in Hack Assembly
9. Binary Instruction Format
10. Memory-Mapped I/O
11. Screen Memory
12. Keyboard Memory
13. Program Termination
14. Project 4 Overview
15. Key Takeaways

---

# Introduction

**Machine language is the lowest-level language that a CPU can execute directly. It is defined by the CPU's Instruction Set Architecture (ISA), which is designed alongside the hardware. Assembly language is a human-readable representation of machine language, where each assembly instruction typically maps to one machine instruction. High-level languages such as C, C++, and Rust are compiled into machine language (sometimes through assembly as an intermediate step). Different CPU architectures, such as x86-64 and ARM64, have different machine languages because they define different ISAs. However, multiple processors can implement the same ISA—for example, both Intel and AMD processors understand the x86-64 machine language, even though their internal hardware implementations differ.**

Super Simplification:

Think of the CPU as a person who understands only one native language.

- **Machine language** is the CPU's native language. It consists of binary instructions (0s and 1s) that the CPU can execute directly.
- **Assembly language** is like writing the same language using easy-to-read words instead of binary numbers. An **assembler** acts as a translator, converting these readable instructions into machine language.
- **High-level languages** (such as C, C++, and Rust) are like speaking in normal human language. They let programmers express ideas more naturally without worrying about the hardware. A **compiler** translates these programs into the CPU's machine language.

Every CPU architecture has its own native language, called its **Instruction Set Architecture (ISA)**. For example, **x86-64** and **ARM64** are different ISAs, so they speak different machine languages. However, different CPU manufacturers can build processors that speak the same language. For example, both **Intel** and **AMD** processors understand the **x86-64** machine language, even though their internal hardware designs are different.

Initially, programmers had only two practical ways to write programs: directly in **machine language** (binary instructions) or in **assembly language**, which is a human-readable representation of machine language. Writing machine language by hand was extremely difficult, error-prone, and time-consuming, so assembly language was introduced. An **assembler** translates each assembly instruction into its corresponding machine instruction, making programming much easier while still giving programmers direct control over the hardware.

As software became more complex, **high-level languages** such as C, C++, and Java were introduced. These languages provide a higher level of abstraction, allowing programmers to focus on solving problems rather than managing hardware details. A **compiler** translates high-level code into machine language. Conceptually, this translation can be viewed as:

```
High-Level Language
        ↓
Assembly Language
        ↓
Machine Language
```

Although many modern compilers generate machine code directly without producing assembly code as an intermediate file, the above model is useful for understanding the relationship between these layers.
This Machine Code and assembly language relation will be discussed in the 5th Unit.

The **Hack Computer** is a simple **16-bit computer architecture** designed for learning how computers work from the hardware level all the way up to software.

Although it is much simpler than modern CPUs, it demonstrates all the essential ideas:

- CPU
- Memory
- Registers
- Instruction
    - A instruction
    - C instruction
- Machine Language
- Assembly Language
- Program Flow
- Input/Output

The CPU communicates with memory using only a few registers(A, D and M), making the architecture extremely simple yet surprisingly powerful.

---

# Memory Organization

The Hack computer divides memory into two completely separate parts.

## 1. RAM (Data Memory)

Stores:

- Variables
- Numbers
- Arrays
- Screen Memory
- Keyboard Input

You can both **read** and **write** RAM.

---

## 2. ROM (Instruction Memory)

Stores:

- Program instructions

The CPU only reads instructions from ROM.

Programs cannot modify ROM while running.

---

## Memory Size

Both memories contain:

```
2^15 = 32768 locations (32K)
```

Addresses range from:

```
0
...
32767
```

---

# CPU Registers

The Hack CPU mainly works with three names:

| Name | Purpose |
|-------|----------|
| A | Address Register |
| D | Data Register |
| M | Memory pointed to by A |

---

## D Register

The **D register** is simply temporary storage inside the CPU.

Example:


| Example | Means |
|-------|----------|
| D=5 | D now contains 5 |




## A Register

The **A register** stores an address.

Example:

| Example | Means |
|-------|----------|
| @100 | A = 100 |


The CPU now points to:

```
RAM[100]
ROM[100]
```

depending on the next instruction.

---

## M

M is **not an actual register**.

It simply means:

```
Memory[A]
```

If

```
A = 100
```

then

```
M == RAM[100]
```

If A changes,

M automatically refers to a different RAM location.

---

# The A-Instruction: Symbolic & Binary

The A-instruction loads a value into the A register.

1. Symbolic form:

| Syntax | Practical |
|-------|----------|
| @Value | @21 |


2. Binary form:
In Binary form A-instruction begins with '0'

| Syntax | Pracitcal |
|-------|----------|
| 0Value | 0000000000010101 |

The value can represent:

- a constant
- a RAM address
- a ROM address
- a symbol

---

# The C-Instruction: Symbolic & Binary

The C-instruction performs computation.
A C-instruction can perform three operations simultaneously:

a. Compute something
b. Store the result
c. Jump somewhere

1. General form:

```text
dest = comp ; jump
```

Examples:

```asm
D=A
```

```asm
M=D+1
```

```asm
0;JMP
```

2. Binary form:

a. Every C-instruction starts with:

```
111
```

Structure:

```
111 a cccccc ddd jjj
```

| Field | Purpose |
|--------|----------|
| a | Select A or M |
| cccccc | Computation |
| ddd | Destination |
| jjj | Jump Condition |


b. The `a` Bit

Determines whether the ALU uses:

```
A register
```

or

```
Memory (M)
```

c. Destination Bits

Three bits correspond to:

```
A
D
M
```

Examples:

```asm
D=A
```

stores into D.


```asm
MD=D+1
```

stores into

- M
- D

at the same time.


d. Jump Bits

Jump instructions include:

| Jump | Meaning |
|-------|----------|
| JMP | Always |
| JEQ | Equal to zero |
| JGT | Greater than zero |
| JLT | Less than zero |
| JGE | Greater or equal |
| JLE | Less or equal |
| JNE | Not equal |

Example:

```asm
@29
0;JMP
```

Meaning:

```
Jump to ROM address 29
```

Example:

```asm
@52
D;JEQ
```

Meaning:

```
If D == 0

jump to instruction 52
```

Otherwise continue normally.



## C-Instruction Format

The **C-instruction** is responsible for performing computations, storing results, and controlling the program flow. Unlike an A-instruction, which only loads a value into the **A register**, a single C-instruction can perform up to **three operations at once**:

1. Compute a value.
2. Store the computed value.
3. Optionally jump to another instruction.

The general syntax is:

```asm
dest = comp ; jump
```

Both `dest` and `jump` are optional, but the **`comp` field is mandatory**.

Examples:

```asm
D=A
```

```asm
M=D+1
```

```asm
0;JMP
```

## Binary Format

Every C-instruction begins with the three bits:

```
111
```

The remaining 13 bits are divided into three fields:

```
111 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3
```

| Field | Purpose |
|--------|----------|
| **111** | Identifies the instruction as a C-instruction. |
| **a** | Selects whether the computation uses the **A register** or **Memory (M)**. |
| **comp** | Specifies the computation the ALU should perform. |
| **dest** | Specifies where the result should be stored. |
| **jump** | Specifies whether the CPU should jump to another instruction. |


## The `comp` Field

The **comp** field tells the ALU what operation to perform.
**ALU and the Comp filed are related to each other check the ALU_and_Comp_bits_relation.md file**

Some common computations are:

| Computation | Binary (`a c1 c2 c3 c4 c5 c6`) | Description |
|-------------|-------------------------------|-------------|
| `0` | `0101010` | Outputs the constant **0** |
| `1` | `0111111` | Outputs the constant **1** |
| `-1` | `0111010` | Outputs the constant **-1** |
| `D` | `0001100` | Returns the value stored in the **D register** |
| `A` | `0110000` | Returns the value stored in the **A register** |
| `M` | `1110000` | Returns the value stored in **RAM[A]** |
| `!D` | `0001101` | Performs a bitwise NOT on **D** |
| `!A` | `0110001` | Performs a bitwise NOT on **A** |
| `!M` | `1110001` | Performs a bitwise NOT on **M (RAM[A])** |
| `-D` | `0001111` | Computes the negative of **D** |
| `-A` | `0110011` | Computes the negative of **A** |
| `-M` | `1110011` | Computes the negative of **M (RAM[A])** |
| `D+1` | `0011111` | Increments **D** by 1 |
| `A+1` | `0110111` | Increments **A** by 1 |
| `M+1` | `1110111` | Increments **M (RAM[A])** by 1 |
| `D-1` | `0001110` | Decrements **D** by 1 |
| `A-1` | `0110010` | Decrements **A** by 1 |
| `M-1` | `1110010` | Decrements **M (RAM[A])** by 1 |
| `D+A` | `0000010` | Adds **D** and **A** |
| `D+M` | `1000010` | Adds **D** and **M (RAM[A])** |
| `D-A` | `0010011` | Subtracts **A** from **D** |
| `D-M` | `1010011` | Subtracts **M (RAM[A])** from **D** |
| `A-D` | `0000111` | Subtracts **D** from **A** |
| `M-D` | `1000111` | Subtracts **D** from **M (RAM[A])** |
| `D&A` | `0000000` | Performs a bitwise **AND** between **D** and **A** |
| `D&M` | `1000000` | Performs a bitwise **AND** between **D** and **M (RAM[A])** |
| `D\|A` | `0010101` | Performs a bitwise **OR** between **D** and **A** |
| `D\|M` | `1010101` | Performs a bitwise **OR** between **D** and **M (RAM[A])** |

### Understanding the `a` Bit

The **a bit** determines where the ALU gets its second operand:

- **a = 0** → use the **A register**
- **a = 1** → use **M**, which represents `RAM[A]`

For example:

```asm
D+A
```

uses the value stored in the **A register**.

Whereas

```asm
D+M
```

uses the value stored in **RAM[A]**.


## The `dest` Field

The **dest** field tells the CPU where to store the computed result.

| Destination (`dest`) | Binary (`ddd`) | Description |
|----------------------|----------------|-------------|
| `null` | `000` | The computed value is **not stored** anywhere. |
| `M` | `001` | Store the computed value in **RAM[A]**. |
| `D` | `010` | Store the computed value in the **D register**. |
| `MD` | `011` | Store the computed value in both the **D register** and **RAM[A]**. |
| `A` | `100` | Store the computed value in the **A register**. |
| `AM` | `101` | Store the computed value in both the **A register** and **RAM[A]**. |
| `AD` | `110` | Store the computed value in both the **A register** and **D register**. |
| `AMD` | `111` | Store the computed value in the **A register**, **D register**, and **RAM[A]**. |

Examples:

```asm
D=A
```

Stores the value of A into D.


```asm
M=D+1
```

Stores `D+1` into RAM[A].


```asm
MD=D-1
```

Stores `D-1` into both the D register and RAM[A].

## The `jump` Field

Normally, the CPU executes instructions one after another.

The **jump** field allows the CPU to change the execution flow based on the result of the computation.

| Jump (`jump`) | Binary (`jjj`) | Description |
|---------------|----------------|-------------|
| `null` | `000` | Continue executing the next instruction (no jump). |
| `JGT` | `001` | Jump to the address stored in the **A register** if the computation result is **greater than 0** (`comp > 0`). |
| `JEQ` | `010` | Jump to the address stored in the **A register** if the computation result is **equal to 0** (`comp = 0`). |
| `JGE` | `011` | Jump to the address stored in the **A register** if the computation result is **greater than or equal to 0** (`comp ≥ 0`). |
| `JLT` | `100` | Jump to the address stored in the **A register** if the computation result is **less than 0** (`comp < 0`). |
| `JNE` | `101` | Jump to the address stored in the **A register** if the computation result is **not equal to 0** (`comp ≠ 0`). |
| `JLE` | `110` | Jump to the address stored in the **A register** if the computation result is **less than or equal to 0** (`comp ≤ 0`). |
| `JMP` | `111` | Unconditionally jump to the address stored in the **A register**, regardless of the computation result. |

Examples:

```asm
D;JGT
```

Jump to the address stored in the **A register** if `D > 0`.

```asm
0;JMP
```

Always jump to the address stored in the **A register**.


## Putting Everything Together

Consider the instruction:

```asm
MD=D+1;JGT
```

It performs three operations in a single instruction:

1. Compute `D + 1`.
2. Store the result in both **D** and **RAM[A]**.
3. If the computed result is greater than zero, jump to the instruction whose address is stored in the **A register**.

This ability to **compute**, **store**, and **change the program flow** in a single instruction makes the C-instruction the most powerful instruction in the Hack assembly language.


# Moving Data Around

Suppose we want:

```
RAM[100] = 17
```

Hack assembly:

```asm
@17
D=A

@100
M=D
```

Explanation:

Step 1

```
A = 17
```

Step 2

```
D = 17
```

Step 3

```
A = 100
```

Step 4

```
RAM[100] = D
```

Result:

```
RAM[100] = 17
```

---

# Symbols

Writing raw addresses is difficult.

Hack supports symbols.

There are three types.

---

## 1. Predefined Symbols

Already built into the assembler.

Examples:

```
R0
R1
...
R15
```

which correspond to

```
RAM[0]
...
RAM[15]
```

Other predefined symbols:

```
SCREEN
```

Address:

```
16384
```

```
KBD
```

Address:

```
24576
```

---

## 2. Labels

Labels mark locations in the code.

Example:

```asm
(LOOP)
```

Later:

```asm
@LOOP
0;JMP
```

The assembler replaces LOOP with the correct ROM address.

Labels do **not** generate machine instructions.

---

## 3. Variables

Example:

```asm
@count
```

The assembler automatically assigns memory.

Variables begin at RAM address:

```
16
```

Example:

```
count

↓

RAM[16]
```

Next variable:

```
RAM[17]
```

and so on.

---

# Memory-Mapped I/O

Hack communicates with hardware using RAM.

Certain RAM addresses are permanently connected to hardware devices.

---

# Screen Memory

The screen starts at:

```
16384
```

Symbol:

```asm
SCREEN
```

Screen resolution:

```
512 × 256 pixels
```

Black and white only.

---

Each RAM word contains:

```
16 pixels
```

Bit values:

```
1 → Black

0 → White
```

To modify pixels:

1. Read the 16-bit word
2. Change desired bits
3. Write the word back

---

# Keyboard Memory

Keyboard address:

```
24576
```

Symbol:

```asm
KBD
```

Behavior:

If no key is pressed:

```
RAM[24576] = 0
```

If a key is pressed:

```
RAM[24576] = ASCII code
```

Example:

```
'A'

↓

65
```

Programs repeatedly check this location to detect keyboard input.

---

# Program Termination

The Hack CPU never stops automatically.

If execution reaches the end of the program, it continues reading whatever comes next as instructions.

To prevent this, every program ends with an infinite loop.

Example:

```asm
(END)
@END
0;JMP
```

This repeatedly jumps to itself forever.

---

# Project 4 Overview

## 1. Mult.asm

Goal:

```
R2 = R0 × R1
```

Since Hack has no multiplication instruction, multiplication is implemented using repeated addition.

Example:

```
3 × 4

↓

3 + 3 + 3 + 3
```

inside a loop.

---

## 2. Fill.asm

Continuously monitor the keyboard.

If:

```
KBD > 0
```

Fill the entire screen with black pixels.

Otherwise:

```
KBD == 0
```

Fill the screen with white pixels.

The program runs forever inside an infinite loop.

---

# Important Note

Avoid mixing memory access and jump logic incorrectly.

The A register is used both:

- as a RAM address
- as a ROM jump target

Always ensure A contains the correct address before using M or performing a jump.

---

# Key Takeaways

- Hack is a simple 16-bit educational computer architecture.
- RAM stores data; ROM stores program instructions.
- The CPU mainly uses two registers: **A** and **D**.
- **M** always refers to the RAM location pointed to by **A**.
- There are only two instruction types:
  - **A-instruction** (`@value`)
  - **C-instruction** (`dest=comp;jump`)
- Labels and variables make assembly programs easier to read.
- The screen and keyboard are controlled through **memory-mapped I/O**.
- Every Hack program should end with an infinite loop.
- Multiplication is implemented using repeated addition because the ALU has no multiply instruction.

---

# Final Summary

The Hack computer demonstrates how a complete computer can be built using only a few simple components. By relying on the **A register** to select memory locations, the **D register** for temporary data storage, and **M** as a reference to the currently selected memory location, the architecture remains minimal yet fully capable of executing programs, managing variables, controlling hardware, and implementing loops and conditional logic.

Understanding these fundamentals provides a solid foundation for learning how modern CPUs, assembly languages, and computer architectures work.