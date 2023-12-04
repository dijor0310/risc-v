library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.numeric_bit.all;   

library work;
use work.cpu_defs_pack.all;

package bit_vector_natural_pack is

    function bit_vector2natural(constant A: bit_vector)
        return integer;
    
    function natural2bit_vector(constant A :integer;
     constant data_width : natural)
        return bit_vector;
    
     function zero_extend(constant imm: Imm12Type) return bit_vector;
    function sign_extend(constant imm: Imm12Type) return bit_vector;    
end bit_vector_natural_pack;
    
package body bit_vector_natural_pack is

    function bit_vector2natural(constant A: bit_vector)
        return integer is
        begin
            return to_integer(unsigned(A));
    end bit_vector2natural;

    function natural2bit_vector(constant A :integer;
    constant data_width : natural)
        return bit_vector is
        begin
            return bit_vector(to_unsigned(A, data_width));
    end natural2bit_vector;

     function zero_extend(constant imm: Imm12Type) return bit_vector is
         variable i: bit_vector (31 downto 0);
         begin
             i := B"00000000000000000000" & imm;
             return i;                
     end zero_extend;

    function sign_extend(constant imm: Imm12Type) return bit_vector is
        variable i: bit_vector (31 downto 0);
        begin
            if imm(11) = '1' then
                i := B"11111111111111111111" & imm;
            else 
                i := B"00000000000000000000" & imm;
            end if;
            return i;               
    end sign_extend;
end bit_vector_natural_pack;        
