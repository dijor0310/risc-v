library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.numeric_bit.all;   

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

    -- register address size
    constant RegAddrSize : integer := 5;

    -- assuming BusDatasize == RegDataSize
    constant DataSize : integer := 32; 

    constant ADDR_RESET: bit_vector(AddrSize-1 downto 0) :=  X"0000";


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

    constant IMM_J_A_START: integer := 31;
    constant IMM_J_A_END: integer := 20;

    constant IMM_J_B_START: integer := 19;
    constant IMM_J_B_END: integer := 12;

    

    -- subtypes
    subtype AddrType is bit_vector (AddrSize-1 downto 0);
    subtype InstrType is bit_vector (InstrSize-1 downto 0);
    subtype BusDataType is bit_vector (BusDataSize-1 downto 0);
    subtype RegDataType is bit_vector (RegDataSize-1 downto 0);
    subtype DataType is bit_vector (DataSize-1 downto 0);
    
    -- type for rd, rs1, rs2
    subtype RegAddrType is bit_vector(RegAddrSize-1 downto 0);
    type RegType is array (2**RegAddrSize-1 downto 0) of DataType;
    type MemType is array (2**AddrSize-1 downto 0) of DataType;

    -- type for op-field, funct3 and imm TODO!
    -- dont know whether i need all imm declaration (delete comment after System.vhd is ready) 
    subtype PcuOpType is bit_vector(1 downto 0);
    subtype OpType4 is bit_vector(4 downto 0);
    subtype OpType6 is bit_vector(6 downto 0);
    subtype FuncType is bit_vector(15 downto 0);
    subtype Func2Type is bit_vector(1 downto 0);
    subtype Func3Type is bit_vector(2 downto 0);
    subtype Func7Type is bit_vector(6 downto 0);
    subtype Imm5Type is bit_vector(4 downto 0);
    subtype Imm7Type is bit_vector(6 downto 0);
    subtype Imm12Type is bit_vector(11 downto 0);
    subtype Imm20Type is bit_vector(19 downto 0);
    subtype Imm8Type is bit_vector(7 downto 0);
    subtype Imm16Type is bit_vector(15 downto 0);
    subtype Imm13Type is bit_vector(12 downto 0);
    -- test variables -- TO DELETE
--    variable PC : AddrType := X"0000";
--    variable Instr : InstrType := (others => '0');
--    variable Reg : RegType := (others => (others => '0') );

--    variable Mem: MemType := (others => (others => '0') );
    -- end test variables;



    -- PC unit opcodes
    constant PCU_OP_NOP: PcuOpType := "00";
    constant PCU_OP_INC: PcuOpType := "01";
    constant PCU_OP_ASSIGN: PcuOpType := "10";
    constant PCU_OP_RESET:  PcuOpType := "11";

    -- Opcodes
    constant OPCODE_LOAD: OpType4 := "00000";
    constant OPCODE_STORE: OpType4 := "01000";
    constant OPCODE_BRANCH: OpType4 := "11000";
    constant OPCODE_JALR: OpType4 := "11001";
    constant OPCODE_JAL: OpType4 := "11011";
    constant OPCODE_SYSTEM: OpType4 := "11100";
    constant OPCODE_OP: OpType4 := "01100";
    constant OPCODE_OPIMM: OpType4 := "00100";
    constant OPCODE_MISCMEM: OpType4 := "00011";
    constant OPCODE_AUIPC: OpType4 := "00101";
    constant OPCODE_LUI: OpType4 := "01101";

    -- Flags
    constant F3_LOAD_LB: Func3Type := "000";
    constant F3_LOAD_LH: Func3Type := "001";
    constant F3_LOAD_LW: Func3Type := "010";
    constant F3_LOAD_LBU: Func3Type := "100";
    constant F3_LOAD_LHU: Func3Type := "101";

    constant F3_STORE_SB: Func3Type := "000";
    constant F3_STORE_SH: Func3Type := "001";
    constant F3_STORE_SW: Func3Type := "010";

    constant F3_BRANCH_BEQ: Func3Type := "000";
    constant F3_BRANCH_BNE: Func3Type := "001";
    constant F3_BRANCH_BLT: Func3Type := "100";
    constant F3_BRANCH_BGE: Func3Type := "101";
    constant F3_BRANCH_BLTU: Func3Type := "110";
    constant F3_BRANCH_BGEU: Func3Type := "111";

    constant F3_JALR: Func3Type := "000";

    constant F3_OPIMM_ADDI: Func3Type := "000";
    constant F3_OPIMM_SLTI: Func3Type := "010";
    constant F3_OPIMM_SLTIU: Func3Type := "011";
    constant F3_OPIMM_XORI: Func3Type := "100";
    constant F3_OPIMM_ORI: Func3Type := "110";
    constant F3_OPIMM_ANDI: Func3Type := "111";

    constant F3_OPIMM_SLLI: Func3Type := "001";
    constant F7_OPIMM_SLLI: Func7Type := "0000000";
    constant F3_OPIMM_SRLI: Func3Type := "101";
    constant F7_OPIMM_SRLI: Func7Type := "0000000";
    constant F3_OPIMM_SRAI: Func3Type := "101";
    constant F7_OPIMM_SRAI: Func7Type := "0100000";

    constant F3_OP_ADD: Func3Type := "000";
    constant F7_OP_ADD: Func7Type := "0000000";
    constant F3_OP_SUB: Func3Type := "000";
    constant F7_OP_SUB: Func7Type := "0100000";
    constant F3_OP_SLL: Func3Type := "001";
    constant F7_OP_SLL: Func7Type := "0000000";
    constant F3_OP_SLT: Func3Type := "010";
    constant F7_OP_SLT: Func7Type := "0000000";
    constant F3_OP_SLTU: Func3Type := "011";
    constant F7_OP_SLTU: Func7Type := "0000000";
    constant F3_OP_XOR: Func3Type := "100";
    constant F7_OP_XOR: Func7Type := "0000000";
    constant F3_OP_SRL: Func3Type := "101";
    constant F7_OP_SRL: Func7Type := "0000000";
    constant F3_OP_SRA: Func3Type := "101";
    constant F7_OP_SRA: Func7Type := "0100000";
    constant F3_OP_OR: Func3Type := "110";
    constant F7_OP_OR: Func7Type := "0000000";
    constant F3_OP_AND: Func3Type := "111";
    constant F7_OP_AND: Func7Type := "0000000";
    -- end test opcode constants;

    -- mnemonics 
    constant mnemonic_nop : string( 1 to 3 ) := "nop";
    constant mnemonic_stop: string( 1 to 4 ) := "stop";
    -- Jump instruction --
    constant mnemonic_jmp : string( 1 to 3 ) := "jmp";
    constant mnemonic_jz : string( 1 to 2 ) := "jz";
    constant mnemonic_jc : string( 1 to 2 ) := "jc";
    constant mnemonic_jn : string( 1 to 2 ) := "jn";
    constant mnemonic_jo : string( 1 to 2 ) := "jo";
    constant mnemonic_jnz : string( 1 to 3 ) := "jnz";
    constant mnemonic_jno : string( 1 to 3 ) := "jno";
    constant mnemonic_jnn : string( 1 to 3 ) := "jnn";
    constant mnemonic_jnc : string( 1 to 3 ) := "jnc";
    -- Logic and arithmetic instruction --
    constant mnemonic_not : string( 1 to 3 ) := "not";
    constant mnemonic_and : string( 1 to 3 ) := "and";
    constant mnemonic_add : string( 1 to 3 ) := "add";
    constant mnemonic_addc : string( 1 to 4 ) := "addc";
    constant mnemonic_sub : string( 1 to 3 ) := "sub";
    constant mnemonic_subc : string( 1 to 4 ) := "subc";
    constant mnemonic_or : string( 1 to 2 ) := "or";
    constant mnemonic_xor : string( 1 to 3 ) := "xor";
    constant mnemonic_srl : string( 1 to 3 ) := "srl";
    constant mnemonic_sll : string( 1 to 3 ) := "sll";
    constant mnemonic_sra : string( 1 to 3 ) := "sra";
    constant mnemonic_slt : string( 1 to 3 ) := "slt";
    constant mnemonic_sltu : string( 1 to 4 ) := "sltu";
    -- load and store PC instructions --
    constant mnemonic_ldpc: string( 1 to 4 ) := "ldpc";
    constant mnemonic_stpc: string( 1 to 4 ) := "stpc";
    -- In and Out instructions --
    constant mnemonic_in: string( 1 to 2 ) := "in";
    constant mnemonic_out: string( 1 to 3 ) := "out";

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