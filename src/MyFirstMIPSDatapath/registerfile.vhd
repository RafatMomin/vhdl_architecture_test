library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Correct library for standardized VHDL operations

entity RegFile is
    Port (
        clk          : in STD_LOGIC;
        rst          : in STD_LOGIC;
        regWrite     : in STD_LOGIC;
        rs           : in STD_LOGIC_VECTOR (4 downto 0);
        rt           : in STD_LOGIC_VECTOR (4 downto 0);
        rd           : in STD_LOGIC_VECTOR (4 downto 0);
        writeData    : in STD_LOGIC_VECTOR (31 downto 0);
        read_data1   : out STD_LOGIC_VECTOR (31 downto 0);
        read_data2   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end RegFile;

architecture Behavioral of RegFile is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs : reg_array := (others => (others => '0'));

begin
    process(clk, rst)
    begin
        if rst = '1' then
            regs <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if regWrite = '1' then
                regs(to_integer(unsigned(rd))) <= writeData; -- Correct conversion using NUMERIC_STD
            end if;
        end if;
    end process;

    -- Continuously output data from the register file
    read_data1 <= regs(to_integer(unsigned(rs))); -- Correct conversion using NUMERIC_STD
    read_data2 <= regs(to_integer(unsigned(rt))); -- Correct conversion using NUMERIC_STD
end Behavioral;

