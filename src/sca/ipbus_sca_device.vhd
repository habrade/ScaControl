----------------------------------------------------------------------------------
-- Company: 
-- Engineer: s.dong@mails.ccnu.edu.cn
-- 
-- Create Date: 07/09/2020 10:36:26 PM
-- Design Name: 
-- Module Name: ipbus_sca_dev - behv
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
--use work.ipbus_reg.all;
use work.ipbus_reg_types.all;
use work.drp_decl.all;

entity ipbus_sca_device is
  generic(
    N_DRP : integer := 2
    );
  port (
    ipb_clk : in  std_logic;
    ipb_rst : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;

    reg_slv_clk : in std_logic;
    reg_slv_rst : in std_logic;

    -- Control Port
    start_pad    : out std_logic;
    trigger_pad  : out std_logic;
    enable_r_dff : out std_logic;
    din_dff      : out std_logic;
    bit_0_cp     : out std_logic;
    bit_1_cp     : out std_logic;

    -- MMCM DRP Ports
    locked   : in  std_logic_vector(N_DRP-1 downto 0);
    rst_mmcm : out std_logic_vector(N_DRP-1 downto 0);
    drp_out  : out drp_wbus_array(N_DRP-1 downto 0);
    drp_in   : in  drp_rbus_array(N_DRP-1 downto 0)
    );
end ipbus_sca_device;

architecture behv of ipbus_sca_device is

  -- IPbus reg
  constant N_STAT     : integer := 1;
  constant N_CTRL     : integer := 2;
  signal stat         : ipb_reg_v(N_STAT-1 downto 0);
  signal ctrl         : ipb_reg_v(N_CTRL-1 downto 0);
  signal ctrl_reg_stb : std_logic_vector(N_CTRL-1 downto 0);
  signal stat_reg_stb : std_logic_vector(N_STAT-1 downto 0);

  -- IPbus drp
  signal drp_rst      : std_logic_vector(N_DRP-1 downto 0);
  
    -- Debug
  attribute mark_debug                      : string;
  attribute mark_debug of drp_rst           : signal is "true";

begin

  inst_ipbus_slave_reg_drp : entity work.ipbus_slave_reg_drp
    generic map(
      N_STAT => N_STAT,
      N_CTRL => N_CTRL,
      N_DRP  => N_DRP
      )
    port map(

      ipb_clk => ipb_clk,
      ipb_rst => ipb_rst,
      ipb_in  => ipb_in,
      ipb_out => ipb_out,

      reg_slave_clk => reg_slv_clk,
      reg_rst       => reg_slv_rst,

      -- control/state registers
      ctrl         => ctrl,
      ctrl_reg_stb => ctrl_reg_stb,
      stat         => stat,
      stat_reg_stb => open,
      -- MMCM DRP Ports
      drp_rst      => drp_rst,
      drp_in       => drp_in,
      drp_out      => drp_out

      );

  -- control
  process(reg_slv_clk)
  begin
    if rising_edge(reg_slv_clk) then
      -- SCA IO
      start_pad    <= ctrl(0)(0);
      trigger_pad  <= ctrl(0)(1);
      enable_r_dff <= ctrl(0)(2);
      din_dff      <= ctrl(0)(3);
      bit_0_cp     <= ctrl(0)(4);
      bit_1_cp     <= ctrl(0)(5);
      -- DRP
      rst_mmcm     <= ctrl(1)(1 downto 0);
      drp_rst      <= ctrl(1)(3 downto 2);
    end if;
  end process;

  -- status
  process(reg_slv_clk)
  begin
    if rising_edge(reg_slv_clk) then
      stat(0)(1 downto 0) <= locked;
    end if;
  end process;


end behv;
