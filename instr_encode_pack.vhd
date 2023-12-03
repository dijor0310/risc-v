library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;

package instr_encode_pack is
    function XORIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;--
    function XORcode( rd, rs1, rs2: RegAddrType) return InstrType;--
    function ANDIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;--
    function ANDcode( rd, rs1, rs2: RegAddrType) return InstrType;--
    -- function NOTcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function ORcode( rd, rs1, rs2: RegAddrType) return InstrType;--
    function ORIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;--
    function ADDcode( rd, rs1, rs2: RegAddrType) return InstrType;--
    function SUBcode( rd, rs1, rs2: RegAddrType) return InstrType;--
    function ADDIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;--
    function LBcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType;
    function LBUcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType;
    function LHcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType;
    function LHUcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType;
    function LWcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType;
    function SBcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType;
    function SHcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType;
    function SWcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType; 
    function LUIcode( rd : RegAddrType; imm : Imm20Type) return InstrType;
    function AUIPCcode( rd : RegAddrType; imm : Imm20Type) return InstrType;
    function SLLcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SRLcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SRAcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SLLIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType;
    function SRLIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType;
    function SRAIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType;
    function SLTcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SLTUcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SLTIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;
    function SLTIUcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;
    -- function BEQcode
    -- function BNEcode
    -- function BLTcode
    -- function BGEcode
    -- function BLTUcode
    -- function BGEUcode
    -- function JALcode
    -- function JALRcode
end instr_encode_pack;

package body instr_encode_pack is
    function XORIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_XORI & rd & OPCODE_OPIMM & PCU_OP_RESET;
        begin
            return Instr;
        end XORIcode;

    function ORIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_ORI & rd & OPCODE_OPIMM & PCU_OP_RESET;
        begin
            return Instr;
        end ORIcode;

    function ANDIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_ANDI & rd & OPCODE_OPIMM & PCU_OP_RESET;
        begin
            return Instr;
        end ANDIcode;
    
    function XORcode( rd, rs1, rs2 : RegAddrType) return InstrType is
        constant Instr : InstrType := F7_OP_XOR & rs2 & rs1 & F3_OP_XOR & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end XORcode;

    function ORcode( rd, rs1, rs2 : RegAddrType) return InstrType is
        constant Instr : InstrType := F7_OP_OR & rs2 & rs1 & F3_OP_OR & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end ORcode;

    function ANDcode( rd, rs1, rs2 : RegAddrType) return InstrType is
        constant Instr : InstrType := F7_OP_AND & rs2 & rs1 & F3_OP_AND & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end ANDcode;    

    function SUBcode( rd, rs1, rs2 : RegAddrType) return InstrType is
        constant Instr : InstrType := F7_OP_SUB & rs2 & rs1 & F3_OP_SUB & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end SUBcode;    

    function ADDIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_ADDI & rd & OPCODE_OPIMM & PCU_OP_RESET;
        begin
            return Instr;
        end ADDIcode;

    function LBcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_LB & rd & OPCODE_LOAD & PCU_OP_RESET;
        begin
            return Instr;
        end LBcode;

    function LBUcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_LBU & rd & OPCODE_LOAD & PCU_OP_RESET;
        begin
            return Instr;
        end LBUcode;

    function LHcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_LH & rd & OPCODE_LOAD & PCU_OP_RESET;
        begin
            return Instr;
        end LHcode;

    function LHUcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType is
        constant Instr : InstrType := imm & rs1 & F3_OP_LHU & rd & OPCODE_LOAD & PCU_OP_RESET;
        begin
            return Instr;
        end LHUcode;

    function LWcode( rd, rs1 : RegAddrType; offset : Imm12Type) return InstrType is 
        constant Instr : InstrType := imm & rs1 & F3_OP_LW & rd & OPCODE_LOAD & PCU_OP_RESET;
        begin
            return Instr;
        end LWcode;

    function SBcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType is
        constant Instr : InstrType := offset1 & rs2 & rs1 & F3_OP_SB & offset2 & OPCODE_STORE & PCU_OP_RESET;
        begin
            return Instr;
        end SBcode;
    function SHcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType is 
        constant Instr : InstrType := offset1 & rs2 & rs1 & F3_OP_SH & offset2 & OPCODE_STORE & PCU_OP_RESET;
        begin
            return Instr;
        end SHcode;
    function SWcode( rs1, rs2 : RegAddrType; offset1 : Imm7Type; offset2 : Imm5Type) return InstrType is
        constant Instr : InstrType := offset1 & rs2 & rs1 & F3_OP_SW & offset2 & OPCODE_STORE & PCU_OP_RESET;
        begin
            return Instr;
        end SWcode;

    function LUIcode( rd : RegAddrType; imm : Imm20Type) return InstrType is
        constant Instr : InstrType := imm & rd & F3_OP_LUI & PCU_OP_RESET;
        begin
            return Instr;
        end LUIcode;

    function AUIPCcode( rd : RegAddrType; imm : Imm20Type) return InstrType is
        constant Instr : InstrType := imm & rd & F3_OP_AUIPC & PCU_OP_RESET;
        begin
            return Instr;
        end AUIPCcode;


    function SLLcode( rd, rs1, rs2: RegAddrType) return InstrType is 
        constant Instr : InstrType := F7_OP_SLL & rs2 & rs1 & F3_OP_SLL & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end SLLcode;

    function SRLcode( rd, rs1, rs2: RegAddrType) return InstrType is
        constant Instr : InstrType := F7_OP_SRL & rs2 & rs1 & F3_OP_SRL & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end SRLcode;

    function SRAcode( rd, rs1, rs2: RegAddrType) return InstrType is 
        constant Instr : InstrType := F7_OP_SRA & rs2 & rs1 & F3_OP_SRA & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end SRAcode;

    function SLLIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType is 
        constant Instr : InstrType := F7_OPIMM_SLLI & imm & rs1 & F3_OP_SLL & rd & OPCODE_OP & PCU_OP_RESET;
        begin
            return Instr;
        end SLLIcode;

    function SRLIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType;
    function SRAIcode( rd, rs1 : RegAddrType; imm : Imm5Type) return InstrType;
    function SLTcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SLTUcode( rd, rs1, rs2: RegAddrType) return InstrType;
    function SLTIcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;
    function SLTIUcode( rd, rs1 : RegAddrType; imm : Imm12Type) return InstrType;
    
end instr_encode_pack;