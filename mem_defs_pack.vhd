library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--library work;
--use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;
use work.instr_encode_pack.all;

package mem_defs_pack is
    -- constant memory_content : MemType;
    function init_memory return MemType;
    function BitStream2Mem ( BitStream : bit_vector ) return MemType;
end mem_defs_pack;

package body mem_defs_pack is
    function init_memory return MemType is
        begin
            return BitStream2Mem(
                XORIcode("00001", "00010", "00011"));
    end init_memory;
    
    function BitStream2Mem( BitStream : bit_vector) return MemType is
    variable Mem : MemType;
    variable j : integer := 0;
        begin
            assert instr'length mod 16 = 0;
            for i in MemType'range loop
            if j + 31 <= BitStream'length then
                Mem(i) := BitStream( j to j+31);
                j := j + 32;
            elsif j + 15 <= BitStream'length then
                Mem(i) := X"0000" & BitStream( j to j+15 );
            else
                Mem(i) := (others => '0');
            end if;
            end loop;
            return Mem;
    end BitStream2Mem;
end mem_defs_pack;
