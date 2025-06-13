library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_regfile is
end tb_regfile;

architecture behavior of tb_regfile is
  constant gCLK_HPER : time := 50 ns;
  constant cCLK_PER  : time := gCLK_HPER * 2;
  
  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal we      : std_logic := '0';
  signal rs      : std_logic_vector(4 downto 0) := (others => '0');
  signal rt      : std_logic_vector(4 downto 0) := (others => '0');
  signal rd      : std_logic_vector(4 downto 0) := (others => '0');
  signal wdata   : std_logic_vector(31 downto 0) := (others => '0');
  signal rsdata  : std_logic_vector(31 downto 0);
  signal rtdata  : std_logic_vector(31 downto 0);

  component regfile
    port (
      i_CLK      : in std_logic;
      i_RST      : in std_logic;
      i_WE       : in std_logic;
      i_RS       : in std_logic_vector(4 downto 0);
      i_RT       : in std_logic_vector(4 downto 0);
      i_RD       : in std_logic_vector(4 downto 0);
      i_WDATA    : in std_logic_vector(31 downto 0);
      o_RSDATA   : out std_logic_vector(31 downto 0);
      o_RTDATA   : out std_logic_vector(31 downto 0)
    );
  end component;

begin
  DUT: regfile
    port map (
      i_CLK => clk,
      i_RST => rst,
      i_WE  => we,
      i_RS  => rs,
      i_RT  => rt,
      i_RD  => rd,
      i_WDATA => wdata,
      o_RSDATA => rsdata,
      o_RTDATA => rtdata
    );

  clk_process: process
  begin
    clk <= '0';
    wait for gCLK_HPER;
    clk <= '1';
    wait for gCLK_HPER;
  end process;

  stimulus_process: process
  begin
    -- Test 1: Reset the register file
    rst <= '1';
    we  <= '0';
    wait for cCLK_PER;
    
    rst <= '0';
    we  <= '1';
    rd  <= "00001";  -- Write to register 1
    wdata <= x"00000001"; -- Data to write
    wait for cCLK_PER;
    
    we <= '0';
    rs <= "00001";  -- Read from register 1
    rt <= "00001";  -- Read from register 1
    wait for cCLK_PER;

    -- Test 2: Write to register 2
    we <= '1';
    rd <= "00010";  -- Write to register 2
    wdata <= x"00000002"; -- Data to write
    wait for cCLK_PER;

    -- Test 3: Read from register 2
    we <= '0';
    rs <= "00010";  -- Read from register 2
    rt <= "00010";  -- Read from register 2
    wait for cCLK_PER;

    -- Test 4: Write to and read from multiple registers
    we <= '1';
    rd <= "00100";  -- Write to register 4
    wdata <= x"00000004"; -- Data to write
    wait for cCLK_PER;

    rd <= "01000";  -- Write to register 8
    wdata <= x"00000008"; -- Data to write
    wait for cCLK_PER;

    we <= '0';
    rs <= "00100";  -- Read from register 4
    rt <= "01000";  -- Read from register 8
    wait for cCLK_PER;

    -- Test 5: Reset functionality
    rst <= '1';
    wait for cCLK_PER;
    rst <= '0';
    rs <= "00001";  -- Read from register 1
    rt <= "00010";  -- Read from register 2
    wait for cCLK_PER;

    wait;
  end process;

end behavior;

