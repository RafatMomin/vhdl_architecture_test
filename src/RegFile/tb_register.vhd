library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_RegFile is
end tb_RegFile;

architecture behavior of tb_RegFile is
    signal clk          : STD_LOGIC := '0';
    signal rst          : STD_LOGIC := '0';
    signal write_enable : STD_LOGIC := '0';
    signal read_addr1   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal read_addr2   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal write_addr   : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal write_data   : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    signal read_data1   : STD_LOGIC_VECTOR (31 downto 0);
    signal read_data2   : STD_LOGIC_VECTOR (31 downto 0);

    -- Clock generation
    constant clk_period : time := 10 ns;
    
    component RegFile
        Port (
            clk          : in STD_LOGIC;
            rst          : in STD_LOGIC;
            write_enable : in STD_LOGIC;
            read_addr1   : in STD_LOGIC_VECTOR (4 downto 0);
            read_addr2   : in STD_LOGIC_VECTOR (4 downto 0);
            write_addr   : in STD_LOGIC_VECTOR (4 downto 0);
            write_data   : in STD_LOGIC_VECTOR (31 downto 0);
            read_data1   : out STD_LOGIC_VECTOR (31 downto 0);
            read_data2   : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: RegFile PORT MAP (
        clk => clk,
        rst => rst,
        write_enable => write_enable,
        read_addr1 => read_addr1,
        read_addr2 => read_addr2,
        write_addr => write_addr,
        write_data => write_data,
        read_data1 => read_data1,
        read_data2 => read_data2
    );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        -- Write to register 1
        write_enable <= '1';
        write_addr <= "00001";
        write_data <= X"AAAAAAAA";
        wait for clk_period;

        -- Write to register 2
        write_addr <= "00010";
        write_data <= X"BBBBBBBB";
        wait for clk_period;

        -- Read from registers
        write_enable <= '0';
        read_addr1 <= "00001";
        read_addr2 <= "00010";
        wait for clk_period;

        -- Check the read data
        assert (read_data1 = X"AAAAAAAA") report "Test failed for read address 1" severity error;
        assert (read_data2 = X"BBBBBBBB") report "Test failed for read address 2" severity error;

        wait;
    end process;
end behavior;

