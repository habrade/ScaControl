----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2020 10:42:12 PM
-- Design Name: 
-- Module Name: dac8568_device - behv
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


entity ipbus_dac8568_device is
  port(
    ipb_clk : in  std_logic;
    ipb_rst : in  std_logic;
    ipb_in  : in  ipb_wbus;
    ipb_out : out ipb_rbus;

    clk : in std_logic;
    rst : in std_logic;

    -- DAC8568
    dac8568_busy   : in  std_logic;
    dac8568_rst    : out std_logic;
    dac8568_start  : out std_logic;
    dac8568_sel_ch : out std_logic_vector(7 downto 0);

    dac8568_data_a : out std_logic_vector(15 downto 0);
    dac8568_data_b : out std_logic_vector(15 downto 0);
    dac8568_data_c : out std_logic_vector(15 downto 0);
    dac8568_data_d : out std_logic_vector(15 downto 0);
    dac8568_data_e : out std_logic_vector(15 downto 0);
    dac8568_data_f : out std_logic_vector(15 downto 0);
    dac8568_data_g : out std_logic_vector(15 downto 0);
    dac8568_data_h : out std_logic_vector(15 downto 0)
    );
end ipbus_dac8568_device;

architecture behv of ipbus_dac8568_device is

  -- DAC8568
  constant N_STAT       : integer := 1;
  constant N_CTRL       : integer := 5;
  constant SYNC_REG_ENA : boolean := false;

  signal stat : ipb_reg_v(N_STAT-1 downto 0);
  signal ctrl : ipb_reg_v(N_CTRL-1 downto 0);
  signal ctrl_reg_stb   : std_logic_vector(N_CTRL-1 downto 0);
  signal stat_reg_stb   : std_logic_vector(N_STAT-1 downto 0);

  signal rst_r : std_logic;

begin

  rst_r <= ipb_rst or rst;

  reg_gen_0 : if SYNC_REG_ENA = true generate
    inst_ipbus_slave_0 : entity work.ipbus_ctrlreg_v
      generic map(
        N_CTRL     => N_CTRL,
        N_STAT     => N_STAT,
        SWAP_ORDER => true
        )
      port map(
        clk       => ipb_clk,
        reset     => rst_r,
        ipbus_in  => ipb_in,
        ipbus_out => ipb_out,
        d         => stat,
        q         => ctrl,
        stb       => ctrl_reg_stb
        );
  end generate;

  reg_gen_1 : if SYNC_REG_ENA = false generate
    inst_ipbus_slave_1 : entity work.ipbus_syncreg_v
      generic map(
        N_CTRL     => N_CTRL,
        N_STAT     => N_STAT,
        SWAP_ORDER => true
        )
      port map (
        clk     => ipb_clk,
        rst     => rst_r,
        ipb_in  => ipb_in,
        ipb_out => ipb_out,
        slv_clk => clk,
        d       => stat,
        q       => ctrl,
        stb     => ctrl_reg_stb(N_CTRL-1 downto 0),
        rstb    => stat_reg_stb(N_STAT-1 downto 0)
        );
  end generate;


  -- status
  process(clk)
  begin
    if rising_edge(clk) then
      stat(0) <= "0000000000000000000000000000000" & dac8568_busy;
    end if;
  end process;


  -- control
  process(clk)
  begin
    if rising_edge(clk) then
      dac8568_rst    <= ctrl(0)(0);
      dac8568_start  <= ctrl(0)(1);
      dac8568_sel_ch <= ctrl(0)(9 downto 2);

      dac8568_data_a <= ctrl(1)(15 downto 0);
      dac8568_data_b <= ctrl(1)(31 downto 16);
      dac8568_data_c <= ctrl(2)(15 downto 0);
      dac8568_data_d <= ctrl(2)(31 downto 16);
      dac8568_data_e <= ctrl(3)(15 downto 0);
      dac8568_data_f <= ctrl(3)(31 downto 16);
      dac8568_data_g <= ctrl(4)(15 downto 0);
      dac8568_data_h <= ctrl(4)(31 downto 16);
    end if;
  end process;

end behv;
