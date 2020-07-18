----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/09/2020 06:20:05 PM
-- Design Name: 
-- Module Name: sca_control - behv
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
library UNISIM;
use UNISIM.VComponents.all;

use work.drp_decl.all;

entity sca_control is
  generic(
    N_DRP : integer:= 2
    );
  port(
    rst : in std_logic;
    clk_125 : in std_logic;

    -- SCA Clocks
    clk_REF_p : out std_logic;
    clk_REF_n : out std_logic;
    clk_DFF_p : out std_logic;
    clk_DFF_n : out std_logic;

    -- MMCM DRP Ports
    drp_out: out drp_rbus_array(N_DRP-1 downto 0);
    drp_in: in drp_wbus_array(N_DRP-1 downto 0)
    );
end sca_control;

architecture behv of sca_control is

  signal clkout0_p_arr: std_logic_vector(N_DRP-1 downto 0);
  signal clkout0_n_arr: std_logic_vector(N_DRP-1 downto 0);
    

  signal clkin_bufgout, CLKIN_ibuf : std_logic;
  signal clkfb_bufgout, clkfb_bufgin : std_logic_vector(N_DRP-1 downto 0);
  
--  signal drp_addr : std_logic_vector (6 downto 0);

begin
  
--  drp_addr <= drp_in.addr(6 downto 0);
  
  CLKIN_ibuf <= clk_125;
  
  clk_REF_p <= clkout0_p_arr(0);
  clk_REF_n <= clkout0_n_arr(0);
  clk_DFF_p <= clkout0_p_arr(1);
  clk_DFF_n <= clkout0_n_arr(1);
  
  BUFG_IN : BUFG port map(O => clkin_bufgout, I => CLKIN_ibuf);

  mmcm2e_drp_gen: for drp_index in N_DRP-1 downto 0 generate
  
      BUFG_FB : BUFG port map(O => clkfb_bufgout(drp_index), I => clkfb_bufgin(drp_index));

      MMCME2_ADV_inst : MMCME2_ADV
        generic map (
          BANDWIDTH => "OPTIMIZED",  -- Jitter programming (OPTIMIZED, HIGH, LOW)
          CLKFBOUT_MULT_F => 5.0,  -- Multiply value for all CLKOUT (2.000-64.000).
          CLKFBOUT_PHASE => 0.0,  -- Phase offset in degrees of CLKFB (-360.000-360.000).
          -- CLKIN_PERIOD: Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
          CLKIN1_PERIOD => 8.0,
          CLKIN2_PERIOD => 0.0,
          -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for CLKOUT (1-128)
          CLKOUT1_DIVIDE => 1,
          CLKOUT2_DIVIDE => 1,
          CLKOUT3_DIVIDE => 1,
          CLKOUT4_DIVIDE => 1,
          CLKOUT5_DIVIDE => 1,
          CLKOUT6_DIVIDE => 1,
          CLKOUT0_DIVIDE_F => 1.0,  -- Divide amount for CLKOUT0 (1.000-128.000).
          -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for CLKOUT outputs (0.01-0.99).
          CLKOUT0_DUTY_CYCLE => 0.5,
          CLKOUT1_DUTY_CYCLE => 0.5,
          CLKOUT2_DUTY_CYCLE => 0.5,
          CLKOUT3_DUTY_CYCLE => 0.5,
          CLKOUT4_DUTY_CYCLE => 0.5,
          CLKOUT5_DUTY_CYCLE => 0.5,
          CLKOUT6_DUTY_CYCLE => 0.5,
          -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for CLKOUT outputs (-360.000-360.000).
          CLKOUT0_PHASE => 0.0,
          CLKOUT1_PHASE => 0.0,
          CLKOUT2_PHASE => 0.0,
          CLKOUT3_PHASE => 0.0,
          CLKOUT4_PHASE => 0.0,
          CLKOUT5_PHASE => 0.0,
          CLKOUT6_PHASE => 0.0,
          CLKOUT4_CASCADE => false,  -- Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
          COMPENSATION => "ZHOLD",  -- ZHOLD, BUF_IN, EXTERNAL, INTERNAL
          DIVCLK_DIVIDE => 1,  -- Master division value (1-106)
          -- REF_JITTER: Reference input jitter in UI (0.000-0.999).
          REF_JITTER1 => 0.0,
          REF_JITTER2 => 0.0,
          STARTUP_WAIT => false,  -- Delays DONE until MMCM is locked (FALSE, TRUE)
          -- Spread Spectrum: Spread Spectrum Attributes
          SS_EN => "FALSE",  -- Enables spread spectrum (FALSE, TRUE)
          SS_MODE => "CENTER_HIGH",  -- CENTER_HIGH, CENTER_LOW, DOWN_HIGH, DOWN_LOW
          SS_MOD_PERIOD => 10000,  -- Spread spectrum modulation period (ns) (VALUES)
          -- USE_FINE_PS: Fine phase shift enable (TRUE/FALSE)
          CLKFBOUT_USE_FINE_PS => false,
          CLKOUT0_USE_FINE_PS => false,
          CLKOUT1_USE_FINE_PS => false,
          CLKOUT2_USE_FINE_PS => false,
          CLKOUT3_USE_FINE_PS => false,
          CLKOUT4_USE_FINE_PS => false,
          CLKOUT5_USE_FINE_PS => false,
          CLKOUT6_USE_FINE_PS => false
          )
        port map (
          -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
          CLKOUT0 => clkout0_p_arr(drp_index),  -- 1-bit output: CLKOUT0
          CLKOUT0B => clkout0_n_arr(drp_index),  -- 1-bit output: Inverted CLKOUT0
          CLKOUT1 => open,  -- 1-bit output: CLKOUT1
          CLKOUT1B => open,  -- 1-bit output: Inverted CLKOUT1
          CLKOUT2 => open,  -- 1-bit output: CLKOUT2
          CLKOUT2B => open,  -- 1-bit output: Inverted CLKOUT2
          CLKOUT3 => open,  -- 1-bit output: CLKOUT3
          CLKOUT3B => open,  -- 1-bit output: Inverted CLKOUT3
          CLKOUT4 => open,  -- 1-bit output: CLKOUT4
          CLKOUT5 => open,  -- 1-bit output: CLKOUT5
          CLKOUT6 => open,  -- 1-bit output: CLKOUT6
          -- DRP Ports: 16-bit (each) output: Dynamic reconfiguration ports
          DO => drp_out(drp_index).data,  -- 16-bit output: DRP data
          DRDY => drp_out(drp_index).rdy,  -- 1-bit output: DRP ready
          -- Dynamic Phase Shift Ports: 1-bit (each) output: Ports used for dynamic phase shifting of the outputs
          PSDONE => open,  -- 1-bit output: Phase shift done
          -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
          CLKFBOUT => clkfb_bufgin(drp_index),  -- 1-bit output: Feedback clock
          CLKFBOUTB => open,  -- 1-bit output: Inverted CLKFBOUT
          -- Status Ports: 1-bit (each) output: MMCM status ports
          CLKFBSTOPPED => open,  -- 1-bit output: Feedback clock stopped
          CLKINSTOPPED => open,  -- 1-bit output: Input clock stopped
          LOCKED => open,  -- 1-bit output: LOCK
          -- Clock Inputs: 1-bit (each) input: Clock inputs
          CLKIN1 => clkin_bufgout,  -- 1-bit input: Primary clock
          CLKIN2 => '0',  -- 1-bit input: Secondary clock
          -- Control Ports: 1-bit (each) input: MMCM control ports
          CLKINSEL => '1',  -- 1-bit input: Clock select, High=CLKIN1 Low=CLKIN2
          PWRDWN => '0',  -- 1-bit input: Power-down
          RST => rst,  -- 1-bit input: Reset
          -- DRP Ports: 7-bit (each) input: Dynamic reconfiguration ports
          DADDR => drp_in(drp_index).addr(6 downto 0),  -- 7-bit input: DRP address
          DCLK => CLKIN_ibuf,  -- 1-bit input: DRP clock
          DEN => drp_in(drp_index).en,  -- 1-bit input: DRP enable
          DI => drp_in(drp_index).data,  -- 16-bit input: DRP data
          DWE => drp_in(drp_index).we,  -- 1-bit input: DRP write enable
          -- Dynamic Phase Shift Ports: 1-bit (each) input: Ports used for dynamic phase shifting of the outputs
          PSCLK => '0',  -- 1-bit input: Phase shift clock
          PSEN => '0',  -- 1-bit input: Phase shift enable
          PSINCDEC => '0',  -- 1-bit input: Phase shift increment/decrement
          -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
          CLKFBIN => clkfb_bufgout(drp_index)  -- 1-bit input: Feedback clock
          );
      end generate;
      
end behv;
