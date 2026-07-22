# Hack Computer Memory Architecture

This project implements the **Memory** chip of the Hack computer from the NAND2Tetris course. The Memory chip acts as the interface between the CPU and different hardware components, routing every memory access to the correct device based on the supplied address.

---

## Overview

The Hack computer follows a **Harvard Architecture**, meaning that **program instructions** and **application data** are stored in separate memories.

- **ROM32K** stores program instructions.
- **RAM16K** stores program data.

This separation allows the CPU to **fetch the next instruction from ROM while simultaneously reading or writing data in RAM during the same clock cycle**, improving efficiency.

---

## Memory Map

The Memory chip divides the address space into multiple hardware regions.

| Address Range | Size | Component | Purpose |
|---------------|------|-----------|---------|
| `0 – 16383` | 16K words | **RAM16K** | General-purpose data storage |
| `16384 – 24575` | 8K words | **Screen** | Memory-mapped display |
| `24576` | 1 word | **Keyboard** | Current keyboard input |

---

## Address Decoding

The Memory chip determines which hardware component should respond by examining the **two most significant address bits** (`address[13..14]`).

| Address Bits (`address[13..14]`) | Address Range | Selected Component |
|----------------------------------|---------------|--------------------|
| `00` | `0 – 8191` | Lower half of RAM16K |
| `01` | `8192 – 16383` | Upper half of RAM16K |
| `10` | `16384 – 24575` | Screen |
| `11` | `24576` | Keyboard |

A **DMux4Way** uses these two bits to route the incoming **load** signal so that **only the selected hardware component receives the write-enable signal**.

---

## Components

### RAM16K

The RAM16K chip stores all program data, including:

- Variables
- Arrays
- Stack
- Intermediate computation results

It occupies the first **16,384 memory locations** (`0x0000 – 0x3FFF`).

---

### Screen

The Hack display is memory-mapped.

#### Screen Resolution

- **512 columns**
- **256 rows**

Total pixels:

```text
512 × 256 = 131,072 pixels
```

Each memory register stores **16 pixels**.

Therefore,

```text
131,072 ÷ 16 = 8,192 registers (8K words)
```

Every write to the screen memory (`16384 – 24575`) immediately changes the corresponding pixels on the display.

- `1` → Black pixel
- `0` → White pixel

The display hardware continuously refreshes the screen by reading these memory locations.

---

### Keyboard

The keyboard is represented by a **single memory-mapped register** located at address:

```text
24576 (0x6000)
```

Its value represents:

- ASCII code of the currently pressed key
- `0` if no key is pressed

Although the address block selected by `address[13..14] = 11` spans from `24576` to `32767`, **only the first register is used**. The remaining addresses are **unmapped** and have no associated hardware.

---

## How Memory Routing Works

```text
                 address[13..14]
                        │
                        ▼
                   DMux4Way
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
     RAM16K          Screen        Keyboard
```

The `DMux4Way` examines the upper two address bits and routes the incoming **load** signal to exactly one hardware component.

The selected component then:

- receives the write request (if `load = 1`)
- outputs its stored value back to the CPU

---

## Key Takeaways

- The Hack computer uses a **Harvard Architecture** with separate instruction and data memories.
- The Memory chip is responsible for routing CPU memory accesses to the correct hardware device.
- Address decoding is performed using the **two most significant address bits**.
- The **Screen** is implemented using **memory-mapped I/O**, where writing to memory directly updates pixels.
- The **Keyboard** is also memory-mapped, exposing the currently pressed key through a single register.
- A **DMux4Way** ensures that only the addressed hardware component receives the write-enable signal.

---

## Learning Outcome

Building the Memory chip demonstrates how a computer can expose hardware devices such as displays and keyboards as ordinary memory locations. This memory-mapped approach allows the CPU to interact with hardware using the same read and write operations it uses for normal RAM, greatly simplifying the overall computer architecture.



## The Core Reason: Harvard Architecture Design

The Hack computer uses a **Harvard Architecture** (separate instruction and data memories) instead of a **Von Neumann Architecture** (a single shared memory for both code and data).

There are two primary technical reasons why this separation was necessary:

### 1. Lack of an Instruction Register

* In a single-memory system, executing an instruction that accesses RAM (like `D = M`) requires **two separate memory operations**:
1. Fetch the instruction from memory.
2. Read or write data at the RAM address specified by the instruction.


* To do this with a single memory chip, the CPU would need an **Instruction Register (IR)** to temporarily hold the instruction bits in place while the CPU switches the memory bus over to read/write the data.
* Because the Hack CPU **does not have an Instruction Register**, it cannot hold onto an instruction after fetching it—it must continuously read the instruction from the bus while executing it.

### 2. Single-Cycle Instruction Execution

* The Hack computer is engineered so that **every single instruction executes in exactly 1 clock cycle**.
* Separating `ROM32K` (Instruction Memory) and `RAM16K` (Data Memory) onto two independent buses allows the CPU to:
* **Fetch** the next instruction from ROM, and
* **Read or write** data in RAM


...**simultaneously within the exact same clock tick**.

---

### Quick Comparison

| Feature | Hack Architecture (Harvard) | Traditional Single-Memory (Von Neumann) |
| --- | --- | --- |
| **Instruction Memory** | Dedicated `ROM32K` | Shared RAM |
| **Data Memory** | Dedicated `RAM16K` | Shared RAM |
| **Instruction Register Needed?** |  **No** | **Yes** (to save instruction during data access) |
| **Clock Cycles per Execution** | **1 Cycle** | 2+ Cycles (Fetch cycle + Data cycle) |

By separating ROM and RAM, the Hack CPU avoids complex multi-cycle state machines and stays remarkably simple letting you implement the entire processor using basic logic gates!