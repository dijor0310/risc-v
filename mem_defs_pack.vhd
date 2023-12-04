library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library work;
--use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;
use work.instr_encode_pack.all;
use std.textio.all;

package mem_defs_pack is
    -- constant memory_content : MemType;
    function init_memory return MemType;
    function BitStream2Mem ( BitStream : bit_vector ) return MemType;
    impure function dump_memory(memory: MemType; filename:string) return MemType;

end mem_defs_pack;

package body mem_defs_pack is
    function init_memory return MemType is
        begin
            return BitStream2Mem(
                XORIcode("00010", "00011", "000010000000"));
    end init_memory;
    
    function BitStream2Mem( BitStream : bit_vector) return MemType is
    variable Mem : MemType;
    variable j : integer := BitStream'left;
        begin
            assert BitStream'length mod 16 = 0;
            for i in MemType'range loop
            if j - 31 >= 0 then
                Mem(i) := BitStream( j downto j-31);
                j := j - 32;
--            elsif j + 15 <= BitStream'length then
--                Mem(i) := X"0000" & BitStream( j to j+15 );
            else
                -- everything is xor -FOR TEST
                Mem(i) := BitStream( 31 downto 0); 
--                Mem(i) := (others => 0);
            end if;
            end loop;
            return Mem;
    end BitStream2Mem;
    
    impure function dump_memory(memory: MemType; filename:string) return MemType is
        file f : text open WRITE_MODE is filename;
        variable l : line;

        begin
        for tmp_addr in memory'low to memory'high loop
            write(l,memory(tmp_addr));
            writeline( f , l );
        end loop;
        return memory;

    end dump_memory;
end mem_defs_pack;
