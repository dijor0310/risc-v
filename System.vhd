library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.instr_exec_pack.all;
use work.bit_vector_natural_pack.all;

entity System is 
end System;


architecture functional of System is
begin
    process
    -- init Memory as MemType object TODO!
    variable Memory: MemType := init_memory;
    variable Reg : RegType;
    variable Instr : InstrType;
    variable OP : OpcodeType;
    variable X, Y, Z : reg_addr_type; -- change TODO
    variable PC : AddrType := 0;
    variable Zero, Carry, Negative, Overflow : bit := '0' ; -- Flags 

    -- Memory := 
    begin
        -- cmd FETCH TODO
        Instr := Memory(PC)
        opcode := 

        -- cmd DECODE TODO
        -- cmd EXECUTE TODO
    end process;

end functional;


configuration functional_conf of System is 

    for functional

    end for;

end functional_conf;0