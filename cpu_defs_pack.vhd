library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
library work;
-- use work.type_defs.all

package cpu_defs_pack is
    

    -- PC, addr wire of bus, memory depth
    constant AddrSize : integer := 16; 
    constant AddrSizeM1 : integer := AddrSize - 1;


    -- (maximum) instruction size
    constant InstrSize : integer := 32; 
    constant InstrSizeM1 : integer := InstrSize - 1;

    -- data wire of bus, memory width
    constant BusDataSize : integer := 32; 
    constant BusDataSizeM1 : integer := BusDataSize - 1;

    -- register sizes
    constant RegDataSize : integer := 32;

    -- register address size
    constant RegAddrSize : integer := 5;

    constant DataSize : integer := 32; -- assuming BusDatasize == RegDataSize


    -- Instruction for Layout Types
    constant OPCODE_START: integer := 6;
    constant OPCODE_END: integer := 0;
    constant OPCODE_END_2: integer := 2;

    constant RD_START: integer := 11;
    constant RD_END: integer := 7;

    constant FUNCT3_START: integer := 14;
    constant FUNCT3_END: integer := 12;

    constant RS1_START: integer := 19;
    constant RS1_END: integer := 15;

    constant RS2_START: integer := 24;
    constant RS2_END: integer := 20;

    constant FUNCT7_R_START: integer := 31;
    constant FUNCT7_R_END: integer := 25;

    constant IMM_I_START: integer := 31;
    constant IMM_I_END: integer := 20;

    constant IMM_U_START: integer := 31;
    constant IMM_U_END: integer := 12;

    constant IMM_S_A_START: integer := 31;
    constant IMM_S_A_END: integer := 25;

    constant IMM_S_B_START: integer := 11;
    constant IMM_S_B_END: integer := 7;

    -- PC unit opcodes
    constant PCU_OP_NOP: bit_vector(1 downto 0):= "00";
    constant PCU_OP_INC: bit_vector(1 downto 0):= "01";
    constant PCU_OP_ASSIGN: bit_vector(1 downto 0):= "10";
    constant PCU_OP_RESET: bit_vector(1 downto 0):= "11";

    -- Opcodes
    constant OPCODE_LOAD: bit_vector(4 downto 0) := "00000";
    constant OPCODE_STORE: bit_vector(4 downto 0) := "01000";
    constant OPCODE_BRANCH: bit_vector(4 downto 0) := "11000";
    constant OPCODE_JALR: bit_vector(4 downto 0) := "11001";
    constant OPCODE_JAL: bit_vector(4 downto 0) := "11011";
    constant OPCODE_SYSTEM: bit_vector(4 downto 0) := "11100";
    constant OPCODE_OP: bit_vector(4 downto 0) := "01100";
    constant OPCODE_OPIMM: bit_vector(4 downto 0) := "00100";
    constant OPCODE_MISCMEM: bit_vector(4 downto 0) := "00011";
    constant OPCODE_AUIPC: bit_vector(4 downto 0) := "00101";
    constant OPCODE_LUI: bit_vector(4 downto 0) := "01101";

    -- Flags
    constant F3_LOAD_LB: bit_vector(2 downto 0) := "000";
    constant F3_LOAD_LH: bit_vector(2 downto 0) := "001";
    constant F3_LOAD_LW: bit_vector(2 downto 0) := "010";
    constant F3_LOAD_LBU: bit_vector(2 downto 0) := "100";
    constant F3_LOAD_LHU: bit_vector(2 downto 0) := "101";

    constant F3_STORE_SB: bit_vector(2 downto 0) := "000";
    constant F3_STORE_SH: bit_vector(2 downto 0) := "001";
    constant F3_STORE_SW: bit_vector(2 downto 0) := "010";

    constant F3_BRANCH_BEQ: bit_vector(2 downto 0) := "000";
    constant F3_BRANCH_BNE: bit_vector(2 downto 0) := "001";
    constant F3_BRANCH_BLT: bit_vector(2 downto 0) := "100";
    constant F3_BRANCH_BGE: bit_vector(2 downto 0) := "101";
    constant F3_BRANCH_BLTU: bit_vector(2 downto 0) := "110";
    constant F3_BRANCH_BGEU: bit_vector(2 downto 0) := "111";

    constant F3_JALR: bit_vector(2 downto 0) := "000";

    constant F2_MEM_LS_SIZE_B: bit_vector(1 downto 0) := "00";
    constant F2_MEM_LS_SIZE_H: bit_vector(1 downto 0) := "01";
    constant F2_MEM_LS_SIZE_W: bit_vector(1 downto 0) := "10";

    constant F3_OPIMM_ADDI: bit_vector(2 downto 0) := "000";
    constant F3_OPIMM_SLTI: bit_vector(2 downto 0) := "010";
    constant F3_OPIMM_SLTIU: bit_vector(2 downto 0) := "011";
    constant F3_OPIMM_XORI: bit_vector(2 downto 0) := "100";
    constant F3_OPIMM_ORI: bit_vector(2 downto 0) := "110";
    constant F3_OPIMM_ANDI: bit_vector(2 downto 0) := "111";

    constant F3_OPIMM_SLLI: bit_vector(2 downto 0) := "001";
    constant F7_OPIMM_SLLI: bit_vector(6 downto 0) := "0000000";
    constant F3_OPIMM_SRLI: bit_vector(2 downto 0) := "101";
    constant F7_OPIMM_SRLI: bit_vector(6 downto 0) := "0000000";
    constant F3_OPIMM_SRAI: bit_vector(2 downto 0) := "101";
    constant F7_OPIMM_SRAI: bit_vector(6 downto 0) := "0100000";

    constant F3_OP_ADD: bit_vector(2 downto 0) := "000";
    constant F7_OP_ADD: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_SUB: bit_vector(2 downto 0) := "000";
    constant F7_OP_SUB: bit_vector(6 downto 0) := "0100000";
    constant F3_OP_SLL: bit_vector(2 downto 0) := "001";
    constant F7_OP_SLL: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_SLT: bit_vector(2 downto 0) := "010";
    constant F7_OP_SLT: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_SLTU: bit_vector(2 downto 0) := "011";
    constant F7_OP_SLTU: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_XOR: bit_vector(2 downto 0) := "100";
    constant F7_OP_XOR: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_SRL: bit_vector(2 downto 0) := "101";
    constant F7_OP_SRL: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_SRA: bit_vector(2 downto 0) := "101";
    constant F7_OP_SRA: bit_vector(6 downto 0) := "0100000";
    constant F3_OP_OR: bit_vector(2 downto 0) := "110";
    constant F7_OP_OR: bit_vector(6 downto 0) := "0000000";
    constant F3_OP_AND: bit_vector(2 downto 0) := "111";
    constant F7_OP_AND: bit_vector(6 downto 0) := "0000000";













    subtype AddrType is bit_vector (AddrSize-1 downto 0);
    subtype InstrType is bit_vector (InstrSize-1 downto 0);
    subtype BusDataType is bit_vector (BusDataSize-1 downto 0);
    subtype RegDataType is bit_vector (RegDataSize-1 downto 0);
    subtype DataType is bit_vector (DataSize-1 downto 0);
    -- type for rd, rs1, rs2
    subtype RegAddrType is bit_vector(RegAddrSize-1 downto 0);
    type RegType is array (2**RegAddrSize-1 downto 0) of DataType;
    type MemType is array (2**AddrSize-1 downto 0) of DataType;

    -- type for op-field, funct3 and imm
    subtype OpType is bit_vector(6 downto 0);
    subtype Func3Type is bit_vector(2 downto 0);
    subtype Imm12Type is bit_vector(11 downto 0); 

    -- test variables -- TO DELETE
--    variable PC : AddrType := X"0000";
--    variable Instr : InstrType := (others => '0');
--    variable Reg : RegType := (others => (others => '0') );

--    variable Mem: MemType := (others => (others => '0') );
    -- end test variables;

    -- should go to mnemonics
    -- test opcode constants
    constant OpCodeSType : OpType := "0100011";
    -- more to follow …
    constant Func3CodeSb : Func3Type := "000"; -- SB Instruction
    constant OpCodeIType : OpType := "0010011";
    constant Func3CodeXORI : Func3Type := "100";
    -- more to follow …
    -- end test opcode constants;

    function get (
        constant Memory : in MemType;
        constant addr : in AddrType )
        return DataType;
    procedure set (
        variable Memory : inout MemType;
        constant addr : in AddrType;
        constant data : in DataType );

end cpu_defs_pack;


package body cpu_defs_pack is

    function get (
        constant Memory : in MemType;
        constant addr : in AddrType ) return DataType is
        begin
            return Memory(to_integer(unsigned(addr)));
    end get;

    procedure set (
        variable Memory : inout MemType;
        constant addr : in AddrType;
        constant data : in DataType ) is
        begin
            Memory(to_integer(unsigned(addr))) := data;
    end set;

end cpu_defs_pack;