library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;

package instr_encode_pack is

end instr_encode_pack;

package body instr_encode_pack is
    function XORIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & Func3CodeXORI & rd & OpCodeIType;
        begin
            return Instr;
        end XORIcode;
end instr_encode_pack;