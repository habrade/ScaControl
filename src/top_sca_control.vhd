library IEEE;
use IEEE.STD_LOGIC_1164.all;

library UNISIM;
use UNISIM.vcomponents.all;

use work.ipbus.all;
use work.drp_decl.all;

entity top is port(
  sysclk_p     : in  std_logic;
  sysclk_n     : in  std_logic;
  rst          : in  std_logic;
  leds         : out std_logic_vector(3 downto 0);  -- status LEDs
--              dip_sw: in std_logic_vector(3 downto 0); -- switches
  gmii_gtx_clk : out std_logic;
  gmii_tx_en   : out std_logic;
  gmii_tx_er   : out std_logic;
  gmii_txd     : out std_logic_vector(7 downto 0);
  gmii_rx_clk  : in  std_logic;
  gmii_rx_dv   : in  std_logic;
  gmii_rx_er   : in  std_logic;
  gmii_rxd     : in  std_logic_vector(7 downto 0);
  phy_rst      : out std_logic;

  -- DAC8568
  DAC_SCLK   : out std_logic;
  DAC_DIN    : out std_logic;
  DAC_SYNC_N : out std_logic;

  -- SCA
  clk_REF_p        : out std_logic;
  clk_REF_n        : out std_logic;
  clk_DFF_p        : out std_logic;
  clk_DFF_n        : out std_logic;
  start_pad   : out std_logic;
  trigger_pad : out std_logic;
  enable_r_dff      : out std_logic;
  din_dff      : out std_logic;
  bit_0_cp        : out std_logic;
  bit_1_cp        : out std_logic);
end top;

architecture rtl of top is

  -- IPbus
  signal clk_ipb, rst_ipb, clk_125M, clk_aux, rst_aux, nuke, soft_rst, phy_rst_e, userled : std_logic;
  signal mac_addr                                                                         : std_logic_vector(47 downto 0);
  signal ip_addr                                                                          : std_logic_vector(31 downto 0);
  signal ipb_out                                                                          : ipb_wbus;
  signal ipb_in                                                                           : ipb_rbus;

  -- DAC8568
  signal dac8568_busy                                                   : std_logic;
  signal dac8568_start, dac8568_rst                                     : std_logic;
  signal dac8568_sel_ch                                                 : std_logic_vector(7 downto 0);
  signal dac8568_data_a, dac8568_data_b, dac8568_data_c, dac8568_data_d : std_logic_vector(15 downto 0);
  signal dac8568_data_e, dac8568_data_f, dac8568_data_g, dac8568_data_h : std_logic_vector(15 downto 0);

  -- SCA MMCM DRP
  constant N_DRP  : integer := 2;
  signal drp_m2s:  drp_wbus_array(N_DRP-1 downto 0);
  signal drp_s2m:  drp_rbus_array(N_DRP-1 downto 0);
  signal clk_REF, clk_DFF : std_logic;
  signal sca_clocks_locked : std_logic_vector(N_DRP-1 downto 0);


  -- FREQ Counter
  constant N_CLK  : integer := 2;
  signal clk_sca, clk_sca_div : std_logic_vector(N_CLK -1 downto 0);
begin

-- Infrastructure

  ipbus_infra : entity work.ipbus_gmii_infra
    port map(
      sysclk_p     => sysclk_p,
      sysclk_n     => sysclk_n,
      clk_ipb_o    => clk_ipb,
      rst_ipb_o    => rst_ipb,
      clk_125_o    => clk_125M,
      rst_125_o    => phy_rst_e,
      clk_aux_o    => clk_aux,
      rst_aux_o    => rst_aux,
      nuke         => nuke,
      soft_rst     => soft_rst,
      leds         => leds(1 downto 0),
      gmii_gtx_clk => gmii_gtx_clk,
      gmii_txd     => gmii_txd,
      gmii_tx_en   => gmii_tx_en,
      gmii_tx_er   => gmii_tx_er,
      gmii_rx_clk  => gmii_rx_clk,
      gmii_rxd     => gmii_rxd,
      gmii_rx_dv   => gmii_rx_dv,
      gmii_rx_er   => gmii_rx_er,
      mac_addr     => mac_addr,
      ip_addr      => ip_addr,
      ipb_in       => ipb_in,
      ipb_out      => ipb_out
      );

  leds(3 downto 2) <= '0' & userled;
  phy_rst          <= not phy_rst_e;

--      mac_addr <= X"020ddba1151" & dip_sw; -- Careful here, arbitrary addresses do not always work
--      ip_addr <= X"c0a8c81" & dip_sw; -- 192.168.200.16+n
  mac_addr <= X"020ddba1151" & "0000";  -- Careful here, arbitrary addresses do not always work
  ip_addr  <= X"c0a8c81" & "0000";               -- 192.168.200.16+n

-- ipbus slaves live in the entity below, and can expose top-level ports
-- The ipbus fabric is instantiated within.

  ipbus_payload : entity work.ipbus_payload
    generic map(
      N_DRP => N_DRP,
      N_CLK => N_CLK
    )
    port map(
      ipb_clk        => clk_ipb,
      ipb_rst        => rst_ipb,
      ipb_in         => ipb_out,
      ipb_out        => ipb_in,
--                      clk => clk_aux,
--                      rst => rst_aux,
      -- Global
      nuke           => nuke,
      soft_rst       => soft_rst,
      -- DAC8568
      dac8568_busy   => dac8568_busy,
      dac8568_rst    => dac8568_rst,
      dac8568_start  => dac8568_start,
      dac8568_sel_ch => dac8568_sel_ch,
      dac8568_data_a => dac8568_data_a,
      dac8568_data_b => dac8568_data_b,
      dac8568_data_c => dac8568_data_c,
      dac8568_data_d => dac8568_data_d,
      dac8568_data_e => dac8568_data_e,
      dac8568_data_f => dac8568_data_f,
      dac8568_data_g => dac8568_data_g,
      dac8568_data_h => dac8568_data_h,
      --SCA
      start_pad=> start_pad,
      trigger_pad=> trigger_pad,
      enable_r_dff=> enable_r_dff,
      din_dff=> din_dff,
      bit_0_cp=> bit_0_cp,
      bit_1_cp=> bit_1_cp,
      -- MMCM DRP Ports
      drp_out => drp_m2s,
	  drp_in => drp_s2m,
	  -- FREQ CTR
	  clk_ctr_in => clk_sca_div
      );

  inst_dac_8568 : entity work.dac_inter8568
    port map(
      clk       => clk_aux,
      reset     => dac8568_rst,
      busy_8568 => dac8568_busy,
      start     => dac8568_start,
      ch        => dac8568_sel_ch,
      dataa     => dac8568_data_a,
      datab     => dac8568_data_b,
      datac     => dac8568_data_c,
      datad     => dac8568_data_d,
      datae     => dac8568_data_e,
      dataf     => dac8568_data_f,
      datag     => dac8568_data_g,
      datah     => dac8568_data_h,

      din  => DAC_DIN,
      sclk => DAC_SCLK,
      syn  => DAC_SYNC_N
      ); 

  inst_sca_control : entity work.sca_control
    generic map(
      N_DRP => N_DRP
      )
    port map(
      rst         => rst,
      clk_125     => clk_125M,
      clk_REF     => clk_REF,
      clk_DFF     => clk_DFF,
      locked      => sca_clocks_locked,
      -- MMCM DRP Ports
      drp_out => drp_s2m,
	  drp_in => drp_m2s
      );
  
  clk_REF_OBUFDS_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT", -- Specify the output I/O standard
      SLEW => "SLOW")          -- Specify the output slew rate
   port map (
      O => clk_REF_p,     -- Diff_p output (connect directly to top-level port)
      OB => clk_REF_n,   -- Diff_n output (connect directly to top-level port)
      I => clk_REF      -- Buffer input 
   );
   
   clk_DFF_OBUFDS_inst : OBUFDS
   generic map (
      IOSTANDARD => "DEFAULT", -- Specify the output I/O standard
      SLEW => "SLOW")          -- Specify the output slew rate
   port map (
      O => clk_DFF_p,     -- Diff_p output (connect directly to top-level port)
      OB => clk_DFF_n,   -- Diff_n output (connect directly to top-level port)
      I => clk_DFF      -- Buffer input 
   );     
 
  clk_sca <= clk_DFF & clk_REF; 
  inst_freq_div: entity work.freq_ctr_div
	generic map(
		N_CLK => N_CLK
	)
	port map(
		clk => clk_sca,
		clkdiv =>  clk_sca_div
	);

end rtl;
