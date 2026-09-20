# RISC-V Single-Cycle CPU

A beginner-friendly implementation of a **32-bit RISC-V single-cycle processor** written in **Verilog HDL**.

This project was built to understand the fundamentals of processor architecture, RTL design, datapaths, control logic, memory interfaces, and instruction execution.

## Overview

The processor implements a subset of the **RISC-V RV32I instruction set architecture (ISA)** using a single-cycle datapath.

Each instruction completes its execution within a single clock cycle.

### Currently Supported Instructions

| Instruction | Type | Description |
|---|---|---|
| `ADD` | R-type | Add two registers |
| `SUB` | R-type | Subtract two registers |
| `AND` | R-type | Bitwise AND |
| `OR` | R-type | Bitwise OR |
| `ADDI` | I-type | Add immediate |
| `LW` | I-type | Load word from memory |
| `SW` | S-type | Store word to memory |
| `BEQ` | B-type | Branch if registers are equal |

The implementation uses 32-bit registers and data paths.

---

## Architecture

The processor consists of several RTL modules connected to form the complete CPU datapath.

```text
                   ┌─────────────────┐
                   │ Program Counter │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Instruction     │
                   │ Memory          │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │ Instruction     │
                   │ Decoder/Control │
                   └────────┬────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
        ┌──────────────┐        ┌──────────────┐
        │ Register     │        │ Immediate    │
        │ File         │        │ Generator    │
        └──────┬───────┘        └──────┬───────┘
               │                       │
               └──────────┬────────────┘
                          ▼
                   ┌──────────────┐
                   │     ALU      │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Data Memory  │
                   └──────┬───────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ Write Back   │
                   │   MUX        │
                   └──────┬───────┘
                          │
                          ▼
                    Register File
```

---

## Project Structure

```text
risc-v-cpu/
│
├── rtl/
│   ├── cpu.v
│   ├── alu.v
│   ├── regfile.v
│   ├── control.v
│   ├── imem.v
│   └── dmem.v
│
├── tb/
│   └── cpu_tb.v
│
├── program.hex
│
├── waveform/
│   └── cpu.vcd
│
└── README.md
```

> File names may vary depending on the final organization of the project.

### Module Descriptions

#### `cpu.v`

Top-level module that connects the processor's major components and implements the overall datapath.

#### `alu.v`

Performs arithmetic and logical operations such as:

- Addition
- Subtraction
- AND
- OR
- Comparison

#### `regfile.v`

Implements the 32 general-purpose RISC-V registers.

The register file provides:

- Two read ports
- One write port
- Synchronous register updates
- Protection of register `x0` from modification

#### `control.v`

Decodes the instruction opcode and generates the control signals required by the datapath.

#### `imem.v`

Instruction memory used to fetch instructions based on the program counter.

#### `dmem.v`

Data memory used by load and store instructions.

---

## Instruction Execution

The CPU follows the basic single-cycle instruction flow:

```text
PC
 │
 ▼
Instruction Fetch
 │
 ▼
Instruction Decode
 │
 ▼
Register Read
 │
 ▼
Execute / ALU
 │
 ├──────► Memory Access
 │
 ▼
Write Back
 │
 ▼
Next Instruction
```

For most instructions, the next instruction is:

```text
PC + 4
```

For a taken `BEQ` instruction, the program counter is updated using the branch target address.

---

## Example Program

The CPU can execute a small RISC-V program loaded into `program.hex`.

For example:

```asm
ADDI x1, x0, 10
ADDI x2, x0, 20
ADD  x3, x1, x2
SUB  x4, x3, x1
AND  x5, x3, x4
OR   x6, x3, x4
```

After execution:

```text
x1 = 10
x2 = 20
x3 = 30
x4 = 20
x5 = 20
x6 = 30
```

The corresponding machine instructions can be stored in `program.hex` and loaded into instruction memory.

---

## Simulation

The design can be simulated using an open-source Verilog simulator such as **Icarus Verilog**.

### Compile

```bash
iverilog -o cpu_sim rtl/*.v tb/cpu_tb.v
```

### Run

```bash
vvp cpu_sim
```

If waveform dumping is enabled, the testbench will generate a VCD file.

### View Waveforms

The generated waveform can be opened using **GTKWave**:

```bash
gtkwave cpu.vcd
```

Waveforms can be used to inspect signals such as:

- Program counter
- Current instruction
- Register values
- ALU inputs
- ALU output
- Control signals
- Memory address
- Memory write enable
- Write-back data

---

## Verification

The processor is tested using a Verilog testbench that applies clock and reset signals and executes a test program.

The verification process checks:

- Instruction fetching
- Register reads and writes
- ALU operations
- Immediate generation
- Load/store operations
- Branch behavior
- Program counter updates
- Final register values

Waveform inspection is also used to debug the RTL and verify that signals behave as expected over time.

---

## Design Concepts Demonstrated

This project demonstrates several fundamental RTL and digital-design concepts:

- Verilog HDL
- RTL design
- RISC-V ISA
- CPU datapath design
- Control-unit design
- Combinational logic
- Sequential logic
- Register files
- ALU design
- Instruction decoding
- Memory interfaces
- Program-counter logic
- Branch logic
- Testbench development
- Simulation and waveform debugging

---

## Future Improvements

The current implementation is intentionally kept small so that the processor architecture and RTL can be understood clearly.

Planned improvements include:

### ISA Expansion

Add more RV32I instructions:

- `SLT`
- `SLTU`
- `XOR`
- `SLL`
- `SRL`
- `SRA`
- `LUI`
- `AUIPC`
- `JAL`
- `JALR`
- Additional branch instructions
- Additional load/store instructions

### Processor Improvements

- Implement a multi-cycle CPU
- Implement a 5-stage pipeline
- Add forwarding
- Add hazard detection
- Add pipeline stalls
- Add branch handling
- Add CSR support

### Verification Improvements

- Develop a more comprehensive testbench
- Add automated assertions
- Add directed instruction tests
- Add randomized testing
- Compare execution against a reference RISC-V model

### FPGA Implementation

The processor can eventually be synthesized and deployed on an FPGA to demonstrate operation on actual hardware.

---

## Learning Objectives

The primary goal of this project is to develop a practical understanding of how a processor works at the RTL level.

Through this project, I am learning how:

1. RISC-V instructions are encoded.
2. Instructions are fetched and decoded.
3. Register operands are read.
4. The ALU performs operations.
5. Memory accesses are performed.
6. Results are written back to registers.
7. Control signals coordinate the datapath.
8. RTL is simulated and debugged using waveforms.

---

## Tools

- **Verilog HDL**
- **Icarus Verilog**
- **GTKWave**
- **RISC-V ISA**
- **Git / GitHub**

---

## Status

🚧 **Work in Progress**

The current version focuses on building a functional and understandable single-cycle RV32I-style processor. The project will be expanded incrementally toward more advanced processor and RTL-design concepts.

---

## Why This Project?

This project is part of my transition into **digital IC / RTL design and hardware verification**.

Rather than treating the CPU as a black box, the goal is to understand its implementation from the instruction level down to the RTL level, while developing practical skills in:

**Digital Logic → Verilog → RTL Design → Verification → CPU Architecture → ASIC/FPGA Design**

---

## License

This project is intended for educational and portfolio purposes.
