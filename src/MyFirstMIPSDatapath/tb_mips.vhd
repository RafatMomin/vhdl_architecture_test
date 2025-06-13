library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Testbench_MIPS_Datapath is
end Testbench_MIPS_Datapath;

architecture Behavioral of Testbench_MIPS_Datapath is

    -- Component declaration
    component MIPS_Datapath is
        Port (
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            regWrite  : in  STD_LOGIC;
            nAdd_Sub  : in  STD_LOGIC;
            ALUSrc    : in  STD_LOGIC;
            rs, rt, rd: in  STD_LOGIC_VECTOR (4 downto 0);
            immediate : in  STD_LOGIC_VECTOR (31 downto 0);
            readData1, readData2 : out  STD_LOGIC_VECTOR (31 downto 0);
            result    : out  STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    -- Signal declarations
    signal clk, rst, regWrite, nAdd_Sub, ALUSrc : STD_LOGIC;
    signal rs, rt, rd : STD_LOGIC_VECTOR (4 downto 0);
    signal immediate : STD_LOGIC_VECTOR (31 downto 0);
    signal readData1, readData2, result : STD_LOGIC_VECTOR (31 downto 0);

    -- Clock generation
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: MIPS_Datapath
        Port map (
            clk => clk,
            rst => rst,
            regWrite => regWrite,
            nAdd_Sub => nAdd_Sub,
            ALUSrc => ALUSrc,
            rs => rs,
            rt => rt,
            rd => rd,
            immediate => immediate,
            readData1 => readData1,
            readData2 => readData2,
            result => result
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- Test case: addi $1, $0, 1
        regWrite <= '1';
        nAdd_Sub <= '0';
        ALUSrc <= '1';
        rs <= "00000"; -- $0
        rt <= "00000";
        rd <= "00001"; -- $1
        immediate <= "00000000000000000000000000000001"; -- 1
        wait for clk_period;

        -- Test case: addi $2, $0, 2
        rd <= "00010"; -- $2
        immediate <= "00000000000000000000000000000010"; -- 2
        wait for clk_period;

        -- Test case: addi $3, $0, 3
        rd <= "00011"; -- $3
        immediate <= "00000000000000000000000000000011"; -- 3
        wait for clk_period;

        -- Test case: addi $4, $0, 4
        rd <= "00100"; -- $4
        immediate <= "00000000000000000000000000000100"; -- 4
        wait for clk_period;

        -- Test case: addi $5, $0, 5
        rd <= "00101"; -- $5
        immediate <= "00000000000000000000000000000101"; -- 5
        wait for clk_period;

        -- Test case: addi $6, $0, 6
        rd <= "00110"; -- $6
        immediate <= "00000000000000000000000000000110"; -- 6
        wait for clk_period;

        -- Test case: addi $7, $0, 7
        rd <= "00111"; -- $7
        immediate <= "00000000000000000000000000000111"; -- 7
        wait for clk_period;

        -- Test case: addi $8, $0, 8
        rd <= "01000"; -- $8
        immediate <= "00000000000000000000000000001000"; -- 8
        wait for clk_period;

        -- Test case: addi $9, $0, 9
        rd <= "01001"; -- $9
        immediate <= "00000000000000000000000000001001"; -- 9
        wait for clk_period;

        -- Test case: addi $10, $0, 10
        rd <= "01010"; -- $10
        immediate <= "00000000000000000000000000001010"; -- 10
        wait for clk_period;

        -- Test case: add $11, $1, $2
        nAdd_Sub <= '0';
        ALUSrc <= '0';
        rs <= "00001"; -- $1
        rt <= "00010"; -- $2
        rd <= "01011"; -- $11
        wait for clk_period;

        -- Test case: sub $12, $11, $3
        nAdd_Sub <= '1';
        rs <= "01011"; -- $11
        rt <= "00011"; -- $3
        rd <= "01100"; -- $12
        wait for clk_period;

        -- Test case: add $13, $12, $4
        nAdd_Sub <= '0';
        rs <= "01100"; -- $12
        rt <= "00100"; -- $4
        rd <= "01101"; -- $13
        wait for clk_period;

        -- Test case: sub $14, $13, $5
        nAdd_Sub <= '1';
        rs <= "01101"; -- $13
        rt <= "00101"; -- $5
        rd <= "01110"; -- $14
        wait for clk_period;

        -- Test case: add $15, $14, $6
        nAdd_Sub <= '0';
        rs <= "01110"; -- $14
        rt <= "00110"; -- $6
        rd <= "01111"; -- $15
        wait for clk_period;

        -- Test case: sub $16, $15, $7
        nAdd_Sub <= '1';
        rs <= "01111"; -- $15
        rt <= "00111"; -- $7
        rd <= "10000"; -- $16
        wait for clk_period;

        -- Test case: add $17, $16, $8
        nAdd_Sub <= '0';
        rs <= "10000"; -- $16
        rt <= "01000"; -- $8
        rd <= "10001"; -- $17
        wait for clk_period;

        -- Test case: sub $18, $17, $9
        nAdd_Sub <= '1';
        rs <= "10001"; -- $17
        rt <= "01001"; -- $9
        rd <= "10010"; -- $18
        wait for clk_period;

        -- Test case: add $19, $18, $10
        nAdd_Sub <= '0';
        rs <= "10010"; -- $18
        rt <= "01010"; -- $10
        rd <= "10011"; -- $19
        wait for clk_period;

        -- Test case: addi $20, $0, -35
        ALUSrc <= '1';
        rs <= "00000"; -- $0
        rt <= "00000";
        rd <= "10100"; -- $20
        immediate <= "11111111111111111111111111011101"; -- -35 (2's complement)
        wait for clk_period;

        -- Test case: add $21, $19, $20
        ALUSrc <= '0';
        nAdd_Sub <= '0';
        rs <= "10011"; -- $19
        rt <= "10100"; -- $20
        rd <= "10101"; -- $21
        wait for clk_period;

        -- Test complete
        wait;
    end process;

end Behavioral;
