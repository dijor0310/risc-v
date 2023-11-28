library IEEE;

use ieee.numeric_bit.all;
use IEEE.STD_LOGIC_ARITH.ALL;

use WORK.cpu_defs_pack.all;
use std.textio.all;


package print_trace_pack is
    
   
    procedure print_header( variable f: out text);
    procedure print_tail( variable f: out text);
    procedure write_PC_CMD(
        variable l: inout line;
        constant PC: in DataType;
        constant OP: in OpType;
        constant X, Y, Z: in RegAddrType);
    procedure write_param(
        variable l: inout line;
        constant P: in DataType);
    procedure write_no_param(
        variable l: inout line);
    procedure write_regs(
        variable l: inout line;
        constant R0, R1, R2, R3: in DataType);
    function hex_image ( d: DataType) return string;
    function cmd_image ( cmd: OPType) return string;
    function bool_character(b : boolean ) return character;
end print_trace_pack;



package body print_trace_pack is
    
    procedure print_header( variable f: out text) is
        variable l: line;
        begin
            
            write(l, string'("PC  | Cmd  | XYZ | P   | R0  | R1  | R2  | R3  | ZCNO"));
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
        constant X, Y, Z: in Reg_Addr_Type) is
        
        begin 
                write(  l , hex_image (PC), left, 3);
                write( l , string'(" | ") );
                write( l , cmd_image (OP), left, 4);
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
                result(3) := hex_table (d mod 16 + 1);
                result(2) := hex_table ((d / 16) mod 16 + 1);
                result(1) := hex_table (d / 256 + 1);
                return result;
                
    end hex_image;
      
    function cmd_image (cmd: Opcode_Type) return string is
        begin
            case cmd is
                when code_nop => "nop ";
                
                when code_lb =>  return mnemonic_lb;
                when code_lbu =>  return mnemonic_lbu;
                when code_lh =>  return mnemonic_lh;
                when code_lhu =>  return mnemonic_lhu;
                when code_lw =>  return mnemonic_lw;
                when code_sb =>  return mnemonic_sb;
                when code_sh =>  return mnemonic_sh;
                when code_sw =>  return mnemonic_sw;
                when code_add =>  return mnemonic_add;
                when code_sub =>  return mnemonic_sub;
                when code_addi =>  return mnemonic_addi;
                when code_lui =>  return mnemonic_lui;
                when code_auipc =>  return mnemonic_auipc;
                when code_xor =>  return mnemonic_xor;
                when code_or =>  return mnemonic_or;
                when code_and =>  return mnemonic_and;
                when code_xori =>  return mnemonic_xori;                 
                when code_ori =>  return mnemonic_ori;
                when code_andi =>  return mnemonic_andi;
                when code_sll =>  return mnemonic_sll;
                when code_srl =>  return mnemonic_srl;
                when code_sra =>  return mnemonic_sra;
                when code_slli =>  return mnemonic_slli;
                when code_srli =>  return mnemonic_srli;
                when code_srai =>  return mnemonic_srai;
                when code_slt =>  return mnemonic_slt;
                when code_sltu =>  return mnemonic_sltu;
                when code_slti =>  return mnemonic_slti;
                when code_sltiu =>  return mnemonic_sltiu;
                when code_beq =>  return mnemonic_beq;
                when code_bne =>  return mnemonic_bne;
                when code_blt =>  return mnemonic_blt;
                when code_bge =>  return mnemonic_bge;
                when code_bltu =>  return mnemonic_bltu;
                when code_bgeu =>  return mnemonic_bgeu;
                when code_jal =>  return mnemonic_jal;
                when code_jalr =>  return mnemonic_jalr;
                
                when others => 
                    assert FALSE
                    report "Illegal command in cmd_image"
                    severity waring;
                    return "";
            end case;        
    end cmd_image;
        
    function bool_character (b: boolean ) return character is             
        begin
            if b then return 'T';
            else return 'F';
            end if;
    end bool_character;
                        
end print_trace_pack;
