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
        constant OP: in OpType;
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
    function hex_image ( d: DataType) return string;
    function func7R(f7: Func7Type) return string;
    function func7Im(f7: Func7Type) return string;
    function func3I(f3: Func3Type) return string;
    function func3Im(f3: Func3type) return string;
    function func3S(f3: Func3Type) return string;
    function func3R(f3: Func3Type) return string;
    function func3B(f3: Func3type) return string;
    function cmd_image ( cmd: opType; func3: func3type; func7: func7type) return string;
    function bool_character(b : boolean ) return character;
end print_trace_pack;



package body print_trace_pack is
    
    procedure print_header( variable f: out text) is
        variable l: line;
        begin
            
            write(l, string'("PC  | Cmd  | Rd  | Func3   | Rs1  | Rs2  | R2  | Imm  | ZCNO"));
            writeline(f, l);
            
    end procedure print_header;
    
    procedure print_tail( variable f: out text) is
        variable l: line;
        begin
            
            write(l, string'("-----------------------------------------------------"));
            writeline(f, l);
            
    end procedure print_tail;
    
    procedure write_PC_CMD(
        variable l: inout line;
        constant PC: in DataType;
        constant OP: in OpType;
        constant func3: in func3type;
        constant func7: in func7type;
        constant X, Y, Z: in RegAddrType) is
        
        begin 
                write(  l , hex_image (PC), left, 3);
                write( l , string'(" | ") );
                write( l , cmd_image (OP, func3, func7), left, 4);
                write( l , string'(" | ") );
                write( l , X, left, 1);
                write( l , Y, left, 1);
                write( l , Z, left, 1);
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
                    
    function hex_image (d : DataType) 
        return string is 
        constant hex_table : string(1 to 16) := "0123456789ABCDEF";
        variable result : string (1 to 3);
            
            begin
                result(3) := hex_table (bit_vector2natural(d) mod 16 + 1);
                result(2) := hex_table ((bit_vector2natural(d) / 16) mod 16 + 1);
                result(1) := hex_table (bit_vector2natural(d) / 256 + 1);
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
            when others => assert false report "Illigal Func7 in function func7r" severity waring;
        end case;
    end func7R;
    
    -- deterime cmd_image for Im-Type instruction    
    function func7Im(f7: Func7Type) return string is
        begin
        case f7 is 
            when F7_OPIMM_SLLI => return "SLLI ";
            when F7_OPIMM_SRLI => return "SRLI ";
            when F7_OPIMM_SRAI => return "SRAI ";
            when others => assert false report "Illigal Func7 in function func7r" severity waring;
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
            when others => assert false report "Illigal Func3 in function func3I" severity waring;
        end case; 
    end func3I;

    -- deterime cmd_image for Im-Type instruction with reference to Func7Im
    function func3Im(f3: Func3type) return string is
        begin
        case f3 is
            when F3_OPIMM_SLLI => return func7Im(F7_OPIMM_SLLI);
            when F3_OPIMM_SRLI => return func7Im(F7_OPIMM_SRLI);
            when F3_OPIMM_SRAI => return func7Im(F7_OPIMM_SRAI);
            when others => assert false report "Illigal Func3 in function func3Im" severity waring;
        end case; 
    end func3Im;
    
    -- deterime cmd_image for S-Type instruction
    function func3S(f3: Func3Type) return string is
        begin
        case f3 is
            when F3_STORE_SB => return "SB   ";
            when F3_STORE_SH => return "SH   ";
            when F3_STORE_SW => return "SW   ";
            when others => assert false report "Illigal Func3 in function func3S" severity waring;
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
            when others => assert false report "Illigal Func3 in function func3R" severity waring;
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
            when others => assert false report "Illigal Func3 in function func3B" severity waring;
        end case; 
    end func3B;
    
    -- Print cmd_image of Instruction
    function cmd_image (cmd: OpType; func3: func3type; func7: func7type) return string is
        begin
        case cmd is
            when OPCODE_LOAD => return func3I(func3);
            when OPCODE_OPIMM => return func3Im(func3);
            when OPCODE_STORE => return func3S(func3);
            when OPCODE_OP => return func3R(func3);
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
