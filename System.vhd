library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.cpu_defs_pack.all;
use work.mem_defs_pack.all;
use work.instr_exec_pack.all;
use work.bit_vector_natural_pack.all;
use work.print_trace_pack.all;
use std.textio.all;

entity System is 
end System;


architecture functional of System is
begin
    process


    -- variables declaration
    -- init Memory as MemType object 
    variable Instr : InstrType; -- instruction to be decoded
    variable Memory : MemType := init_memory;
    variable dumpMemory : MemType;
    variable Reg : RegType;
    variable Reg1 : RegAddrType; -- selection for register 1
    variable Reg2 : RegAddrType; -- selection for register 2
    variable RegD : RegAddrType; -- selection for register D
    variable PC : AddrType := X"0000";
    variable PCTmp: AddrType;
    variable OP : OpType4; -- ALU opcode
    variable PcuOp : PcuOpType; -- ALU opcode
    variable Func: FuncType; -- ALU function
    variable Func3: Func3Type;
    variable Func7: Func7Type;
    variable Zero, Carry, Negative, Overflow : bit := '0' ;
    variable Data : DataType; -- temporary value
    variable DataTmp : DataType; -- temporary value
    variable DataSigned: signed(31 downto 0);
    variable DataImm : DataType; -- immediate value
    variable Imm : Imm12Type;
    variable l : line; 
    file TraceFile : Text open WRITE_MODE is "Trace.mem";

    begin
        dumpMemory := dump_memory( Memory, "Dump.mem" );
        print_header(TraceFile);
        print_tail(TraceFile);
        for i in MemType'reverse_range loop
            -- cmd FETCH

            Instr := get(Memory, PC);
            -- cmd DECODE 
            RegD := Instr(RD_START downto RD_END);
            Reg1 := Instr(RS1_START downto RS1_END);
            Reg2 := Instr(RS2_START downto RS2_END);
            OP := Instr(OPCODE_START downto OPCODE_END_2);
            PcuOp := Instr(1 downto 0);
            Func3 := Instr(FUNCT3_START downto FUNCT3_END);
            Func7 := Instr(FUNCT7_R_START downto FUNCT7_R_END);
            Func := "000000" & Instr(FUNCT7_R_START downto FUNCT7_R_END) & Instr(FUNCT3_START downto FUNCT3_END);
            Imm := Instr(IMM_I_START downto IMM_I_END);
            -- cmd COMPUTE
            if PcuOp = PCU_OP_NOP then
                writeline( TraceFile, l);
                print_tail( TraceFile );
                wait;
            end if;
            write_PC_CMD(l, sign_extend16(PC), OP, Func3, Func7, RegD, Reg1, Reg2);

--            case PcuOp is
--                when PCU_OP_NOP => --Null -- keep PC the same
--                    writeline( TraceFile, l);
--                    print_tail( TraceFile );

--                    wait;
--                when PCU_OP_INC => --increment
--                    PC := INC(PC);
--                    wait; -- stop
--                when PCU_OP_ASSIGN => -- no need for now
--                    wait;
--                when PCU_OP_RESET => 	-- Reset
--                    PC := INC(PC);
--                when others =>
--                    wait;
--            end case;
            case OP is


                --LOAD INSTRUCTION
                when OPCODE_LOAD => 
                        write_param(l,sign_extend(Imm));
                        case Func3 is
                            when F3_LOAD_LB => 
                                            Data := Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_I_START downto IMM_I_END))));
                                            Reg(bit_vector2natural (RegD)) := sign_extend8(Data(7 downto 0));
                            when F3_LOAD_LBU => 
                                            Data := Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_I_START downto IMM_I_END))));
                                            Reg(bit_vector2natural (RegD)) := zero_extend8(Data(7 downto 0));
                            when F3_LOAD_LH => 
                                            Data := Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_I_START downto IMM_I_END))));
                                                Reg(bit_vector2natural (RegD)) := sign_extend16(Data(15 downto 0));
                            when F3_LOAD_LHU => 
                                            Data := Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_I_START downto IMM_I_END))));
                                            Reg(bit_vector2natural (RegD)) := zero_extend16(Data(15 downto 0));
                            when F3_LOAD_LW => 
                                                Data := Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_I_START downto IMM_I_END))));
                                                Reg(bit_vector2natural (RegD)) := Data;
                            when others =>
                        end case;


                --STORE INSTRUCTION 
                when OPCODE_STORE => 
                    case Func3 is
                        when F3_STORE_SB => write_Param(l,get(Memory,PC));
                                            Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END)))) := Reg(bit_vector2natural (RegD));
                        when F3_STORE_SH => write_Param(l,get(Memory,PC));
                                            Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END)))) := sign_extend16(Reg(bit_vector2natural (RegD))(15 downto 0));
                        when F3_STORE_SW => write_Param(l,get(Memory,PC));
                                            Memory(bit_vector2natural(Reg(bit_vector2natural (Reg1))) + bit_vector2natural(sign_extend(Instr(IMM_S_A_START downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END)))) := sign_extend8(Reg(bit_vector2natural (RegD))(7 downto 0));
                        when others =>
                    end case;


                -- ARITHMETICAL, LOGICAL, SHIFT AND COMPARE INSTRUCTIONS (REGISTER)
                when OPCODE_OP => 
                    case Func3 & Func7 is

                        -- arithmetical
                        when F3_OP_ADD & F7_OP_ADD => write_no_param(l);
                                                    EXEC_ADD (Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural (Reg2)), '0', Reg(bit_vector2natural(RegD)), Zero, Carry, Negative, Overflow);
                        when F3_OP_SUB & F7_OP_SUB => write_no_param(l);
                                                    EXEC_SUB (Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural (Reg2)), '0', Reg(bit_vector2natural(RegD)), Zero, Carry, Negative, Overflow);

                        -- logical
                        when F3_OP_AND & F7_OP_AND => write_no_param(l);
                                                    Data := "AND"(Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural(Reg2)));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_OR & F7_OP_OR => write_no_param(l);
                                                    Data := "OR"(Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural(Reg2)));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_XOR & F7_OP_XOR => write_no_param(l);
                                                    Data := "XOR"(Reg(bit_vector2natural(Reg1)), Reg(bit_vector2natural(Reg2)));
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);

--                        -- shift
                        when F3_OP_SRL & F7_OP_SRL => write_no_param(l);
--                                                    Data := shift_right(signed(Reg(bit_vector2natural(Reg1))), bit_vector2natural(Reg(bit_vector2natural(Reg2))));
                                                    DataTmp := Reg(bit_vector2natural(Reg1));
                                                    shiftSRL: for k in 0 to bit_vector2natural(Reg(bit_vector2natural(Reg2))) loop
                                                        EXEC_SRL(DataTmp,Data,Carry, Overflow);
                                                        DataTmp := Data;
                                                    end loop shiftSRL;
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SLL & F7_OP_SLL => write_no_param(l);
                                                    DataTmp := Reg(bit_vector2natural(Reg1));
                                                    shiftSLL: for k in 0 to bit_vector2natural(Reg(bit_vector2natural(Reg2))) loop
                                                        EXEC_SLL(DataTmp,Data,Carry, Overflow);
                                                        DataTmp := Data;
                                                    end loop shiftSLL;                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SRA & F7_OP_SRA => write_no_param(l);
                                                    DataTmp := Reg(bit_vector2natural(Reg1));
                                                    shiftSRA: for k in 0 to bit_vector2natural(Reg(bit_vector2natural(Reg2))) loop
                                                        EXEC_SRA(DataTmp,Data,Carry, Overflow);
                                                        DataTmp := Data;
                                                    end loop shiftSRA;                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);

                        -- compare
                        when F3_OP_SLT & F7_OP_SLT => write_no_param(l);
                                                    EXEC_SLT(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OP_SLTU & F7_OP_SLTU => write_no_param(l);
                                                    EXEC_SLTU(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                    Reg(bit_vector2natural (RegD)) := Data;
                                                    Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when others =>
                    end case;


                -- ADD UPPER IMMEDIATE TO PC
                when OPCODE_AUIPC => write_param(l, sign_extend20(Instr(IMM_U_START downto IMM_U_END)));
                                    Data := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(Instr(IMM_U_START-12 downto IMM_U_END) & "000000000000"), 32);
                                    Reg(bit_vector2natural (RegD)) := Data;
                                    Set_Flags_Load(Data,Zero,Negative,Overflow);


                -- LOAD UPPER IMMEDIATE
                when OPCODE_LUI => write_param(l, sign_extend20(Instr(IMM_U_START downto IMM_U_END)));
                                    Data := Instr(IMM_U_START downto IMM_U_END) & "000000000000";
                                    Reg(bit_vector2natural (RegD)) := Data;
                                    Set_Flags_Load(Data,Zero,Negative,Overflow);


                -- ARITHMETICAL, LOGICAL, SHIFT AND COMPARE INSTRUCTIONS (IMMEDIATE)
                when OPCODE_OPIMM => 
                    case Func3 is
                        --arithmetical imm
                        when F3_OPIMM_ADDI => write_param(l, sign_extend(Imm));
                                            EXEC_ADD(Reg(bit_vector2natural(Reg1)), sign_extend(Instr(IMM_I_START downto IMM_I_END)), '0', Data, Zero, Carry, Negative, Overflow);
                                            Reg(bit_vector2natural (RegD)) := Data;
--                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        --logical imm
                        when F3_OPIMM_XORI => 
                                            write_no_param(l);
                                            Data := "XOR"(Reg(bit_vector2natural(Reg1)), sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_ORI => write_no_param(l);
                                            Data := "OR"(Reg(bit_vector2natural(Reg1)), sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_ANDI => write_no_param(l);
                                            Data := "AND"(Reg(bit_vector2natural(Reg1)), sign_extend(Instr(IMM_I_START downto IMM_I_END)));
                                            Reg(bit_vector2natural (RegD)) := Data;
                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        -- compare imm
                        when F3_OPIMM_SLTI => write_no_param(l);
                                            EXEC_SLT(Reg(bit_vector2natural (Reg1)), sign_extend(Imm),Data);
                                            if Data(0) = '1' then
                                                Reg(bit_vector2natural (RegD)) := X"00000001";
                                            else
                                                Reg(bit_vector2natural (RegD)) := X"00000000";
                                            end if;
                        when F3_OPIMM_SLTIU => write_no_param(l);
                                            EXEC_SLT(Reg(bit_vector2natural (Reg1)), sign_extend(Imm),Data);
                                            if Data(0) = '0' then
                                                Reg(bit_vector2natural (RegD)) := X"00000001";
                                            else
                                                Reg(bit_vector2natural (RegD)) := X"00000000";
                                            end if;
                        when others =>
                    end case;

                    case Func3 & Func7 is
                        --shift imm
                        when F3_OPIMM_SLLI & F7_OPIMM_SLLI => write_no_param(l);
                                                            DataTmp := Reg(bit_vector2natural(Reg1));
                                                            shiftSLLI: for k in 0 to bit_vector2natural(sign_extend(Imm)) loop
                                                                EXEC_SLL(DataTmp,Data,Carry, Overflow);
                                                                DataTmp := Data;
                                                            end loop shiftSLLI;

                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_SRLI & F7_OPIMM_SRLI => write_no_param(l);
                                                            DataTmp := Reg(bit_vector2natural(Reg1));
                                                            shiftSRLI: for k in 0 to bit_vector2natural(sign_extend(Imm)) loop
                                                                EXEC_SRL(DataTmp,Data,Carry, Overflow);
                                                                DataTmp := Data;
                                                            end loop shiftSRLI;
                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                        when F3_OPIMM_SRAI & F7_OPIMM_SRAI => write_no_param(l);
                                                            DataTmp := Reg(bit_vector2natural(Reg1));
                                                            shiftSRAI: for k in 0 to bit_vector2natural(sign_extend(Imm)) loop
                                                                EXEC_SRA(DataTmp,Data,Carry, Overflow);
                                                                DataTmp := Data;
                                                            end loop shiftSRAI;
                                                            Reg(bit_vector2natural (RegD)) := Data;
                                                            Set_Flags_Logic(Data,Zero,Negative,Overflow);
                            when others =>
                    end case;                                            
                    
                    -- BRANCH INSTRUCTIONS
                    when OPCODE_BRANCH => write_param(l, sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0"));
                        case Func3 is
                            when F3_BRANCH_BEQ =>
                                                if Reg(bit_vector2natural (Reg1)) = Reg(bit_vector2natural (Reg2)) then
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when F3_BRANCH_BNE => 
                                                if Reg(bit_vector2natural (Reg1)) /= Reg(bit_vector2natural (Reg2)) then
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when F3_BRANCH_BLT =>
                                                EXEC_SLT(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                if Data(0) = '1' then
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when F3_BRANCH_BGE =>
                                                EXEC_SLT(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                if Data(0) = '1' then
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when F3_BRANCH_BLTU => 
                                                EXEC_SLTU(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                if Data(0) = '1' then
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when F3_BRANCH_BGEU =>
                                                EXEC_SLTU(Reg(bit_vector2natural (Reg1)), Reg(bit_vector2natural (Reg2)), Data);
                                                if Data(0) = '0' then                                                    
                                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend13(Instr(IMM_S_A_START) & Instr(IMM_S_B_END) & Instr(IMM_S_A_START - 1 downto IMM_S_A_END) & Instr(IMM_S_B_START downto IMM_S_B_END + 1) & "0")), 16);
                                                else
                                                    PC := INC(PC);
                                                end if;
                            when others =>
                        end case;
                    
                    -- JUMP INSTRUCTIONS
                    when OPCODE_JAL => write_no_param(l);
                                    Reg(bit_vector2natural (RegD)) := sign_extend16(INC(PC));
                                    PC := natural2bit_vector(bit_vector2natural(PC) + bit_vector2natural(sign_extend20(Instr(IMM_J_A_START) & Instr(IMM_J_B_START downto IMM_J_B_END) & Instr(IMM_J_A_END) & Instr(IMM_J_A_START -1 downto IMM_J_A_END + 1))), 16);
                    when OPCODE_JALR => write_no_param(l);
                                    PCTmp := INC(PC);
                                    PC := natural2bit_vector(bit_vector2natural(Reg(bit_vector2natural(Reg1))) + bit_vector2natural(sign_extend(Imm)), 16); 
                                    Reg(bit_vector2natural (RegD)) := sign_extend16(PCTmp);
        when others =>
        end case;
        
        write_regs_new(l, Reg, Zero, Carry, Negative, Overflow);
        writeline( TraceFile, l);
        if PcuOp =  PCU_OP_RESET then 	-- Reset
            PC := INC(PC);
        end if;
        end loop;
    end process;

end functional;


configuration functional_conf of System is 

    for functional

    end for;

end functional_conf;