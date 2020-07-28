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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.ipbus.all;
use work.ipbus_reg_types.all;
use work.ipbus_reg_types_new.all;
use work.drp_decl.all;

entity ipbus_slave_reg_drp is
  generic(
    N_STAT : integer := 1;
    N_CTRL : integer := 1;
    N_DRP  : integer := 1
    );
  port(
    ipb_clk : in  std_logic;
    ipb_rst : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;

    reg_rst      : in  std_logic;
    reg_slave_clk     : in  std_logic:='0';
    
    ctrl         : out ipb_reg_v(integer_max(N_CTRL,1)-1 downto 0);
    ctrl_reg_stb : out std_logic_vector(integer_max(N_CTRL,1)-1 downto 0);
    stat         : in  ipb_reg_v(integer_max(N_STAT,1)-1 downto 0);
    stat_reg_stb : out std_logic_vector(integer_max(N_STAT,1)-1 downto 0);

    -- MMCM DRP Ports
    drp_rst : in  std_logic_vector(N_DRP-1 downto 0);
    drp_in  : in  drp_rbus_array(N_DRP-1 downto 0);
    drp_out : out drp_wbus_array(N_DRP-1 downto 0)
    );
end ipbus_slave_reg_drp;

architecture behv of ipbus_slave_reg_drp is


  constant REG_NSLV : integer  := reg_slave_num(N_STAT, N_CTRL);
  constant NSLV     : positive := REG_NSLV+N_DRP;

  signal ipbw : ipb_wbus_array(NSLV-1 downto 0);
  signal ipbr : ipb_rbus_array(NSLV-1 downto 0);

  signal rst_r : std_logic;

begin
  rst_r   <= ipb_rst or reg_rst;


  inst_device_fabric : entity work.ipbus_fabric_inside_device
    generic map(
      N_CTRL  => N_CTRL,                --the control register number
      N_STAT  => N_STAT,                --the status register number
      N_DRP => N_DRP
      )
    port map(
      ipb_in          => ipb_in,
      ipb_out         => ipb_out,
      ipb_to_slaves   => ipbw,
      ipb_from_slaves => ipbr,
      debug           => open
      );


  gen_reg : if REG_NSLV = 1 generate
    inst_ipbus_slave : entity work.ipbus_ctrlreg_v
      generic map(
        N_CTRL => N_CTRL,
        N_STAT => N_STAT,
        SWAP_ORDER => true
        )
      port map(
        clk       => ipb_clk,
        reset     => rst_r,
        ipbus_in  => ipbw(0),
        ipbus_out => ipbr(0),
        d         => stat,
        q         => ctrl,
        stb       => ctrl_reg_stb
        );
  end generate;


  drp_bridges : if N_DRP > 0 generate
    drp_bridges_gen : for index in N_DRP-1 downto 0 generate
      inst_ipbus_drp : entity work.ipbus_drp_bridge
        port map(
          clk     => ipb_clk,
          rst     => ipb_rst or drp_rst(index),
          ipb_in  => ipbw(REG_NSLV+index),
          ipb_out => ipbr(REG_NSLV+index),
          drp_out => drp_out(index),
          drp_in  => drp_in(index)
          );
    end generate;
  end generate;

end behv;
