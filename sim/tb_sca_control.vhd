library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_sca_control is
end entity;

architecture tb of tb_sca_control is

  component sca_control is
    port (
      rst     : in std_logic;
      clk_125 : in std_logic;

      clk_REF     : out std_logic;
      start_pad   : out std_logic;
      trigger_pad : out std_logic;
      RN_DFF      : out std_logic;
      SR_DFF      : out std_logic;
      clk_DFF     : out std_logic
      );
  end component;

  signal clk_125 : std_logic := '1';
  signal rst     : std_logic;

  signal clk_REF     : std_logic;
  signal start_pad   : std_logic;
  signal trigger_pad : std_logic;
  signal RN_DFF      : std_logic;
  signal SR_DFF      : std_logic;
  signal clk_DFF     : std_logic;
 
  constant clk_125_period : time := 8 ns;

begin

  clk_125 <= not clk_125 after clk_125_period/2;
  

  rst <= '0' after 0 ns,
         '1' after 200 ns,
         '0' after 300 ns;

  inst_dut : sca_control
    port map(
      rst     => rst,
      clk_125 => clk_125,

      clk_REF     => clk_REF,
      start_pad   => start_pad,
      trigger_pad => trigger_pad,
      RN_DFF      => RN_DFF,
      SR_DFF      => SR_DFF,
      clk_DFF     => clk_DFF);

end architecture;