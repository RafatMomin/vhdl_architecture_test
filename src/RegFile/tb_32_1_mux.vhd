library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_mux32to1 is
end tb_mux32to1;

architecture Behavioral of tb_mux32to1 is
    signal select_input : STD_LOGIC_VECTOR(4 downto 0);
    signal inputs       : STD_LOGIC_VECTOR(32*32-1 downto 0);
    signal output       : STD_LOGIC_VECTOR(31 downto 0);

    component mux32to1
        Port ( 
            select_input : in  STD_LOGIC_VECTOR (4 downto 0);
            inputs       : in  STD_LOGIC_VECTOR (32*32-1 downto 0);
            output       : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

begin
    uut: mux32to1
        port map (
            select_input => select_input,
            inputs       => inputs,
            output       => output
        );

    stim_proc: process
    begin
        -- Initialize Inputs
        inputs <= (others => '0');
        select_input <= "00000";
        
        -- Wait for the global reset
        wait for 100 ns;
        
        -- Apply test vectors
        inputs(31 downto 0) <= X"00000001"; -- Set first input
        inputs(63 downto 32) <= X"00000002"; -- Set second input
        -- Continue for other inputs
        
        select_input <= "00000";
        wait for 20 ns;
        assert (output = X"00000001") report "Test failed for select 00000" severity error;

        select_input <= "00001";
        wait for 20 ns;
        assert (output = X"00000002") report "Test failed for select 00001" severity error;

        -- Add more test cases as needed
        
        wait;
    end process;
end Behavioral;
