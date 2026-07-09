## How the `comp` Field Maps to the ALU

The `comp` field of a C-instruction is **not an arbitrary binary code**. Each bit directly controls one of the ALU's control inputs.

Recall the C-instruction format:

```
111 a c1 c2 c3 c4 c5 c6 d1 d2 d3 j1 j2 j3
```

The seven computation bits map directly to the ALU as follows:

| C-Instruction Bit | ALU Control Bit | Purpose |
|-------------------|-----------------|---------|
| `a` | Input Select | `0` → Use **A**, `1` → Use **M (RAM[A])** |
| `c1` | `zx` | Zero the **x** input (D) |
| `c2` | `nx` | Negate the **x** input |
| `c3` | `zy` | Zero the **y** input (A or M) |
| `c4` | `ny` | Negate the **y** input |
| `c5` | `f` | `1` → Perform Addition (`x+y`), `0` → Perform Bitwise AND (`x&y`) |
| `c6` | `no` | Negate the ALU output |

So the CPU literally performs this connection:

```
        C-Instruction

      a c1 c2 c3 c4 c5 c6
      │ │  │  │  │  │  │
      │ │  │  │  │  │  │
      ▼ ▼  ▼  ▼  ▼  ▼  ▼
      a zx nx zy ny  f no
              ALU
```

No decoding or lookup is required—the bits are wired directly to the ALU's control inputs.

---

## Example 1 — `D+A`

From the computation table:

| Computation | Binary |
|------------|---------|
| `D+A` | `0000010` |

Breaking it apart:

| Bit | Value | Meaning |
|-----|------|---------|
| `a` | `0` | Use **A** as the second input |
| `zx` | `0` | Keep **D** unchanged |
| `nx` | `0` | Do not negate **D** |
| `zy` | `0` | Keep **A** unchanged |
| `ny` | `0` | Do not negate **A** |
| `f` | `1` | Perform **Addition** |
| `no` | `0` | Do not negate the result |

The ALU therefore computes:

```
D + A
```

---

## Example 2 — `D&M`

From the computation table:

| Computation | Binary |
|------------|---------|
| `D+M` | `1000010` |

Breaking it apart:

| Bit | Value | Meaning |
|-----|------|---------|
| `a` | `1` | Use **M (RAM[A])** instead of **A** |
| `zx` | `0` | Keep D unchanged |
| `nx` | `0` | Do not negate D |
| `zy` | `0` | Keep M unchanged |
| `ny` | `0` | Do not negate M |
| `f` | `1` | Perform Addition |
| `no` | `0` | Do not negate the output |

The ALU computes:

```
D + M
```

Notice that the only difference from `D+A` is the **a bit**.

```
D+A

0 000010
↑
Use A

↓

D+M

1 000010
↑
Use M
```

---

## Example 3 — `D|A`

From the computation table:

| Computation | Binary |
|------------|---------|
| `D|A` | `0010101` |

Breaking it apart:

| Bit | Value | Meaning |
|-----|------|---------|
| `a` | `0` | Use A |
| `zx` | `0` | Keep D |
| `nx` | `1` | Negate D |
| `zy` | `0` | Keep A |
| `ny` | `1` | Negate A |
| `f` | `0` | Perform AND |
| `no` | `1` | Negate the output |

At first glance this looks strange because the ALU only knows **AND** and **ADD**.

However, using **De Morgan's Law**,

```
D | A

=

!(!D & !A)
```

the ALU can produce an OR operation by:

1. Negating D
2. Negating A
3. Performing AND
4. Negating the final result

Thus, even though the ALU has no dedicated OR circuit, it can still compute OR using its existing control signals.

---

## The Big Picture

The computation table in the Hack specification is actually a **catalog of ALU configurations**.

Each row tells the CPU:

> "Set these seven control bits, feed them into the ALU, and the ALU will automatically produce the requested computation."

In other words,

```
Assembly Instruction

      D|M

        │

        ▼

comp bits

1010101

        │

        ▼

a zx nx zy ny f no

1  0  1  0  1 0 1

        │

        ▼

Configure the ALU

        │

        ▼

ALU Output = D | M
```

This is why the `comp` table and the ALU truth table look so similar—they describe the **same control signals**, just from two different perspectives.