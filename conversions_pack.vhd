library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.cpu_defs_pack.all;

package conversions_pack is

    function bit_vector2natural(constant A: bit_vector)
        return integer;
    
    function natural2bit_vector(constant A :integer;
     constant data_width : natural)
        return bit_vector;
    
end conversions_pack;
    
package body conversions_pack is

    function bit_vector2natural(constant A: bit_vector)
        return integer is
        begin
            return to_integer(unsigned(to_stdlogicvector(A)));
    end bit_vector2natural;

    function natural2bit_vector(constant A :integer;
    constant data_width : natural)
        return bit_vector is
        begin
            return bit_vector(to_unsigned(A, data_width));
    end natural2bit_vector;

end conversions_pack;