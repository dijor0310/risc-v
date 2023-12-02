library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.instr_exec_pack.all;
use work.bit_vector_natural_pack.all;

entity System is 
end System;


architecture functional of System is
begin
    process


    -- variables declaration
    -- init Memory as MemType object TODO!
    variable Instr : InstrType; -- instruction to be decoded
    variable Memory: MemType := init_memory;
    variable Reg1 : RegType; -- selection for register 1
    variable Reg2 : RegType; -- selection for register 2
    variable RegD : RegType; -- selection for register D
    variable PC : AddrType := X"000";
    variable OP : OpcodeType; -- ALU opcode
    variable PcuOp : OpcodeType; -- ALU opcode
    variable Func: FuncType; -- ALU function
    variable Zero, Carry, Negative, Overflow : bit := '0' ;
    variable Data : DataType; -- temporary value
    variable DataImm : DataType; -- immediate value

    -- Files TODO!


    -- Memory := 
    begin
        loop
            -- cmd FETCH
            Instr := get(Memory, PC);
            -- cmd DECODE 
            RegD := Instr(RD_STAR downto RD_END);
            Reg1 := Instr(RS1_START downto RS1_END);
            Reg2 := Instr(RS2_START downto RS2_END)
            OP := Instr(OPCODE_START downto OPCODE_END);
            PcuOp := Instr(OPCODE_START downto OPCODE_END_2);
            Func3 := Instr(FUNCT3_START downto FUNCT3_END);
            Func7 := Instr(FUNCT7_START downto FUNCT7_END);
            Func := "000000" & Instr(FUNCT7_START downto FUNCT7_END) & Instr(FUNCT3_START downto FUNCT3_END);
            PC := INC(PC);
            -- cmd COMPUTE
            case PcuOp is
                when PCU_OP_NOP => Null -- keep PC the same
                    write_no_param( l );
                when PCU_OP_INC => --increment
                    PC <= bit_vector(unsigned(PC) + 4); -- 32bit byte addressing
                    wait; -- stop
                when PCU_OP_ASSIGN => -- no need for now
                    wait;
                when PCU_OP_RESET => 	-- Reset
                    PC := ADDR_RESET;
                when others =>
            end case;

            case OP is

                --load instruction TODO!
                when OPCODE_LOAD => write_Param(l,get(Memory,PC));
                        case Func3 is
                            when F3_LOAD_LB =>
                            -- to do
                            Set_Flags_Load(Data,Zero,Negative,Overflow);
                            PC:=INC(PC);
                            when F3_LOAD_LH =>
                            when F3_LOAD_LW =>
                            when F3_LOAD_LBU =>
                            when F3_LOAD_LHU =>
                            when others =>
                        end case;

                --store instruction TODO!
                when OPCODE_STORE => write_Param(l,get(Memory,PC));
                if PcuOp = PCU_OP_RESET then
                    case Func3 is
                        when F3_STORE_SB =>
                        when F3_STORE_SH =>
                        when F3_STORE_SW =>
                        when others =>
                    end case;
                else
                Null;

                -- ARITHMETICAL, LOGICAL AND SHIFT INSTRUCTIONS
                when OPCODE_OP => write_no_param(1);
                    case Func3 & Func7 is
                            -- not immediate logical and arithmetical instructions
                            when F3_OP_ADD & F7_OP_ADD => 
                                write_no_param(1);
                                EXEC_ADD (Reg(bit_vector2natural()), Reg(bit_vector2natural ()), '0', Reg(bit_vector2natural()), Zero, Carry, Negative, Overflow);
                            when F3_OP_SUB & F7_OP_SUB => 
                                write_no_param(1);
                                EXEC_SUB (Reg(bit_vector2natural()), Reg(bit_vector2natural ()), '0', Reg(bit_vector2natural()), Zero, Carry, Negative, Overflow);
                            when F3_OP_XOR & F7_OP_XOR => 
                                write_no_param(1);
                                Data := Reg(bit_vector2natural(Reg1)) XOR Reg(bit_vector2natural(Reg2));
                                Reg(bit_vector2natural (RegD)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                            when F3_OP_AND & F7_OP_AND => 
                                write_no_param(1);
                                Data := Reg(bit_vector2natural(Reg1)) AND Reg(bit_vector2natural(Reg2));
                                Reg(bit_vector2natural (RegD)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);
                            when F3_OP_OR & F7_OP_OR => 
                                write_no_param(1);
                                Data := Reg(bit_vector2natural(Reg1)) OR Reg(bit_vector2natural(Reg2));
                                Reg(bit_vector2natural (RegD)) := Data;
                                Set_Flags_Logic(Data,Zero,Negative,Overflow);

                            --shift instructions
                            when F3_OP_SRL & F7_OP_SRL =>
                            write_no_param(1);
                            EXEC_SRL (Reg(bit_vector2natural()), Reg(bit_vector2natural ()), '0', Reg(bit_vector2natural()), Zero, Carry, Negative, Overflow);
                            
                    end case;
                     
                    -- immediate
                    case Func3 is
                        when F3_OPIMM_ADDI => 
                        write_no_param(1);
                        Data := signed(Reg1) + signed(Instr(IMM_I_START downto IMM_I_END));
                        Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_LUI => 
                        EXEC_LUI ('0', Reg(bit_vector2natural(RegD)), Zero, Carry, Negative, Overflow); --DIYOR!!!
                        when F3_OPIMM_XORI => 
                        write_no_param(1);
                        --TODO further!!!
                    

  






                            
                            





                



    end process;

end functional;


configuration functional_conf of System is 

    for functional

    end for;

end functional_conf;