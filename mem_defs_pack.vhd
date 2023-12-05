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
--            XORIcode("00010", "00011", "000010000000") &
--                XORIcode("00000", "00001", "000010000000"));  
--                X"FFFFFFFF" &
--                BEQcode( "00000", "00001", "0000000", "00011") &
                ADDIcode("00111", "00011", X"0BF") & 
                ADDIcode("00010", "00011", X"0FF") & 
                SRLcode("00011", "00001", "11100") &
                LUIcode("00000", X"0000F") &
                AUIPCcode("00000", X"000FF") &            
                LWcode( "00011", "00001", "000000111111") &
                LWcode( "00011", "00001", "011111111111") &
                XORcode("00010", "00011", "10000"));
    end init_memory;
    
    function BitStream2Mem( BitStream : bit_vector) return MemType is
    variable Mem : MemType;
    variable j : integer := 0;
        begin
            assert BitStream'length mod 16 = 0;
            for i in MemType'reverse_range loop
            if j + 31 < BitStream'length then
                Mem(i) := BitStream( j to j+31);
                j := j + 32;
----            elsif j + 15 <= BitStream'length then
----                Mem(i) := X"0000" & BitStream( j to j+15 );
--            elsea
--                -- everything is xor -FOR TEST
--                Mem(i) := BitStream( 31 downto 0); 
--                Mem(i) := (others => '0');
            end if;
            end loop;
--                Mem(0) := BitStream(0 to 31);
--                Mem(1) := BitStream(32 to 63);
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
