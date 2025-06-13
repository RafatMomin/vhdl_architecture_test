library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;
use work.package_t_bus_32x32.all;
use IEEE.numeric_std.all;

entity tb_mySecondMIPSDatapath is
  generic(
    gCLK_HPER : time := 30 ns;  -- Generic for half of the clock cycle period
    DATA_WIDTH : natural := 32;
    ADDR_WIDTH : natural := 10;
    N : integer := 32           -- Define N at the testbench level
  );
end tb_mySecondMIPSDatapath;

architecture mixed of tb_mySecondMIPSDatapath is

-- Define the total clock period time
constant cCLK_PER : time := gCLK_HPER * 2;

component mySecondMIPSDatapath is

  generic(
    N : integer := 32;
    DATA_WIDTH : natural := 32;
    ADDR_WIDTH : natural := 10
  );
  port(iCLK       : in std_logic;
       iRST       : in std_logic;
       reg_WE     : in std_logic;
       mem_WE     : in std_logic;
       ALUSrc     : in std_logic;
       nAdd_Sub   : in std_logic;
       MemtoReg   : in std_logic;
       ext0_or_S  : in std_logic;
       rs         : in std_logic_vector(4 downto 0);
       rt         : in std_logic_vector(4 downto 0);
       rd         : in std_logic_vector(4 downto 0);
       iImm       : in std_logic_vector(15 downto 0);
       result     : out std_logic_vector(N-1 downto 0));
       
end component;

signal iCLK             : std_logic;
signal iRST             : std_logic;
signal reg_WE           : std_logic;
signal mem_WE           : std_logic;
signal MemtoReg         : std_logic;
signal ALUSrc           : std_logic;
signal nAdd_Sub         : std_logic;
signal ext0_or_S        : std_logic;
signal rs               : std_logic_vector(4 downto 0);
signal rt               : std_logic_vector(4 downto 0);
signal rd               : std_logic_vector(4 downto 0);
signal iImm             : std_logic_vector(15 downto 0); 
signal result           : std_logic_vector(N-1 downto 0);

begin

  Datapath: mySecondMIPSDatapath port map(
    iCLK      => iCLK,
    iRST      => iRST,
    reg_WE    => reg_WE,
    mem_WE    => mem_WE,
    MemtoReg  => MemtoReg,
    ALUSrc    => ALUSrc,
    nAdd_Sub  => nAdd_Sub,
    ext0_or_S => ext0_or_S,
    rs        => rs,
    rt        => rt,
    rd        => rd,
    iImm      => iImm,
    result    => result
  );

  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    iCLK <= '0';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    iCLK <= '1';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process; 

  P_TEST_CASES: process
begin
    -- Reset
    iRST <= '1';
    reg_WE <= '0';
    mem_WE <= '0';
    wait for gCLK_HPER;
    iRST <= '0';
    wait for gCLK_HPER;

    -- Memory Initialization Phase
    mem_WE <= '1';  -- Enable write to memory
    addr <= "0000000000"; -- Address 0
    data <= x"00000010"; -- Data value for address 0
    wait for cCLK_PER;

    addr <= "0000000001"; -- Address 1
    data <= x"00000020"; -- Data value for address 1
    wait for cCLK_PER;

    addr <= "0000000010"; -- Address 2
    data <= x"00000030"; -- Data value for address 2
    wait for cCLK_PER;

    -- Disable write after initialization
    mem_WE <= '0';

    -- Test Cases Start

    -- addi $25, $0, 0
    rs <= "00000";
    rt <= "00000";
    rd <= "11001";  -- Target register $25
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '0';
    iImm <= "0000000000000000"; -- Immediate value 0
    wait for cCLK_PER;

    -- addi $26, $0, 256
    rs <= "00000";
    rt <= "00000";
    rd <= "11010";  -- Target register $26
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '0';
    iImm <= "0000000100000000"; -- Immediate value 256
    wait for cCLK_PER;

    -- lw $1, 0($25)
    rs <= "11001";  -- Base address register $25
    rt <= "00000";
    rd <= "00001";  -- Target register $1
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '1';
    iImm <= "0000000000000000"; -- Offset 0
    wait for cCLK_PER;

    -- lw $2, 4($25)
    rs <= "11001";  -- Base address register $25
    rt <= "00000";
    rd <= "00010";  -- Target register $2
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '1';
    iImm <= "0000000000000100"; -- Offset 4
    wait for cCLK_PER;

    -- add $1, $1, $2
    rs <= "00001";  -- Source register $1
    rt <= "00010";  -- Source register $2
    rd <= "00001";  -- Target register $1
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '0';
    nAdd_Sub <= '0';
    ext0_or_S <= '0';
    MemtoReg <= '0';
    iImm <= "0000000000000000";
    wait for cCLK_PER;

    -- sw $1, 0($26)
    rs <= "11010";  -- Base address register $26
    rt <= "00001";  -- Source register $1
    rd <= "00001";
    reg_WE <= '0';
    mem_WE <= '1';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '1';
    iImm <= "0000000000000000"; -- Offset 0
    wait for cCLK_PER;

    -- lw $2, 8($25)
    rs <= "11001";  -- Base address register $25
    rt <= "00000";
    rd <= "00010";  -- Target register $2
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '1';
    nAdd_Sub <= '0';
    ext0_or_S <= '1';
    MemtoReg <= '1';
    iImm <= "0000000000001000"; -- Offset 8
    wait for cCLK_PER;

    -- add $1, $1, $2
    rs <= "00001";  -- Source register $1
    rt <= "00010";  -- Source register $2
    rd <= "00001";  -- Target register $1
    reg_WE <= '1';
    mem_WE <= '0';
    ALUSrc <= '0';
    nAdd_Sub <= '0';
    ext0_or_S <= '0';
    MemtoReg <= '0';
    iImm <= "0000000000000000";
    wait for cCLK_PER;

    -- Add any additional test cases as needed below...

    -- Finish simulation
    wait;
end process;

