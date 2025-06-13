library IEEE;
use work.package_t_bus_32x32.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;

entity mux32t1 is
   port(data    : in t_bus_32x32;
        sel     : in std_logic_vector(4 downto 0);
        o_O     : out std_logic_vector(31 downto 0));
end mux32t1;

architecture dataflow of mux32t1 is

begin

   o_O <= data(to_integer(unsigned(sel)));

end dataflow;