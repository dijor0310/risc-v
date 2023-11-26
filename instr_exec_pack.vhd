library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.conversions_pack.all;
use work.cpu_defs_pack.all;

package instr_exec_pack is
    
    function INC(p:addr_type)
        return addr_type;
    
    procedure EXEC_ADDC (
        constant A,B : in data_type;
        constant CI : in Boolean;
        variable R : out data_type;
        variable Z,CO,N,O : out Boolean );

    procedure EXEC_SUBC (
        constant A,B : in data_type;
        constant CI : in Boolean;
        variable R : out data_type;
        variable Z,CO,N,O : out Boolean );
    
    procedure EXEC_SLL (
        constant A : in data_type;
        variable R : out data_type;
        variable CO : out bit;
        variable O : out bit );

    procedure EXEC_SRL (
        constant A : in data_type;
        variable R : out data_type;
        variable CO : out bit;
        variable O : out bit ); 

    procedure EXEC_SRA (
        constant A : in data_type;
        variable R : out data_type;
        variable CO : out bit;
        variable O : out bit );

    procedure EXEC_ROLC (
        constant A : in data_type;
        constant CI : in bit;
        variable R : out data_type;
        variable CO : out bit );

    procedure RORC (
        constant A : in data_type;
        constant CI : in bit;
        variable R : out data_type;
        variable CO : out bit );

    function "NOT" (constant A :data_type)
        return data_type;

    function "AND" (constant A, B :data_type)
        return data_type;
        
    function "OR" (constant A, B :data_type)
        return data_type;

    function "XOR" (constant A, B :data_type)
        return data_type;


end instr_exec_pack;

-- Implementation of logic and arithmetic instructions
-- Notes:
    -- bit'pos() - type cast <bit> to <integer>
    -- bit'val() - type cast <integer> to <bit>
package body instr_exec_pack is

    function INC( A : in addr_type ) return addr_type is
        variable C : bit := '1'; -- carry to calculate next PC (NOT carry flag!)
        variable T: integer range 0 to 2; -- temporal sum
        variable R : addr_type; -- result
        begin
            -- bitwise sum of A and '1' 
            for i in A'reverse_range loop -- iteration starts with LSB
                T := bit'pos(A(i)) + bit'pos(C);
                R(i) := bit'val(T mod 2);
                C := bit'val(T / 2);
            end loop;
            return R;
        end INC;
    
    procedure EXEC_ADDC (
            constant A,B : in data_type;
            constant CI : in bit;
            variable R : out data_type;
            variable Z,CO,N,O : out bit ) is
        variable C_TMP : bit := CI;
        variable N_TMP : bit;
        variable R_TMP : data_type;
        variable T : integer range 0 to 3;
        constant zero_v: data_type := (others => '0');
        begin
            for i in A'reverse_range loop
                T := bit'pos(A(i)) + bit'pos(B(i)) + bit'pos(C_TMP);
                R_TMP(i) := bit'val(T mod 2);
                C_TMP := bit'val(T / 2);
            end loop;
            CO := C_TMP;
            T := bit'pos(A(A'length-1)) + bit'pos(B(B'length-1)) + bit'pos(C_TMP);
            N_TMP := bit'val(T mod 2);
            O := R_TMP( data_width-1 ) XOR N_TMP;
            N := N_TMP;
            R := R_TMP;
            Z := bit'val(boolean'pos(R_TMP = zero_v));
        end EXEC_ADDC;

    procedure EXEC_SUBC (
            constant A,B : in data_type;
            constant CI : in bit;
            variable R : out data_type;
            variable Z,CO,N,O : out bit ) is
        variable C_TMP : bit := CI;
        variable N_TMP : bit;
        variable R_TMP : data_type;
        variable T : integer range 0 to 3;
        constant zero_v: data_type := (others => '0');
        begin
            for i in A'reverse_range loop
                T := bit'pos(A(i)) - bit'pos(B(i)) - bit'pos(C_TMP);
                R_TMP(i) := bit'val(T mod 2);
                C_TMP := bit'val(T / 2);
            end loop;
            CO := C_TMP;
            -- should check this!!!
            T := bit'pos(A(A'length-1)) + bit'pos(B(B'length-1)) + bit'pos(C_TMP);
            N_TMP := bit'val(T mod 2);
            O := R_TMP( data_width-1 ) XOR N_TMP;
            N := N_TMP;
            R := R_TMP;
            Z := bit'val(boolean'pos(R_TMP = zero_v));
        end EXEC_SUBC;

    procedure EXEC_SLL (
            constant A : in data_type;
            variable R : out data_type;
            variable CO : out bit;
            variable O : out bit ) is
        begin
            CO := A(A'left);
            O := A(A'left) xor A(A'left-1);
            R := A(A'left-1 downto 0) & '0';
        end EXEC_SLL;
    
    procedure EXEC_ROLC (
            constant A : in data_type;
            constant CI : in bit;
            variable R : out data_type;
            variable CO : out bit ) is
        begin
            CO := A(A'left);
            R := A(A'left-1 downto 0) & CI;
        end EXEC_ROLC;

end instr_exec_pack;