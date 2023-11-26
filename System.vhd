library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.instr_defs_pack.all;
use work.conversions_pack.all;

entity System is 
end System;


architecture functional of System is
begin
    process
    use work.cpu_defs_pack.all;
    -- init Memory as MemType object TODO!
    Memory := 
    PC :=
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