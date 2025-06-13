library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux32to1 is
    Port ( 
        select_input : in  STD_LOGIC_VECTOR (4 downto 0);
        inputs       : in  STD_LOGIC_VECTOR (32*32-1 downto 0);
        output       : out STD_LOGIC_VECTOR (31 downto 0)
    );
end mux32to1;

architecture Behavioral of mux32to1 is
begin
    process(select_input, inputs)
    begin
        case select_input is
            when "00000" => output <= inputs(31 downto 0);
            when "00001" => output <= inputs(63 downto 32);
            -- Continue for other input cases
            when "11111" => output <= inputs(1023 downto 992);
            when others => output <= (others => '0');
        end case;
    end process;
end Behavioral;
