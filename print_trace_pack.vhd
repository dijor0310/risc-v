library IEEE;

use ieee.numeric_bit.all;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.cpu_defs_pack.all;
use WORK.bit_vector_natural_pack.all;
use std.textio.all;


package print_trace_pack is
    
   
    procedure print_header( variable f: out text);
    procedure print_tail( variable f: out text);
    procedure write_PC_CMD(
        variable l: inout line;
        constant PC: in DataType;
        constant OP: in OpType4;
        constant func3: in func3type;
        constant func7: in func7type;
        constant X, Y, Z: in RegAddrType);
    procedure write_param(
        variable l: inout line;
        constant P: in DataType);
    procedure write_no_param(
        variable l: inout line);
    procedure write_regs(
        variable l: inout line;
        constant R0, R1, R2: in DataType);
    procedure write_regs_new(
        variable l: inout line;
        constant Reg: in RegType;
        constant Z, CO, N, O: in bit);
    function hex_image ( d: DataType) return string;
    function hex_image32 ( d: DataType) return string;

    function func7R(f7: Func7Type) return string;
    function func7Im(f7: Func7Type) return string;
    function func3I(f3: Func3Type) return string;
    function func3Im(f3: Func3type) return string;
    function func3S(f3: Func3Type) return string;
    function func3R(f3: Func3Type) return string;
    function func3B(f3: Func3type) return string;
    function funcR(f3: Func3Type; f7: Func7Type) return string;
--    function funcI(f3: Func3Type; f7: Func7Type) return string;
--    function funcIm(f3: Func3Type; f7: Func7Type) return string;
--    function funcS(f3: Func3Type; f7: Func7Type) return string;
--    function funcB(f3: Func3Type; f7: Func7Type) return string;

    function cmd_image ( cmd: opType4; func3: func3type; func7: func7type) return string;
    function bool_character(b : boolean ) return character;
end print_trace_pack;



package body print_trace_pack is
    
    procedure print_header( variable f: out text) is
        variable l: line;
        begin
--            write(l, string'("ZCNO"));
            write(l, string'("PC  | CMD   | RegD | RegS1 | RegS2 | Imm | 'Z''C''N''O' | "));
            for i in 0 to 31 loop
                write(l, string'("Reg") & natural'image(i), left, 8);
                write( l , string'(" | ") );
            end loop;
--            write(l, string'("ZCNO"));
            writeline(f, l);
            
    end procedure print_header;
    
    procedure print_tail( variable f: out text) is
        variable l: line;
        begin
            
            write(l, string'("-----------------------------------------------------"));
            writeline(f, l);
            
    end procedure print_tail;
    
    procedure write_regs_new(
        variable l: inout line;
        constant Reg: in RegType;
        constant Z, CO, N, O: in bit) is
        begin
            write(l, bit'image(Z));
            write(l, bit'image(CO));
            write(l, bit'image(N));
            write(l, bit'image(O));
            write( l , string'(" | ") );
            for i in Reg'reverse_range loop
--                            write(  l , hex_image (R0), left, 3);
--            write( l , string'(" | ") );
--            write(  l , hex_image (R1), left, 3);
--            write( l , string'(" | ") );
--            write(  l , hex_image (R2), left, 3);
--            write( l , string'(" | ") );
                write(l, hex_image32(Reg(i)), left, 5);
                write( l , string'(" | ") );
            end loop;       
    end procedure write_regs_new;
    
    procedure write_PC_CMD(
        variable l: inout line;
        constant PC: in AddrType;
        constant OP: in OpType4;
        constant func3: in func3type;
        constant func7: in func7type;
        constant X, Y, Z: in RegAddrType) is
        
        begin 
                write(  l , hex_image (PC), right, 3);
                write( l , string'(" | ") );
                write( l , cmd_image (OP, func3, func7), left, 4);
                write( l , string'(" | ") );
                write( l , hex_image(sign_extend5(X)), left, 4);
                write( l , string'(" | ") );
                write( l , hex_image(sign_extend5(Y)), left, 5);
                write( l , string'(" | ") );
                write( l , hex_image(sign_extend5(Z)), left, 5);
                write( l , string'(" | ") );
    
    end write_PC_CMD;

    procedure write_param(
        variable l: inout line;
        constant P: in DataType) is
        
        begin 
                write(  l , hex_image (P), left, 3);
                write( l , string'(" | ") );
    
    end write_param;

    procedure write_no_param(
        variable l: inout line) is
        
        begin 
                write(  l , string'("---"), left, 3);
                write( l , string'(" | ") );
    
    end write_no_param;
    
    procedure write_regs(
        variable l: inout line;
        constant R0, R1, R2: in DataType) is
        
        begin 
            write(  l , hex_image (R0), left, 3);
            write( l , string'(" | ") );
            write(  l , hex_image (R1), left, 3);
            write( l , string'(" | ") );
            write(  l , hex_image (R2), left, 3);
            write( l , string'(" | ") );

    end write_regs;

    function hex_image32 ( d: DataType) return string is 
        constant hex_table : string (1 to 16) := "0123456789ABCDEF";
        variable result : string (1 to 8);
        begin
            result(8) := hex_table (bit_vector2natural(d) mod 16 + 1);
            result(7) := hex_table ((bit_vector2natural(d) / 16) mod 16 + 1);
            result(6) := hex_table ((bit_vector2natural(d) / 256) mod 16 + 1);
            result(5) := hex_table ((bit_vector2natural(d) / (256 * 16)) mod 16 + 1);
            result(4) := hex_table ((bit_vector2natural(d) / (256 * 256)) mod 16 + 1);
            result(3) := hex_table ((bit_vector2natural(d) / (256 * 256 * 16)) mod 16 + 1);
            result(2) := hex_table ((bit_vector2natural(d) / (256 * 256 * 256)) mod 16 + 1);
            result(1) := hex_table ((bit_vector2natural(d) / (256 * 256 * 256 * 16)) mod 16 + 1);

            return result;
    end hex_image32;
    
    function hex_image (d : DataType) 
        return string is 
        constant hex_table : string(1 to 16) := "0123456789ABCDEF";
        variable result : string (1 to 3);
            
            begin
                result(3) := hex_table (bit_vector2natural(d) mod 16 + 1);
                result(2) := hex_table ((bit_vector2natural(d) / 16) mod 16 + 1);
                result(1) := hex_table ((bit_vector2natural(d) / 256) mod 16 + 1);
                return result;
                
    end hex_image;
    
    -- deterime cmd_image for R-Type instruction      
    function func7R(f7: Func7Type) return string is
        begin
        case f7 is 
            when F7_OP_SLL => return "SLL  ";
            when F7_OP_SRL => return "SRL  ";
            when F7_OP_SRA => return "SRA  ";
            when F7_OP_XOR => return "XOR  ";
            when F7_OP_OR => return "OR   ";
            when F7_OP_AND => return "AND  ";
            when others => assert false report "Illigal Func7 in function func7r" severity warning;
        end case;
    end func7R;
    
    -- deterime cmd_image for Im-Type instruction    
    function func7Im(f7: Func7Type) return string is
        begin
        case f7 is 
            when F7_OPIMM_SLLI => return "SLLI ";
            when F7_OPIMM_SRLI => return "SRLI ";
            when F7_OPIMM_SRAI => return "SRAI ";
            when others => assert false report "Illigal Func7 in function func7r" severity warning;
        end case;
    end func7Im;
    
    -- deterime cmd_image for I-Type instruction
    function func3I(f3: Func3Type) return string is
        begin
        case f3 is
            when F3_LOAD_LB => return "LB   ";
            when F3_LOAD_LH => return "LH   ";
            when F3_LOAD_LW => return "LW   ";
            when F3_LOAD_LBU => return "LBU  ";
            when F3_LOAD_LHU => return "LHU  ";
            when others => assert false report "Illigal Func3 in function func3I" severity warning;
        end case; 
    end func3I;

    -- deterime cmd_image for Im-Type instruction with reference to Func7Im
    function func3Im(f3: Func3type) return string is
        begin
        case f3 is
            when F3_OPIMM_SLLI => return func7Im(F7_OPIMM_SLLI);
            when F3_OPIMM_SRLI => return func7Im(F7_OPIMM_SRLI);
            when F3_OPIMM_SRAI => return func7Im(F7_OPIMM_SRAI);
            when F3_OPIMM_ADDI => return "ADDI ";
            when F3_OPIMM_XORI => return "XORI ";
            when F3_OPIMM_ANDI => return "ANDI ";
            when F3_OPIMM_ORI => return "ORI  ";
            when others => assert false report "Illigal Func3 in function func3Im" severity warning;
        end case; 
    end func3Im;
    
    -- deterime cmd_image for S-Type instruction
    function func3S(f3: Func3Type) return string is
        begin
        case f3 is
            when F3_STORE_SB => return "SB   ";
            when F3_STORE_SH => return "SH   ";
            when F3_STORE_SW => return "SW   ";
            when others => assert false report "Illigal Func3 in function func3S" severity warning;
        end case; 
    end func3S;
    
    -- deterime cmd_image for R-Type instruction with reference to Func7R
    function func3R(f3: Func3Type) return string is
        begin
        case f3 is
            when F3_OP_SLL => return func7R(F7_OP_SLL);
            when F3_OP_SRL => return func7R(F7_OP_SRL);
            when F3_OP_SRA => return func7R(F7_OP_SRA);
            when F3_OP_XOR => return func7R(F7_OP_XOR);
            when F3_OP_OR => return func7R(F7_OP_OR);
            when F3_OP_AND => return func7R(F7_OP_AND);
            when others => assert false report "Illigal Func3 in function func3R" severity warning;
        end case; 
    end func3R;
    
    -- deterime cmd_image for B-Type instruction
    function func3B(f3: Func3Type) return string is
        begin
        case f3 is
            when F3_BRANCH_BEQ => return "BEQ  ";
            when F3_BRANCH_BNE => return "BNE  ";
            when F3_BRANCH_BLT => return "BLT  ";
            when F3_BRANCH_BGE => return "BGE  ";
            when F3_BRANCH_BLTU => return "BLTU ";
            when F3_BRANCH_BGEU => return "BGEU ";
            when others => assert false report "Illigal Func3 in function func3B" severity warning;
        end case; 
    end func3B;
   
    function funcR(f3: Func3Type; f7: Func7Type) return string is
        variable hybridFunc : bit_vector := f3 & f7;
        begin
        case hybridFunc is
            when F3_OP_SLL & F7_OP_SLL => return "SLL  ";
            when F3_OP_SRL & F7_OP_SRL => return "SRL  ";
            when F3_OP_SRA & F7_OP_SRA => return "SRA  ";
            when F3_OP_XOR & F7_OP_XOR => return "XOR  ";
            when F3_OP_OR & F7_OP_OR => return "OR   ";
            when F3_OP_AND & F7_OP_AND => return "AND  ";
            when others => assert false report "Illegal instruction encoding" severity warning;
        end case;
    end funcR;
--    function funcI(f3: Func3Type; f7: Func7Type) return string;
--    function funcIm(f3: Func3Type; f7: Func7Type) return string;
--    function funcS(f3: Func3Type; f7: Func7Type) return string;
--    function funcB(f3: Func3Type; f7: Func7Type) return string;
    -- Print cmd_image of Instruction
    function cmd_image (cmd: OpType4; func3: func3type; func7: func7type) return string is
        begin
        case cmd is
            when OPCODE_LOAD => return func3I(func3);
            when OPCODE_OPIMM => return func3Im(func3);
            when OPCODE_STORE => return func3S(func3);
            when OPCODE_OP => return funcR(func3, func7);
            when Opcode_BRANCH => return func3B(func3);
            when OPcode_JAL => return "JAL  ";
            when OPcode_JALR => return "JALR ";
            when Opcode_LUI => return "LUI  ";
            when Opcode_AUIPC => return "AUIPC";
        end case;             
    end cmd_image;
    
    function bool_character (b: boolean ) return character is             
        begin
            if b then return 'T';
            else return 'F';
            end if;
    end bool_character;
                        
end print_trace_pack;
