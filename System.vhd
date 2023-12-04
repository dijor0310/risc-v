library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.instr_exec_pack.all;
use work.bit_vector_natural_pack.all;
use work.print_trace_pack.all;

entity System is 
end System;


architecture functional of System is
begin
    process


    -- variables declaration
    -- init Memory as MemType object 
    variable Instr : InstrType; -- instruction to be decoded
    variable Memory : MemType := init_memory;
--    variable Memory16
    variable Memory1 : MemType;
    variable Reg : RegType;
    variable Reg1 : RegAddrType; -- selection for register 1
    variable Reg2 : RegAddrType; -- selection for register 2
    variable RegD : RegAddrType; -- selection for register D
    variable PC : AddrType := X"00000000";
    variable OP : OpType6; -- ALU opcode
    variable PcuOp : PcuOpType; -- ALU opcode
    variable Func: FuncType; -- ALU function
    variable Func3: Func3Type;
    variable Func7: Func7Type;
    variable Zero, Carry, Negative, Overflow : bit := '0' ;
    variable Data : DataType; -- temporary value
    variable DataImm : DataType; -- immediate value

 
    begin
        loop

            -- cmd FETCH

            Instr := get(Memory, PC);

            -- cmd DECODE 

            RegD := Instr(RD_START downto RD_END);
            Reg1 := Instr(RS1_START downto RS1_END);
            Reg2 := Instr(RS2_START downto RS2_END);
            OP := Instr(OPCODE_START downto OPCODE_END);
            PcuOp := Instr(OPCODE_START downto OPCODE_END_2);
            Func3 := Instr(FUNCT3_START downto FUNCT3_END);
            Func7 := Instr(FUNCT7_R_START downto FUNCT7_R_END);
            Func := "000000" & Instr(FUNCT7_R_START downto FUNCT7_R_END) & Instr(FUNCT3_START downto FUNCT3_END);
            PC := INC(PC);

            -- cmd COMPUTE

            case PcuOp is
                when PCU_OP_NOP => Null -- keep PC the same
                    write_no_param( l );
                when PCU_OP_INC => --increment
--                    PC <= bit_vector(unsigned(PC) + 4); -- 32bit byte addressing
                    PC := INC(PC);
                    wait; -- stop
                when PCU_OP_ASSIGN => -- no need for now
                    wait;
                when PCU_OP_RESET => 	-- Reset
                    PC := ADDR_RESET;
                when others =>
            end case;
            case OP is


                --LOAD INSTRUCTION
                when OPCODE_LOAD => write_Param(l,get(Memory,PC));
                        case Func3 is
                            when F3_LOAD_LB => write_Param(l,get(Memory,PC));
                                            Data := Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := sign_extend(Data);
                            when F3_LOAD_LBU => write_Param(l,get(Memory,PC));
                                            Data := Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := zero_extend(Data);
                            when F3_LOAD_LH => write_Param(l,get(Memory,PC));
                                            Data := Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                                Reg(bit_vector2natural (RegD)) := sign_extend(Data);
                            when F3_LOAD_LHU => write_Param(l,get(Memory,PC));
                                            Data := Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := zero_extend(Data);
                            when F3_LOAD_LW => write_Param(l,get(Memory,PC));
                                                Data := Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                                Reg(bit_vector2natural (RegD)) := Data;
                            when others =>
                        end case;


                --STORE INSTRUCTION 
                when OPCODE_STORE => write_Param(l,set(Memory,PC));
                    case Func3 is
                        when F3_STORE_SB => write_Param(l,set(Memory,PC));
                                            Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END))) := Reg(bit_vector2natural (RegD));
                        when F3_STORE_SH => write_Param(l,set(Memory,PC));
                                            Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END))) := Reg(bit_vector2natural (RegD))(15 downto 0);
                        when F3_STORE_SW => write_Param(l,set(Memory,PC));
                                            Memory(Reg(bit_vector2natural (Reg1)) + sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END))) := Reg(bit_vector2natural (RegD))(7 downto 0);
                        when others =>
                    end case;


                -- ARITHMETICAL, LOGICAL, SHIFT AND COMPARE INSTRUCTIONS (REGISTER)
                when OPCODE_OP => write_no_param(1);
                    case Func3 & Func7 is

                        -- arithmetical
                        when F3_OP_ADD & F7_OP_ADD => write_no_param(1);
                                                    EXEC_ADD (Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural (Reg2)), '0', Reg(bit_vector2natural(RegD)), Zero, Carry, Negative, Overflow);
                        when F3_OP_SUB & F7_OP_SUB => write_no_param(1);
                                                    EXEC_SUB (Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural (Reg2)), '0', Reg(bit_vector2natural(RegD)), Zero, Carry, Negative, Overflow);

                        -- logical
                        when F3_OP_AND & F7_OP_AND => write_no_param(1);
                                                    Data := Reg(bit_vector2natural(Reg1)) AND Reg(bit_vector2natural(Reg2));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_OR & F7_OP_OR => write_no_param(1);
                                                    Data := Reg(bit_vector2natural(Reg1)) OR Reg(bit_vector2natural(Reg2));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_XOR & F7_OP_XOR => write_no_param(1);
                                                    Data := Reg(bit_vector2natural(Reg1)) XOR Reg(bit_vector2natural(Reg2));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);

                        -- shift
                        when F3_OP_SRL & F7_OP_SRL => write_no_param(1);
                                                    Data := shift_right(unsigned(Reg1), to_integer(unsigned(Reg2(4 downto 0))));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SLL & F7_OP_SLL => write_no_param(1);
                                                    Data := shift_left(unsigned(Reg1), to_integer(unsigned(Reg2(4 downto 0))));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SRA & F7_OP_SRA => write_no_param(1);
                                                    Data := shift_right(signed(Reg1), to_integer(unsigned(Reg2(4 downto 0))));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);

                        -- compare
                        when F3_OP_SLT & F7_OP_SLT => write_no_param(1);
                                                    Data := SLT(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SLTU & F7_OP_SLTU => write_no_param(1);
                                                    Data := SLTU(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when others =>
                    end case;


                -- ADD UPPER IMMEDIATE TO PC
                when OPCODE_AUIPC => write_no_param(1);
                                    Data := PC + sign_extend(Instr(IMM_U_START downto IMM_U_END) & "000000000000");
                                    Reg(bit_vector2natural (RegD)) := Data;
                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);


                -- LOAD UPPER IMMEDIATE
                when OPCODE_LUI => write_no_param(1);
                                    Data := sign_extend(Instr(IMM_U_START downto IMM_U_END) & "000000000000");
                                    Reg(bit_vector2natural (RegD)) := Data;
                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);


                -- ARITHMETICAL, LOGICAL, SHIFT AND COMPARE INSTRUCTIONS (IMMEDIATE)
                when OPCODE_OPIMM => write_no_param(1);
                    case Func3 is
                        --arithmetical imm
                        when F3_OPIMM_ADDI => write_no_param(1);
                                            Data := signed(bit_vector2natural(Reg1)) + signed(Instr(IMM_I_START downto IMM_I_END));
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        --logical imm
                        when F3_OPIMM_XORI => write_no_param(1);
                                            Data := Reg(bit_vector2natural(Reg1)) XOR sign_extend(Instr(IMM_I_START downto IMM_I_END));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_ORI => write_no_param(1);
                                            Data := Reg(bit_vector2natural(Reg1)) OR sign_extend(Instr(IMM_I_START downto IMM_I_END));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_ANDI => write_no_param(1);
                                            Data := Reg(bit_vector2natural(Reg1)) OR sign_extend(Instr(IMM_I_START downto IMM_I_END));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        -- compare imm
                        when F3_OPIMM_SLTI => write_no_param(1);
                                            if signed(bit_vector2natural(Reg1)) < signed(sign_extend(Instr(IMM_I_START downto IMM_I_END))) then
                                                Reg(bit_vector2natural (RegD)) := X"0000000001";
                                            else
                                                Reg(bit_vector2natural (RegD)) := X"0000000000";
                        when F3_OPIMM_SLTIU => write_no_param(1);
                                            if unsigned(bit_vector2natural(Reg1)) < unsigned(sign_extend(Instr(IMM_I_START downto IMM_I_END))) then
                                                Reg(bit_vector2natural (RegD)) := X"0000000001";
                                            else
                                                Reg(bit_vector2natural (RegD)) := X"0000000000";
                        when others =>
                    end case;

                    case Func3 & Func7 is
                        --shift imm
                        when F3_OPIMM_SLLI & F7_OPIMM_SLLI => write_no_param(1);
                                                            Data := shift_left(unsigned(Reg1), to_integer(unsigned(sign_extend(Instr(IMM_I_START downto IMM_I_END)))(4 downto 0)));
                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_SRLI & F7_OPIMM_SRLI => write_no_param(1);
                                                            Data := shift_right(unsigned(Reg1), to_integer(unsigned(sign_extend(Instr(IMM_I_START downto IMM_I_END)))(4 downto 0)));
                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_SRAI & F7_OPIMM_SRAI => write_no_param(1);
                                                            Data := shift_right(signed(Reg1), to_integer(unsigned(sign_extend(Instr(IMM_I_START downto IMM_I_END)))(4 downto 0)));
                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                            when others =>
                    end case;                                        
                    
                    -- BRANCH INSTRUCTIONS
                    when OPCODE_BRANCH => write_no_param(1);
                        case Func3 is
                            when F3_BRANCH_BEQ => write_no_param(1);
                                                if Reg(bit_vector2natural (Reg1)) = Reg(bit_vector2natural (Reg2)) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when F3_BRANCH_BNE => write_no_param(1);
                                                if Reg(bit_vector2natural (Reg1)) /= Reg(bit_vector2natural (Reg2)) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when F3_BRANCH_BLT => write_no_param(1);
                                                if signed(Reg(bit_vector2natural (Reg1))) < signed(Reg(bit_vector2natural (Reg2))) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when F3_BRANCH_BGE => write_no_param(1);
                                                if signed(Reg(bit_vector2natural (Reg1))) >= signed(Reg(bit_vector2natural (Reg2))) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when F3_BRANCH_BLTU => write_no_param(1);
                                                if unsigned(Reg(bit_vector2natural (Reg1))) < unsigned(Reg(bit_vector2natural (Reg2))) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when F3_BRANCH_BGEU => write_no_param(1);
                                                if unsigned(Reg(bit_vector2natural (Reg1))) >= unsigned(Reg(bit_vector2natural (Reg2))) then
                                                    PC := PC + sign_extend(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0");
                                                else
                                                    PC := PC + 4;
                                                end if;
                            when others =>
                        end case;
                    
                    -- JUMP INSTRUCTIONS
                    when OPCODE_JAL => write_no_param(1);
                                    Reg(bit_vector2natural (RegD)) := PC + 4;
                                    PC := PC + sign_extend(Instr(IMM_J_A_START) & Instr(IMM_J_B_START downto IMM_J_B_END) & Instr(IMM_J_A_END) & Instr(IMM_J_A_START -1 downto IMM_J_A_END + 1));
                    when OPCODE_JALR => write_no_param(1);
                                    Data := PC + 4;
                                    PC := sign_extend(Reg(bit_vector2natural (RegD)) + Instr(IMM_I_START downto IMM_I_END));
                                    Reg(bit_vector2natural (RegD)) := Data;
    end process;

end functional;


configuration functional_conf of System is 

    for functional

    end for;

end functional_conf;