# risc-v
## Documentation
### System
`System.vhd` contains the fetch-decode-execute pipeline of a single RISC-V processor
### mem_defs_pack
`mem_defs_pack.vhd` contains init_memory and BitStream2Memory to initialize von Neumann memory with a given RISC-V assembly program
### print_trace_pack
`print_trace_pack.vhd` contains utility functions to print traces during the execution
### cpu_defs_pack
`cpu_defs_pack.vhd` contains all constants and mnemonics for the whole functional model
### instr_exec_pack
`instr_exec_pack.vhd` contains subprograms to run logical and arithmetic operations: (ADD(I), SUB, AND(I), XOR(I), OR(I), shift instructions)
### instr_encode_pack
`instr_encode_pack.vhd` contains subprograms to encode RISC-V instructions as binary code to load it into memory
## TODO
Freely change anything, now everything is more or less placeholder code.
### Andrei
- `cpu_defs_pack.vhd` : All types and constants definitions; check all proper sizes (mnemonics for registers should be added)
- `mem_defs_pack.vhd` : Implement function `init_memory` (2 options):
    - implement `instr_encode_pack.vhd`, as described on slides RISC-V 17.11.2023; use it in `init_memory` to generate test instruction sequences **(easier)**
    - generate `.txt` files with instruction sequences, and read these files in init_memory **(harder, has obscure advantages)**
### Malte
- `print_trace_pack` : All (read) and write functions with FILE-IO for printing traces (reading files may be useful for `init_memory`) 
### Roman
- `System.vhd` : The whole decode-fetch-execute pipeline; increment PC; +configuration
### Diyor
- `instr_exec_pack.vhd` : Implement all logical and arithmetic instructions, and flag handlers
