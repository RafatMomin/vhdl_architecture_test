library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_1164.STD_LOGIC;

entity adder_N is
	generic(N: integer := 32);
	port(
	i_1	: in std_logic_vector(N-1 downto 0);
	i_2	: in std_logic_vector(N-1 downto 0);
	i_C	: in std_logic;
	o_C	: out std_logic;
	o_S	: out std_logic_vector(N-1 downto 0));

end adder_N;

architecture structure of adder_N is

	component fulladder is
		port(
			i_X               : in std_logic;
			i_Y              : in std_logic;
			i_Cin		 : in std_logic;
			o_Cout		 : out std_logic;
			o_S               : out std_logic);

         end component;

signal s_C	: std_logic_vector(N-1 downto 0);

begin

--Setup for first fulladder to initilize s_C
first: fulladder port map(
		i_X	=> i_1(0),
		i_Y	=> i_2(0),
		i_Cin	=> i_C,
		o_Cout	=> s_C(0),
		o_S	=> o_S(0));

G_adder_N: for i in 1 to N-1 generate

	ADDER: fulladder port map(
		i_X	=> i_1(i),
		i_Y	=> i_2(i),
		i_Cin	=> s_C(i-1),
		o_Cout	=> s_C(i),
		o_S	=> o_S(i));

end generate G_adder_N;

	o_C <= s_C(N-1);
end structure;
