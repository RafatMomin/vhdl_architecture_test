library ieee;
use ieee.std_logic_1164.all;

entity Extender_tb is
end entity Extender_tb;

architecture Behavioral of Extender_tb is
    signal input_16bit  : std_logic_vector(15 downto 0);
    signal sign_extend  : std_logic;
    signal output_32bit : std_logic_vector(31 downto 0);

    component Extender
        port(
            input_16bit  : in std_logic_vector(15 downto 0);
            sign_extend  : in std_logic;
            output_32bit : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: Extender
        port map(
            input_16bit  => input_16bit,
            sign_extend  => sign_extend,
            output_32bit => output_32bit
        );

    -- Test vectors
    process
    begin
        -- Test case 1: Zero extension
        input_16bit <= "0000000000001010";
        sign_extend <= '0';
        wait for 10 ns;

        -- Test case 2: Sign extension positive value
        input_16bit <= "0000000000001010";
        sign_extend <= '1';
        wait for 10 ns;

        -- Test case 3: Sign extension negative value
        input_16bit <= "1111111111111010";
        sign_extend <= '1';
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;
end architecture Behavioral;

