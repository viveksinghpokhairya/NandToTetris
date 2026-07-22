
---

# 🖥️ Hack Computer Integration Notes (`Computer.hdl`)

## 1. System Overview

`Computer.hdl` is the top-level chip that ties the entire hardware system together. It encapsulates three core modules:

1. **`CPU`**: The processing engine executing arithmetic, logic, and branching.
2. **`Memory`**: Data storage including `RAM16K`, `Screen`, and `Keyboard`.
3. **`ROM32K`**: Read-Only Memory holding the compiled machine code instructions.

```text
                  ┌───────────────────────────────┐
                  │          ROM32K               │
                  │   (Instruction Memory)        │
                  └──────────────┬────────────────┘
                                 │ instruction
                                 ▼
┌─────────────────┐  inM   ┌───────────┐  outM      ┌─────────────────┐
│                 ├───────►│           ├───────────►│                 │
│     Memory      │        │    CPU    │  addressM  │     Memory      │
│  (Read Path)    │        │           ├───────────►│  (Write Path)   │
│                 │        │           │  writeM    │                 │
└─────────────────┘        └─────┬─────┘───────────►└─────────────────┘
                                 │
                                 │ pc
                                 ▼
                  ┌───────────────────────────────┐
                  │          ROM32K               │
                  │    (Next Instruction)         │
                  └───────────────────────────────┘

```

---

## 2. Bus Interconnections & Signal Routing

The system operates via four primary signal pathways:

| Connection Path | Source Pin $\rightarrow$ Destination Pin | Signal Purpose |
| --- | --- | --- |
| **Instruction Fetch** | `ROM32K.out` $\rightarrow$ `CPU.instruction` | Delivers the 16-bit binary instruction to the CPU for execution. |
| **Program Counter** | `CPU.pc` $\rightarrow$ `ROM32K.address` | Dictates which line of machine code in ROM should be fetched next. |
| **Memory Read** | `Memory.out` $\rightarrow$ `CPU.inM` | Supplies data read from RAM or peripherals into the CPU's ALU. |
| **Memory Write** | `CPU.outM` $\rightarrow$ `Memory.in`<br>

<br>`CPU.addressM` $\rightarrow$ `Memory.address`<br>

<br>`CPU.writeM` $\rightarrow$ `Memory.load` | Writes computation results to data RAM, updates screen pixels, or triggers memory operations when `writeM == 1`. |

---

## 3. Clock Synchronized Execution

* **Combinational Signals (`outM`, `writeM`):** Settle during the current clock cycle based on the active instruction.
* **Clocked Signals (`pc`, `addressM`, RAM registers):** Commit their values on the **rising edge** of the next clock cycle, advancing the computer state one step forward seamlessly.

---
