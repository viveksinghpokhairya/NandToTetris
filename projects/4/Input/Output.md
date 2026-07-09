# Memory-Mapped I/O in the Hack Computer

## Overview

The Hack computer communicates with external devices using a technique called **Memory-Mapped Input/Output (Memory-Mapped I/O)**. Instead of having special instructions for controlling hardware devices such as the screen or keyboard, the Hack computer treats these devices as part of its memory. This allows the CPU to interact with hardware using the same read and write instructions that it uses for normal RAM.

The Hack architecture provides two built-in I/O devices:

- **Screen**
- **Keyboard**

Both devices are mapped to fixed locations in the computer's memory address space.

---

## Memory-Mapped I/O

Memory-Mapped I/O is a hardware design technique where certain memory addresses are reserved for I/O devices instead of ordinary RAM.

From the CPU's perspective, there is no difference between accessing RAM and accessing an I/O device. The only difference is how the hardware interprets those memory addresses.

```
                CPU
                 │
        Read / Write Memory
                 │
      ┌──────────┴──────────┐
      │                     │
   Normal RAM        I/O Memory
                         │
             ┌───────────┴───────────┐
             │                       │
          SCREEN                  KEYBOARD
```

This simple design eliminates the need for dedicated I/O instructions and greatly simplifies the CPU architecture.

---

# Screen

The Hack computer contains a built-in monochrome display with a resolution of:

```
512 × 256 pixels
```

Instead of sending graphics commands to the display, the CPU simply writes data into a dedicated region of RAM called the **Screen Memory Map**.

The display hardware continuously reads this memory and updates the pixels on the screen.

---

## Screen Memory Layout

The screen occupies **8192 (8K) consecutive 16-bit words** beginning at memory address:

```
SCREEN = 16384
```

Since each memory word contains **16 bits**, each word controls **16 horizontal pixels**.

```
1 Word

┌───────────────────────────────┐
│16 Bits                        │
└───────────────────────────────┘

↓

16 Horizontal Pixels
```

Each bit controls one pixel:

- **0 → White Pixel**
- **1 → Black Pixel**

---

## Screen Organization

```
Resolution

512 Columns
×

256 Rows

=

131072 Pixels
```

Each row contains:

```
512 Pixels

÷

16 Pixels per Word

=

32 Words
```

Therefore,

```
32 Words × 256 Rows

=

8192 Words
```

which exactly matches the size of the Screen Memory.

---

## Mapping Pixels to Memory

To modify a pixel located at:

```
(Row, Column)
```

the corresponding memory word is calculated as

```
Memory Address

=

SCREEN

+

32 × Row

+

(Column / 16)
```

The specific bit inside that word is

```
Column mod 16
```

Thus, a two-dimensional pixel coordinate is converted into a one-dimensional memory address.

---

## Updating a Pixel

Since memory is accessed one 16-bit word at a time, changing a single pixel requires three steps:

1. Read the 16-bit word.
2. Modify the required bit.
3. Write the updated word back.

This process is known as the **Read–Modify–Write** operation.

---

# Keyboard

The Hack keyboard is also memory mapped.

Unlike the screen, it occupies only **one memory location**.

```
KBD = 24576
```

The keyboard register always contains the scan code of the key currently being pressed.

```
No Key Pressed

↓

RAM[24576] = 0
```

```
Key Pressed

↓

RAM[24576] = Scan Code
```

For example,

| Key | Scan Code |
|------|----------:|
| Space | 32 |
| 4 | 52 |
| K | 75 |
| Up Arrow | 131 |

Whenever the key is released, the value automatically returns to **0**.

---

# CPU Interaction

The CPU communicates with both devices using ordinary memory instructions.

### Writing to the Screen

```
CPU

↓

Write RAM[16384 ...]

↓

Screen Memory

↓

Display Updates
```

### Reading the Keyboard

```
CPU

↓

Read RAM[24576]

↓

Current Scan Code
```

No special hardware instructions are required.

---

# Memory Layout

```
Hack Data Memory

┌────────────────────────────────────────────┐
│                                            │
│ General Purpose RAM                        │
│                                            │
├────────────────────────────────────────────┤
│ SCREEN                                     │
│ Address: 16384                             │
│ Size: 8192 Words                           │
├────────────────────────────────────────────┤
│ KEYBOARD                                   │
│ Address: 24576                             │
│ Size: 1 Word                               │
└────────────────────────────────────────────┘
```

---

# Key Takeaways

- The Hack computer uses **Memory-Mapped I/O** to communicate with hardware.
- The **Screen** occupies an 8K region of memory beginning at **16384**.
- Each **bit** in Screen memory corresponds to **one pixel** on the display.
- The **Keyboard** occupies a single memory location (**24576**) containing the current key's scan code.
- The CPU interacts with the screen and keyboard using the same load/store instructions used for ordinary RAM.
- Memory-Mapped I/O keeps the Hack architecture simple by allowing hardware devices to be treated as part of the memory system.