library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile is
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
                regs(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
    end process;

    readData1 <= regs(to_integer(unsigned(readReg1)));
    readData2 <= regs(to_integer(unsigned(readReg2)));
end Behavioral;

