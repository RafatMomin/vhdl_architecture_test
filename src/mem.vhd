library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem is
    generic (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 10
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector((ADDR_WIDTH-1) downto 0);
        data : in std_logic_vector((DATA_WIDTH-1) downto 0);
        we   : in std_logic := '1';
        q    : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
end mem;

architecture rtl of mem is
    -- Define memory array
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(0 to (2**ADDR_WIDTH)-1) of word_t;
    signal ram : memory_t := (others => (others => '0'));

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                ram(to_integer(unsigned(addr))) <= data;
            end if;
        end if;
    end process;

    q <= ram(to_integer(unsigned(addr))); -- Read operation

end rtl;

