This paragraph is essentially the literal instruction manual for how you need to write your `CPU.hdl` file. It tells you exactly which wires need to go where and how they should react to the system clock.

Let's translate this engineering text into a clear, visual blueprint by breaking it down into three distinct rules.

---

<p align="center">
  <img src="CPU.png" alt="Computer Architecture" width="700"/>
</p>

## 🛠️ Rule 1: The Execution Split (A-Instruction vs. C-Instruction)

When a 16-bit instruction enters the CPU, the chip checks the very first bit (the opcode) to decide which path the data should take.

### If it’s an A-Instruction (Starts with `0`):

The CPU treats the entire 16-bit package as a raw number value.

* **The Action:** The CPU bypasses the ALU entirely and routes this 16-bit value straight into the **A-Register**.

### If it’s a C-Instruction (Starts with `1`):

The CPU treats the package as a command to do math and save the result.

* **Step I (The Math):** The CPU tells the ALU to perform the calculation specified by the instruction's control bits.
* **Step II (The Destination):** The ALU spits out an answer, and the instruction's destination bits specify a subset of `{A, D, M}` to store that answer. The answer can be saved to one, two, all three, or none of them simultaneously.

### ⚠️ The Special "M" Register Rules:

The **M** register (Memory) isn’t physically inside the CPU chip—it lives in the external RAM. The CPU talks to it using dedicated output pins. The text gives you explicit logic for the `writeM` and `outM` pins:

* **If `M` is a destination:** You must route the ALU's output directly to the CPU's `outM` pin, and you must set the `writeM` pin to `1` (which acts as an "enable write" command to the external RAM).
* **If `M` is NOT a destination:** You set `writeM` to `0` (telling the RAM to ignore incoming data). Because `writeM` is `0`, the RAM doesn't care what is on the data line, so the text notes that "any value may appear in `outM`" (it can just be random garbage or old ALU data).

---

## 🔄 Rule 2: The Traffic Director (The Program Counter)

The CPU needs to figure out what line of code to read next. It does this using the **Program Counter (PC)** block, and it operates under a strict hierarchy:

1. **The Panic Button (`reset == 1`):** If the reset pin is flipped to high, the CPU completely ignores the code, overrides everything, and forces the `pc` output to `0`. This is what happens when you turn a computer on or reboot it—it jumps back to line zero.
2. **Normal Operation (`reset == 0`):** The CPU looks at two things to decide the next step: the **ALU status flags** (is the output zero? is it negative?) and the **jump bits** of the current instruction.
* If the math matches the jump condition (e.g., the output is zero and the instruction says `JEQ`), the PC loads the address currently sitting in the **A-register** (`PC = A`).
* If the conditions don't match, the PC simply increments by one (`PC++`).



---

## ⏱️ Rule 3: The Physics of Time (Combinational vs. Clocked)

This is the most critical concept for avoiding bugs when writing your HDL code. It explains the difference between wires that react instantly and registers that wait for the clock tick.

```
                  ┌────────────────────────────────────────┐
                  │          THE CURRENT CLOCK CYCLE       │
                  └────────────────────────────────────────┘
Instantaneous Wires (Combinational)       Delayed Wires (Clocked)
React right now!                          Wait for the next tick!
• outM                                    • addressM (from A-Register)
• writeM                                  • pc

```

### ⚡ Combinational Outputs (`outM`, `writeM`)

These are made of pure logic gates (like AND/OR/MUX) without any flip-flops.

* **How they behave:** Information travels through them like water through a pipe. The moment a C-instruction hits the CPU, the electricity flows through the decoder and the ALU, and `outM` and `writeM` change **instantaneously** during the current clock cycle.

### 💾 Clocked Outputs (`addressM`, `pc`)

These outputs are connected to internal sequential components (the A-Register and the PC block) which contain clocked Flip-Flops.

* **How they behave:** Even though the CPU computes the new address and the next line number right now, these components act like closed floodgates. They will **commit** to their new values only at the exact moment the clock transitions to the **next time step**.

---

### 💡 What this means for your HDL wiring:

When you write your code, you can safely use the output of the A-register to feed the `addressM` pin, and the output of your PC block to feed the `pc` pin. The hardware simulator's clock cycle will automatically handle the delay timing mentioned in the text!