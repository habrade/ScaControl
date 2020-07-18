----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2020 05:36:16 AM
-- Design Name: 
-- Module Name: ipbus_sca_io_device - behv
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

use work.ipbus.all;
use work.ipbus_reg_types.all;

entity ipbus_sca_io_device is
  port (
    ipb_clk : in  std_logic;
    ipb_rst : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;

    -- Control Port
    start_pad    : out std_logic;
    trigger_pad  : out std_logic;
    enable_r_dff : out std_logic;
    din_dff      : out std_logic;
    bit_0_cp     : out std_logic;
    bit_1_cp     : out std_logic
    );
end ipbus_sca_io_device;

architecture behv of ipbus_sca_io_device is

  constant N_STAT : integer := 1;
  constant N_CTRL : integer := 1;
  signal stat     : ipb_reg_v(N_STAT-1 downto 0);
  signal ctrl     : ipb_reg_v(N_CTRL-1 downto 0);
  
begin

  inst_ipbus_ctrlreg : entity work.ipbus_ctrlreg_v
    generic map(
      N_CTRL => N_CTRL,
      N_STAT => N_STAT
      )
    port map(
      clk       => ipb_clk,
      reset     => ipb_rst,
      ipbus_in  => ipb_in,
      ipbus_out => ipb_out,
      d         => stat,
      q         => ctrl
      );

  start_pad    <= ctrl(0)(0);
  trigger_pad  <= ctrl(0)(1);
  enable_r_dff <= ctrl(0)(2);
  din_dff      <= ctrl(0)(3);
  bit_0_cp     <= ctrl(0)(4);
  bit_1_cp     <= ctrl(0)(5);


end behv;
