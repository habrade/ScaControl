----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/13/2020 05:36:41 AM
-- Design Name: 
-- Module Name: ipbus_sca_clk_device - behv
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
use work.drp_decl.all;

entity ipbus_sca_clk_device is
port(
    ipb_clk : in  std_logic;
    ipb_rst : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;
    
    -- MMCM DRP Ports
    drp_out : out drp_wbus;
    drp_in  : in  drp_rbus
);
end ipbus_sca_clk_device;

architecture behv of ipbus_sca_clk_device is

begin

 inst_ipbus_drp : entity work.ipbus_drp_bridge
        port map(
          clk       => ipb_clk,
          rst       => ipb_rst,
          ipb_in    => ipb_in,
          ipb_out   => ipb_out,
          drp_out   => drp_out,
          drp_in    => drp_in
          );
          
end behv;
