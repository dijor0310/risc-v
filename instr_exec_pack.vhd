library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.bit_vector_natural_pack.all;
use work.cpu_defs_pack.all;

package instr_exec_pack is
    
    function INC(A:AddrType)
        return AddrType;

--    function sext(p:DataType)
--        return DataType;
    
    procedure EXEC_ADD (
        constant A,B : in DataType;
        constant CI : in bit;
        variable R : out DataType;
        variable Z,CO,N,O : out bit );

    procedure EXEC_SUB (
        constant A,B : in DataType;
        constant CI : in bit;
        variable R : out DataType;
        variable Z,CO,N,O : out bit );
    
    procedure EXEC_SLL (
        constant A : in DataType;
        variable R : out DataType;
        variable CO : out bit;
        variable O : out bit );

    procedure EXEC_SRL (
        constant A : in DataType;
        variable R : out DataType;
        variable CO : out bit;
        variable O : out bit ); 

    procedure EXEC_SRA (
        constant A : in DataType;
        variable R : out DataType;
        variable CO : out bit;
        variable O : out bit );

    procedure EXEC_LUI (
        constant A : in DataType;
        variable R : out DataType;
        variable CO : out bit;
        variable O : out bit );

    procedure EXEC_AUIPC (
        constant A : in DataType;
        constant PC: in AddrType;
        variable R : out DataType;
        variable CO : out bit;
        variable O : out bit; 
        variable Z,N : out bit );
    
    procedure EXEC_SLTU (
        constant A,B: in DataType;
        variable R : out DataType );
    
    procedure EXEC_SLT (
        constant A,B: in DataType;
        variable R : out DataType );
    
    function "NOT" (constant A : DataType)
        return DataType;

    function "AND" (constant A, B : DataType)
        return DataType;
        
    function "OR" (constant A, B : DataType)
        return DataType;

    function "XOR" (constant A, B : DataType)
        return DataType;


end instr_exec_pack;

-- Implementation of logic and arithmetic instructions
-- Notes:
    -- bit'pos() - type cast <bit> to <integer>
    -- bit'val() - type cast <integer> to <bit>
package body instr_exec_pack is

    function INC( A : in AddrType ) return AddrType is
        variable C : bit := '1'; -- carry to calculate next PC (NOT carry flag!)
        variable T: integer range 0 to 2; -- temporal sum
        variable R : AddrType; -- result
        begin
            -- bitwise sum of A and '1' 
            for i in A'reverse_range loop -- iteration starts with LSB
                T := bit'pos(A(i)) + bit'pos(C);
                R(i) := bit'val(T mod 2);
                C := bit'val(T / 2);
            end loop;
            return R;
        end INC;

    procedure EXEC_ADD (
            constant A,B : in DataType;
            constant CI : in bit;
            variable R : out DataType;
            variable Z,CO,N,O : out bit ) is
        variable C_TMP : bit := CI;
        variable N_TMP : bit;
        variable R_TMP : DataType;
        variable T : integer range 0 to 3;
        constant zero_v: DataType := (others => '0');
        begin
            for i in A'reverse_range loop
                T := bit'pos(A(i)) + bit'pos(B(i)) + bit'pos(C_TMP);
                R_TMP(i) := bit'val(T mod 2);
                C_TMP := bit'val(T / 2);
            end loop;
            CO := C_TMP;
            T := bit'pos(A(A'length-1)) + bit'pos(B(B'length-1)) + bit'pos(C_TMP);
            N_TMP := bit'val(T mod 2);
            O := R_TMP( DataSize-1 ) XOR N_TMP;
            N := N_TMP;
            R := R_TMP;
            Z := bit'val(boolean'pos(R_TMP = zero_v));
        end EXEC_ADD;

    procedure EXEC_SUB (
            constant A,B : in DataType;
            constant CI : in bit;
            variable R : out DataType;
            variable Z,CO,N,O : out bit ) is
        begin
            EXEC_ADD(A,(NOT B),'1',R,Z,CO,N,O);
        end EXEC_SUB;

    procedure EXEC_SLL (
            constant A : in DataType;
            variable R : out DataType;
            variable CO : out bit;
            variable O : out bit ) is
        begin
            CO := A(A'left);
            O := A(A'left) xor A(A'left-1);
            R := A(A'left-1 downto 0) & '0';
        end EXEC_SLL;

    procedure EXEC_SRL (
            constant A : in DataType;
            variable R : out DataType;
            variable CO : out bit;
            variable O : out bit ) is
        begin
            CO := A(0);
            O := A(0) xor A(1);
            R := '0' & A(A'left downto 1);        
        end EXEC_SRL;

    procedure EXEC_SRA (
            constant A : in DataType;
            variable R : out DataType;
            variable CO : out bit;
            variable O : out bit ) is
        begin
            CO := A(0);
            O := A(0) xor A(1);
            R := A(A'left) & A(A'left downto 1);
        end EXEC_SRA;

    procedure EXEC_LUI (
            constant A : in DataType;
            variable R : out DataType;
            variable CO : out bit;
            variable O : out bit ) is
            variable A_TMP: DataType;
            variable R_TMP: DataType;
        begin
            A_TMP := A;
            shift: for k in 0 to 11 loop
                EXEC_SLL(A_TMP,R_TMP,CO,O);
                A_TMP := R_TMP;
            end loop shift;
            R := R_TMP;
        end EXEC_LUI;

    procedure EXEC_AUIPC (
            constant A : in DataType;
            constant PC: in AddrType;
            variable R : out DataType;
            variable CO : out bit;
            variable O : out bit; 
            variable Z,N : out bit ) is
            variable A_TMP: DataType;
            variable R_TMP: DataType;
            variable CO_TMP: bit;
        begin 
            A_TMP := A;
            shift: for k in 0 to 11 loop
                EXEC_SLL(A_TMP,R_TMP,CO_TMP,O);
                A_TMP := R_TMP;
            end loop shift;
            EXEC_ADD(PC,A_TMP,CO_TMP,R,Z,CO_TMP,N,O);
            CO := CO_TMP;
        end EXEC_AUIPC;
    
    procedure EXEC_SLTU (
            constant A,B: in DataType;
            variable R : out DataType ) is
            variable R_TMP: bit;
        begin 
            -- variable R_TMP: bit;
            if bit_vector2natural(A) < bit_vector2natural(B) then R_TMP := bit'val(1);
            else R_TMP := bit'val(0);
            end if;
            R := natural2bit_vector(0, DataSize);
            R(0) := R_TMP;
        end EXEC_SLTU;

    procedure EXEC_SLT (
            constant A,B: in DataType;
            variable R : out DataType ) is 
        begin
            R := natural2bit_vector(0, DataSize);
            if A(A'left) = B(B'left) then EXEC_SLTU(A,B,R);
            elsif A(A'left) = '1' then R(0) := '1';
            else R(0) := '0';
            end if;
        end EXEC_SLT;
    
    function "NOT" (constant A :DataType) return DataType is
        begin
            return NOT A;
        end "NOT";

    function "AND" (constant A, B :DataType) return DataType is
        begin
            return (A AND B);
        end "AND";
        
    function "OR" (constant A, B :DataType) return DataType is
        begin
            return (A OR B);
        end "OR";

    function "XOR" (constant A, B :DataType) return DataType is 
        begin
            return (A XOR B);
        end "XOR";



end instr_exec_pack;