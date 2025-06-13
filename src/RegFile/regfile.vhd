library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
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
end regfile;

architecture rtl of regfile is
  type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
  signal regfile : reg_array := (others => (others => '0'));

begin
  process (i_CLK, i_RST)
  begin
    if i_RST = '1' then
      regfile <= (others => (others => '0'));
    elsif rising_edge(i_CLK) then
      if i_WE = '1' then
        regfile(to_integer(unsigned(i_RD))) <= i_WDATA;
      end if;
    end if;
  end process;

  o_RSDATA <= regfile(to_integer(unsigned(i_RS)));
  o_RTDATA <= regfile(to_integer(unsigned(i_RT)));
  
end rtl;

