library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
-- use work.type_defs.all

package cpu_defs_pack is
    -- PC, addr wire of bus, memory depth
    constant AddrSize : integer := 16;
    -- (maximum) instruction size
    constant InstrSize : integer := 32;
    -- data wire of bus, memory width
    constant BusDataSize : integer := 32;
    -- register sizes
    constant RegDataSize : integer := 32;
    constant RegAddrSize : integer := 5;

    subtype AddrType is bit_vector (AddrSize-1 downto 0);
    subtype InstrType is bit_vector (InstrSize-1 downto 0);
    subtype BusDataType is bit_vector (BusDataSize-1 downto 0);
    subtype RegDataType is bit_vector (RegDataSize-1 downto 0);
    -- type for rd, rs1, rs2
    subtype RegAddrType is bit_vector(RegAddrSize-1 downto 0);
    type RegType is array (2**RegAddrSize-1 downto 0) of RegDataType;
    type MemType is array (2**AddrSize-1 downto 0) of BusDataType;

    -- type for op-field, funct3 and imm
    subtype OpType is bit_vector(6 downto 0);
    subtype Func3Type is bit_vector(2 downto 0);
    subtype Imm12Type is bit_vector(11 downto 0); 

    -- test variables -- TO DELETE
    variable PC : AddrType := X"0000";
    variable Instr : InstrType := (others => '0');
    variable Reg : RegType := (others => (others => '0') );

    variable Mem: MemType := (others => (others => '0') );
    -- end test variables;

    -- should go to mnemonics
    -- test opcode constants
    constant OpCodeSType : OpType := "0100011";
    -- more to follow …
    constant Func3CodeSb : Func3Type := "000"; -- SB Instruction
    -- more to follow …
    -- end test opcode constants;

    function get (
        constant Memory : in mem_type;
        constant addr : in addr_type )
        return data_type;
    procedure set (
        variable Memory : inout mem_type;
        constant addr : in addr_type;
        constant data : in data_type );

end cpu_defs_pack;


package body cpu_defs_pack is

    function get (
        constant Memory : in MemType;
        constant addr : in AddrType ) return BusDataType is
        begin
            return Memory(to_integer(unsigned(addr)));
    end get;

    procedure set (
        variable Memory : inout MemType;
        constant addr : in AddrType;
        constant data : in BusDataType ) is
        begin
            Memory(to_integer(unsigned(addr))) := data;
    end set;

end cpu_defs_pack;