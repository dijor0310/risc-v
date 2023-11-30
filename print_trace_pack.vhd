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
        constant PC: in Data_Type;
        constant OP: in Opcode_Type;
        constant func3: in func3_type;
        constant func7: in func7_type;
        constant X, Y, Z: in Reg_Addr_Type);
    procedure write_param(
        variable l: inout line;
        constant P: in Data_Type);
    procedure write_no_param(
        variable l: inout line);
    procedure write_regs(
        variable l: inout line;
        constant R0, R1, R2, R3: in Data_Type);
    function hex_image ( d: Data_Type) return string;
    function func7R(f7: Func7_Type) return string;
    function func7Im(f7: Func7_Type) return string;
    function func3I(f3: Func3_Type) return string;
    function func3Im(f3: Func3_Type) return string;
    function func3S(f3: Func3_Type) return string;
    function func3R(f3: Func3_Type) return string;
    function func3B(f3: Func3_Type) return string;
    function cmd_image ( cmd: code_Type; func3: func3_type; func7: func7_type) return string;
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
        constant PC: in Data_Type;
        constant OP: in Opcode_Type;
        constant func3: in func3_type;
        constant func7: in func7_type;
        constant X, Y, Z: in Reg_Addr_Type) is
        
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
        constant P: in Data_Type) is
        
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
        constant R0, R1, R2, R3: in Data_Type) is
        
        begin 
            write(  l , hex_image (R0), left, 3);
            write( l , string'(" | ") );
            write(  l , hex_image (R1), left, 3);
            write( l , string'(" | ") );
            write(  l , hex_image (R2), left, 3);
            write( l , string'(" | ") );
            write(  l , hex_image (R3), left, 3);
            write( l , string'(" | ") );

    end write_regs;
                    
    function hex_image (d : Data_Type) 
        return string is 
        constant hex_table : string(1 to 16) := "0123456789ABCDEF";
        variable result : string (1 to 3);
            
            begin
                result(3) := hex_table (bit_vector2natural(d) mod 16 + 1);
                result(2) := hex_table ((bit_vector2natural(d) / 16) mod 16 + 1);
                result(1) := hex_table (bit_vector2natural(d) / 256 + 1);
                return result;
                
    end hex_image;
          
    function func7R(f7: Func7_Type) return string is
        begin
        case f7 is 
            when func7codesll => return "SLL  ";
            when func7codesrl => return "SRL  ";
            when func7codesra => return "SRA  ";
            when func7codexor => return "XOR  ";
            when func7codeor => return "OR   ";
            when func7codeand => return "AND  ";
            when others => assert false report "Illigal Func7 in function func7r" severity waring;
        end case;
    end func7R;
        
    function func7Im(f7: Func7_Type) return string is
        begin
        case f7 is 
            when func7codeslli => return "SLLI ";
            when func7codesrli => return "SRLI ";
            when func7codesrai => return "SRAI ";
            when others => assert false report "Illigal Func7 in function func7r" severity waring;
        end case;
    end func7Im;
    
    function func3I(f3: Func3_Type) return string is
        begin
        case f3 is
            when func3codelb => return "LB   ";
            when func3codelh => return "LH   ";
            when func3codelw => return "LW   ";
            when func3codelbu => return "LBU  ";
            when func3codelhu => return "LHU  ";
            when others => assert false report "Illigal Func3 in function func3I" severity waring;
        end case; 
    end func3I;

    function func3Im(f3: Func3_Type) return string is
        begin
        case f3 is
            when func3codeslli => return func7Im(func7codeslli);
            when func3codesrli => return func7Im(func7codesrli);
            when func3codesrai => return func7Im(func7codesrai);
            when others => assert false report "Illigal Func3 in function func3Im" severity waring;
        end case; 
    end func3Im;
    
    function func3S(f3: Func3_Type) return string is
        begin
        case f3 is
            when func3codeSb => return "SB   ";
            when func3codesh => return "SH   ";
            when func3codesw => return "SW   ";
            when others => assert false report "Illigal Func3 in function func3S" severity waring;
        end case; 
    end func3S;
    
    function func3R(f3: Func3_Type) return string is
        begin
        case f3 is
            when func3codesll => return func7R(func7codesll);
            when func3codesrl => return func7R(func7codesrl);
            when func3codesra => return func7R(func7codesra);
            when func3codexor => return func7R(func7codexor);
            when func3codeor => return func7R(func7codeor);
            when func3codeand => return func7R(func7codeand);
            when others => assert false report "Illigal Func3 in function func3R" severity waring;
        end case; 
    end func3R;
    
    function func3B(f3: Func3_Type) return string is
        begin
        case f3 is
            when func3codebeq => return "BEQ  ";
            when func3codebne => return "BNE  ";
            when func3codeblt => return "BLT  ";
            when func3codebge => return "BGE  ";
            when func3codebltu => return "BLTU ";
            when func3codebgeu => return "BGEU ";
            when others => assert false report "Illigal Func3 in function func3B" severity waring;
        end case; 
    end func3B;

    function cmd_image (cmd: Opcode_Type; func3: func3_type; func7: func7_type) return string is
        begin
        case cmd is
            when OpcodeIType => return func3I(func3);
            when OpcodeImType => return func3Im(func3);
            when OpcodeSType => return func3S(func3);
            when OpcodeRType => return func3R(func3);
            when OpcodeBType => return func3B(func3);
            when OPcodeJAL => return "JAL  ";
            when OPcodeJALR => return "JALR ";
            when OpcodeLUI => return "LUI  ";
            when OpcodeAUIPC => return "AUIPC";
        end case;             
    end cmd_image;
    
    function bool_character (b: boolean ) return character is             
        begin
            if b then return 'T';
            else return 'F';
            end if;
    end bool_character;
                        
end print_trace_pack;
