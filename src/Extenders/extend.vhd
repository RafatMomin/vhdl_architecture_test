library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Extender is
    port(
        input_16bit  : in std_logic_vector(15 downto 0);
        sign_extend  : in std_logic;
        output_32bit : out std_logic_vector(31 downto 0)
    );
end entity Extender;

architecture Behavioral of Extender is
begin
    process(input_16bit, sign_extend)
    begin
        if sign_extend = '1' then
            -- Sign Extension
            if input_16bit(15) = '1' then
                output_32bit(31 downto 16) <= (others => '1');
            else
                output_32bit(31 downto 16) <= (others => '0');
            end if;
            output_32bit(15 downto 0) <= input_16bit;
        else
            -- Zero Extension
            output_32bit <= (others => '0');
            output_32bit(15 downto 0) <= input_16bit;
        end if;
    end process;
end architecture Behavioral;

