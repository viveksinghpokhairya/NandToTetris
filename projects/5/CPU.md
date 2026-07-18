
![alt text](ComputerArchitecture.png)

````markdown
# Memory

Memory is one of the most important components of a computer. It stores everything the CPU needs to execute a program, including both the program's instructions and the data those instructions operate on.

---

## Physical View of Memory

From the hardware's perspective, memory is simply a long sequence of fixed-size storage locations called **memory registers**.

Each register has:
- A **unique address** (its location)
- A **value** (the data stored inside it)

```
Address      Value
-------      -----
0            ...
1            ...
2            ...
3            ...
4            ...
...
```

Since every register has a unique address, the CPU can directly access any register by providing its address.

This process is called **addressing**.

---

## Random Access Memory (RAM)

The term **Random Access Memory (RAM)** means that **any memory register can be accessed directly in the same amount of time**, regardless of:

- how large the memory is,
- where the register is located.

For example, accessing address **5** takes the same time as accessing address **50,000**.

This constant-time access is what makes RAM fast and efficient.

---

# Logical View of Memory

Although memory is physically one continuous collection of registers, logically it is divided into two different areas:

```
Memory
│
├── Data Memory
│
└── Instruction Memory
```

Each serves a different purpose.

---

# Data Memory

High-level programming languages use concepts such as:

- Variables
- Arrays
- Objects

However, the hardware does not understand these abstractions.

After compilation, all of these become **binary values stored in memory registers**.

For example:

```cpp
int x = 10;
```

might become

```
Address     Value
100         10
```

The variable `x` is simply represented by the value stored at memory address **100**.

---

## Reading Data

To read data:

1. Provide the memory address.
2. Memory returns the value stored at that address.

Example:

```
Address = 100

Memory returns:

10
```

---

## Writing Data

To modify data:

1. Provide the memory address.
2. Provide the new value.
3. The previous value is overwritten.

Example:

Before:

```
Address    Value
100        10
```

After writing `25`:

```
Address    Value
100        25
```

The old value is replaced with the new one.

---

# Instruction Memory

Programs written in languages like C++, Java, or Python are first translated into **machine language instructions**.

These instructions are stored as binary values inside an executable (binary) file.

Before execution:

1. The executable is loaded from storage (SSD/HDD).
2. Its machine instructions are copied into **instruction memory**.
3. The CPU fetches and executes these instructions one by one.

```
Source Code
      │
      ▼
Compiler
      │
      ▼
Machine Code (Executable)
      │
      ▼
Instruction Memory
      │
      ▼
CPU executes instructions
```

---

# Data Memory vs Instruction Memory

| Data Memory | Instruction Memory |
|-------------|--------------------|
| Stores program data | Stores program instructions |
| Contains variables, arrays, objects | Contains machine language instructions |
| Values change during execution | Instructions usually remain unchanged while running |
| CPU reads and writes data | CPU mainly fetches instructions |

---

# Key Takeaways

- Memory is a linear collection of addressable registers.
- Every register has a unique address and stores one value.
- Accessing a register using its address is called **addressing**.
- RAM allows any register to be accessed in the same amount of time.
- **Data memory** stores variables, arrays, objects, and other program data.
- **Instruction memory** stores the machine instructions that the CPU executes.
- Before a program runs, its executable is loaded into instruction memory, while its data is stored in data memory.
````

![alt text](CPU.png)


````markdown
# CPU (Central Processing Unit)

The **CPU** is the brain of the computer. It executes program instructions by performing calculations, accessing memory, and deciding which instruction to execute next.

---

# Main Components of the CPU

## 1. Arithmetic Logic Unit (ALU)

The **ALU** performs all arithmetic and logical operations.

Examples:
- Addition (`5 + 3`)
- Subtraction
- Bitwise AND/OR
- Comparisons (`==`, `>`, `<`)

Some operations can be implemented in hardware (faster but more expensive) or software (slower but cheaper).

---

## 2. Registers

Registers are **small, very fast memory locations** inside the CPU used to store temporary data.

Common registers include:

| Register | Purpose |
|----------|---------|
| **Data Register** | Stores temporary values |
| **Address Register** | Stores memory addresses |
| **Program Counter (PC)** | Stores the address of the next instruction |
| **Instruction Register (IR)** | Stores the current instruction being executed |

---

## 3. Control Unit

The **Control Unit** manages the execution of instructions.

It:
- Fetches an instruction from memory.
- Decodes the instruction.
- Sends control signals to the ALU, registers, and memory.
- Ensures every component works together correctly.

---

# Fetch-Execute Cycle

The CPU continuously repeats these steps:

```
Fetch
   ↓
Decode
   ↓
Execute
   ↓
Repeat
```

### Step 1: Fetch
The CPU fetches the next instruction from **instruction memory**.

### Step 2: Decode
The Control Unit decodes the instruction to understand what needs to be done.

### Step 3: Execute
The required operation is performed using the ALU, registers, and memory.

The **Program Counter (PC)** is then updated to point to the next instruction.

---

# Key Takeaways

- The **CPU** executes all program instructions.
- The **ALU** performs arithmetic and logical operations.
- **Registers** store temporary data and important addresses.
- The **Control Unit** coordinates all CPU operations.
- Every program runs using the **Fetch → Decode → Execute** cycle.
````

# Input and Output (I/O)

Computers communicate with the outside world using **Input/Output (I/O) devices**.

### Examples
- Keyboard
- Mouse
- Monitor
- Printer
- Speaker
- Microphone
- Storage devices
- Network card

---

# Memory-Mapped I/O

Instead of handling every device differently, the computer treats each I/O device as a **special part of memory**.

Each device is assigned a **memory map**, which is a dedicated area in memory.

This allows the CPU to interact with devices just like it reads from or writes to normal memory.

```
CPU
 │
 ▼
Memory
 ├── Data Memory
 ├── Instruction Memory
 └── I/O Memory (Memory Map)
```

---

# Input Device Example (Keyboard)

The keyboard's memory map always reflects its current state.

When a key is pressed:
1. A binary code for that key is written to the keyboard's memory map.
2. The CPU reads that value from memory.

```
Press 'A'
      │
      ▼
Keyboard Memory Map
      │
      ▼
CPU reads the key
```

---

# Output Device Example (Screen)

The screen continuously checks its memory map.

When the CPU writes data to the screen's memory map:
1. The corresponding pixels are updated.
2. The display changes accordingly.

```
CPU writes data
      │
      ▼
Screen Memory Map
      │
      ▼
Pixels on the screen change
```

---

# Key Takeaways

- **I/O devices** allow a computer to communicate with the outside world.
- Each I/O device is assigned a **memory map** (a special memory area).
- The CPU interacts with I/O devices by reading from or writing to their memory maps.
- **Input devices** write data to memory for the CPU to read.
- **Output devices** display or produce results based on the data written to their memory maps.

