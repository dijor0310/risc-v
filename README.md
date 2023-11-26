# risc-v

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
