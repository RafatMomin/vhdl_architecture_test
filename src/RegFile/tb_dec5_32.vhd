library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder_5to32 is
end tb_decoder_5to32;

architecture behavior of tb_decoder_5to32 is
    signal i_SEL : std_logic_vector(4 downto 0);
    signal o_DEC : std_logic_vector(31 downto 0);

    component decoder_5to32
        port (
            i_SEL : in std_logic_vector(4 downto 0);
            o_DEC : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    DUT: decoder_5to32
        port map (
            i_SEL => i_SEL,
            o_DEC => o_DEC
        );

    stimulus_process: process
    begin
        -- Test case 1: Input 00000, output should be 00000000000000000000000000000001
        i_SEL <= "00000";
        wait for 10 ns;
        
        -- Test case 2: Input 00001, output should be 00000000000000000000000000000010
        i_SEL <= "00001";
        wait for 10 ns;

        -- Test case 3: Input 00100, output should be 00000000000000000000000000010000
        i_SEL <= "00100";
        wait for 10 ns;

        -- Test case 4: Input 01000, output should be 00000000000000000000000100000000
        i_SEL <= "01000";
        wait for 10 ns;

        -- Test case 5: Input 11111, output should be 10000000000000000000000000000000
        i_SEL <= "11111";
        wait for 10 ns;

        wait;
    end process;
end behavior;
