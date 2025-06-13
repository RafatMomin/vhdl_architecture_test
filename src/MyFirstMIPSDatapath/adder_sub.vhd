library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A       : in STD_LOGIC_VECTOR (31 downto 0);
        B       : in STD_LOGIC_VECTOR (31 downto 0);
        nAdd_Sub: in STD_LOGIC;
        Result  : out STD_LOGIC_VECTOR (31 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(A, B, nAdd_Sub)
    begin
        if nAdd_Sub = '0' then
            Result <= std_logic_vector(signed(A) + signed(B));
        else
            Result <= std_logic_vector(signed(A) - signed(B));
        end if;
    end process;
end Behavioral;

