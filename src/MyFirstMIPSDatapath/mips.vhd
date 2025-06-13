library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Datapath is
    Port (
        clk          : in STD_LOGIC;
        rst          : in STD_LOGIC;
        regWrite     : in STD_LOGIC;
        nAdd_Sub     : in STD_LOGIC;
        ALUSrc       : in STD_LOGIC;
        rs, rt, rd   : in STD_LOGIC_VECTOR (4 downto 0);
        immediate    : in STD_LOGIC_VECTOR (31 downto 0);
        readData1, readData2 : out STD_LOGIC_VECTOR (31 downto 0);
        result       : out STD_LOGIC_VECTOR (31 downto 0)
    );
end MIPS_Datapath;

architecture Structural of MIPS_Datapath is
    signal regData1, regData2, aluInput2, aluResult : STD_LOGIC_VECTOR (31 downto 0);

    component RegFile is
        Port (
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            regWrite  : in STD_LOGIC;
            readReg1  : in STD_LOGIC_VECTOR (4 downto 0);
            readReg2  : in STD_LOGIC_VECTOR (4 downto 0);
            writeReg  : in STD_LOGIC_VECTOR (4 downto 0);
            writeData : in STD_LOGIC_VECTOR (31 downto 0);
            readData1 : out STD_LOGIC_VECTOR (31 downto 0);
            readData2 : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component Mux2to1 is
        Port (
            sel    : in STD_LOGIC;
            data0  : in STD_LOGIC_VECTOR (31 downto 0);
            data1  : in STD_LOGIC_VECTOR (31 downto 0);
            result : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component ALU is
        Port (
            A       : in STD_LOGIC_VECTOR (31 downto 0);
            B       : in STD_LOGIC_VECTOR (31 downto 0);
            nAdd_Sub: in STD_LOGIC;
            Result  : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

begin
    -- Register file instantiation
    RegFile_inst : RegFile
        Port map (
            clk => clk,
            rst => rst,
            regWrite => regWrite,
            readReg1 => rs,
            readReg2 => rt,
            writeReg => rd,
            writeData => aluResult,
            readData1 => regData1,
            readData2 => regData2
        );

    -- 2:1 Mux instantiation for ALUSrc
    Mux2to1_inst : Mux2to1
        Port map (
            sel => ALUSrc,
            data0 => regData2,
            data1 => immediate,
            result => aluInput2
        );

    -- ALU instantiation
    ALU_inst : ALU
        Port map (
            A => regData1,
            B => aluInput2,
            nAdd_Sub => nAdd_Sub,
            Result => aluResult
        );

    -- Output data
    readData1 <= regData1;
    readData2 <= regData2;
    result <= aluResult;

end Structural;

