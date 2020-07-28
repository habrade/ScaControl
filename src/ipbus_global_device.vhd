----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2020 11:31:01 PM
-- Design Name: 
-- Module Name: ipbus_global_device - behv
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.ipbus.ALL;
use work.ipbus_reg_types.ALL;
use work.ipbus_reg_types_new.ALL;


entity ipbus_global_device is
    port (
    ipb_clk        : in  std_logic;
    ipb_rst        : in  std_logic;
    ipb_in         : in  ipb_wbus;
    ipb_out        : out ipb_rbus;
    -- Global
    nuke     : out std_logic;
    soft_rst : out std_logic
    );
    
end ipbus_global_device;

architecture behv of ipbus_global_device is

  constant N_STAT     : integer := 0;
  constant N_CTRL     : integer := 1;
  signal stat : ipb_reg_v(integer_max(N_STAT,1)-1 downto 0);
  signal ctrl : ipb_reg_v(integer_max(N_CTRL,1)-1 downto 0);

begin

    inst_ipbus_slave  : entity work.ipbus_ctrlreg_v
    generic map(
      N_CTRL => N_CTRL,
      N_STAT => N_STAT,
      SWAP_ORDER => TRUE
      )
    port map(
      clk       => ipb_clk,
      reset     => ipb_rst,
      ipbus_in  => ipb_in,
      ipbus_out => ipb_out,
      d         => stat,
      q         => ctrl
      );

  nuke     <= ctrl(0)(0);
  soft_rst <= ctrl(0)(1);
  
  stat     <= (others=>(others=>'0'));

end behv;
