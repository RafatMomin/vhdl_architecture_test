library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.package_t_bus_32x32.all;

entity mySecondMIPSDatapath is
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
       
end mySecondMIPSDatapath;

architecture structural of mySecondMIPSDatapath is

  component Register_File is
       generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
       port(iCLK             : in std_logic;
            rs               : in std_logic_vector(4 downto 0);
            rt               : in std_logic_vector(4 downto 0);
            rd               : in std_logic_vector(4 downto 0);
            wData            : in std_logic_vector(N-1 downto 0);
            wReg             : in std_logic;
            iRST             : in std_logic;
            oR_1             : out std_logic_vector(N-1 downto 0);
            oR_2             : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N is 
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));

  end component;

  component Add_Sub_N is
    generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(iC               : in std_logic;
         iA               : in std_logic_vector(N-1 downto 0);
         iB               : in std_logic_vector(N-1 downto 0);
         oC               : out std_logic;
         oS               : out std_logic_vector(N-1 downto 0));
  end component;

  component mem is
    generic(DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10);
    port 
	  (
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	  );
  end component;

  component Extender is
    port(iX   : in std_logic_vector(15 downto 0);
         iSel : in std_logic;
         oX   : out std_logic_vector(31 downto 0));
  end component;

  signal reg_to_A     : std_logic_vector(N-1 downto 0);
  signal reg_to_MUX   : std_logic_vector(N-1 downto 0);
  signal mux_to_B     : std_logic_vector(N-1 downto 0);
  signal ext_to_MUX   : std_logic_vector(N-1 downto 0);
  signal ALU_to_dmem  : std_logic_vector(9 downto 0);
  signal ALU_to_MUX   : std_logic_vector(N-1 downto 0);
  signal dmem_to_MUX  : std_logic_vector(N-1 downto 0);
  signal MUX_to_wData : std_logic_vector(N-1 downto 0);
  signal reg_to_Data  : std_logic_vector(N-1 downto 0);
  signal out_carry    : std_logic; -- Unused currently

begin

    regFile: Register_File
    generic map(N => N)
    port map(iCLK  => iCLK,
             rs    => rs,
             rt    => rt,
             rd    => rd,
             wData => MUX_to_wData,
             wReg  => reg_WE,
             iRST  => iRST,
             oR_1  => reg_to_A,
             oR_2  => reg_to_MUX);

    reg_to_Data <= reg_to_MUX;

    extend: Extender
      port map(iX   => iImm,
               iSel => ext0_or_S,
               oX   => ext_to_MUX);

    MuxToB: mux2t1_N
    generic map(N => N)
    port map(i_S  => ALUSrc,
             i_D0 => reg_to_MUX,
             i_D1 => ext_to_MUX,
             o_O  => mux_to_B);

    ALU: Add_Sub_N
    generic map(N => N)
    port map(iC => nAdd_Sub,
             iA => reg_to_A,
             iB => mux_to_B,
             oC => out_carry,
             oS => ALU_to_MUX);

    ALU_to_dmem <= ALU_to_MUX(11 downto 2);

    dmem: mem
    generic map(DATA_WIDTH => DATA_WIDTH, ADDR_WIDTH => ADDR_WIDTH)
    port map(clk  => iCLK,
             addr => ALU_to_dmem,
             data => reg_to_Data,
             we   => mem_WE,
             q    => dmem_to_MUX);


    MuxTowData: mux2t1_N
    generic map(N => N)
    port map(i_S  => MemtoReg,
             i_D0 => ALU_to_MUX,
             i_D1 => dmem_to_MUX,
             o_O  => MUX_to_wData);

    result <= MUX_to_wData;

end structural;
