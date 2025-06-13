library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_D0          :in std_logic;
       i_D1          :in std_logic;
       i_S          :in std_logic;
       o_O          :out std_logic);
end mux2t1;

architecture structure of mux2t1 is

  component invg
    port(i_A        :in std_logic;
	 o_F        :out std_logic);
  end component;

  component org2
    port(i_A        :in std_logic;
         i_B        :in std_logic;
         o_F        :out std_logic);
  end component;

  component andg2
    port(i_A        :in std_logic;
         i_B        :in std_logic;
         o_F        :out std_logic);
   end component;

  signal s_X        : std_logic;
  signal s_Y        : std_logic;
  signal s_S        : std_logic;

begin
  invg_bit: invg port MAP(i_A      => i_S, 
                          o_F      => s_S);
 
  and_gate1: andg2 port MAP(i_A      => i_S,
                            i_B      => i_D1,
			    o_F      => s_Y);
  and_gate2: andg2 port MAP(i_A   => s_S, 
                            i_B   => i_D0,
                            o_F   => s_X);

  or_gate: org2 port MAP(i_A  => s_X,
                         i_B  => s_Y,
                         o_F  => o_O);

end structure;

  