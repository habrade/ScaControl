#-------------------------------------------------------------------------------
#
#   Copyright 2017 - Rutherford Appleton Laboratory and University of Bristol
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
#                                     - - -
#
#   Additional information about ipbus-firmare and the list of ipbus-firmware
#   contacts are available at
#
#       https://ipbus.web.cern.ch/ipbus
#
#-------------------------------------------------------------------------------


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# System clock (200MHz)
create_clock -period 5.000 -name sysclk [get_ports sysclk_p]

set_property PACKAGE_PIN V11 [get_ports rst]
set_property IOSTANDARD LVCMOS15 [get_ports rst]

set_false_path -through [get_pins ipbus_infra/clocks/rst_reg/Q]
set_false_path -through [get_nets ipbus_infra/clocks/nuke_i]

set_property IOSTANDARD LVDS [get_ports {sysclk_*}]
set_property PACKAGE_PIN AB11 [get_ports sysclk_p]
set_property PACKAGE_PIN AC11 [get_ports sysclk_n]

set_property IOSTANDARD LVCMOS25 [get_ports {leds[*]}]
set_property SLEW SLOW [get_ports {leds[*]}]
set_property PACKAGE_PIN K26 [get_ports {leds[0]}]
set_property PACKAGE_PIN K25 [get_ports {leds[1]}]
set_property PACKAGE_PIN N16 [get_ports {leds[2]}]
set_property PACKAGE_PIN K21 [get_ports {leds[3]}]
false_path {leds[*]} sysclk

set_property IOSTANDARD LVCMOS25 [get_ports {gmii* phy_rst}]
set_property PACKAGE_PIN J15 [get_ports {gmii_gtx_clk}]
set_property PACKAGE_PIN H18  [get_ports {gmii_tx_en}]
set_property PACKAGE_PIN D19  [get_ports {gmii_tx_er}]
set_property PACKAGE_PIN E15 [get_ports {gmii_txd[0]}]
set_property PACKAGE_PIN D15 [get_ports {gmii_txd[1]}]
set_property PACKAGE_PIN C18 [get_ports {gmii_txd[2]}]
set_property PACKAGE_PIN F15 [get_ports {gmii_txd[3]}]
set_property PACKAGE_PIN G15 [get_ports {gmii_txd[4]}]
set_property PACKAGE_PIN G16 [get_ports {gmii_txd[5]}]
set_property PACKAGE_PIN J16 [get_ports {gmii_txd[6]}]
set_property PACKAGE_PIN H16 [get_ports {gmii_txd[7]}]
set_property PACKAGE_PIN G22 [get_ports {gmii_rx_clk}]
set_property PACKAGE_PIN D23 [get_ports {gmii_rx_dv}]
set_property PACKAGE_PIN G25 [get_ports {gmii_rx_er}]
set_property PACKAGE_PIN F24 [get_ports {gmii_rxd[0]}]
set_property PACKAGE_PIN J21 [get_ports {gmii_rxd[1]}]
set_property PACKAGE_PIN D24 [get_ports {gmii_rxd[2]}]
set_property PACKAGE_PIN D25 [get_ports {gmii_rxd[3]}]
set_property PACKAGE_PIN E23 [get_ports {gmii_rxd[4]}]
set_property PACKAGE_PIN G24 [get_ports {gmii_rxd[5]}]
set_property PACKAGE_PIN F23 [get_ports {gmii_rxd[6]}]
set_property PACKAGE_PIN F22 [get_ports {gmii_rxd[7]}]
set_property PACKAGE_PIN D16 [get_ports {phy_rst}]


set_property PACKAGE_PIN T22      [get_ports DAC_SCLK]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SCLK]

set_property PACKAGE_PIN T20      [get_ports DAC_DIN]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_DIN]

set_property PACKAGE_PIN F19      [get_ports DAC_SYNC_N]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SYNC_N]

set_property PACKAGE_PIN B15      [get_ports clk_REF_p]
set_property IOSTANDARD  LVDS_25  [get_ports clk_REF_p]
set_property PACKAGE_PIN A15      [get_ports clk_REF_n]
set_property IOSTANDARD  LVDS_25  [get_ports clk_REF_n]

set_property PACKAGE_PIN B14      [get_ports clk_DFF_p]
set_property IOSTANDARD  LVDS_25  [get_ports clk_DFF_p]
set_property PACKAGE_PIN A14      [get_ports clk_DFF_n]
set_property IOSTANDARD  LVDS_25  [get_ports clk_DFF_n]


set_property PACKAGE_PIN F14     [get_ports start_pad]
set_property IOSTANDARD  LVCMOS25  [get_ports start_pad]

set_property PACKAGE_PIN F13      [get_ports trigger_pad]
set_property IOSTANDARD  LVCMOS25  [get_ports trigger_pad]

set_property PACKAGE_PIN F10      [get_ports enable_r_dff]
set_property IOSTANDARD  LVCMOS25  [get_ports enable_r_dff]

set_property PACKAGE_PIN G11      [get_ports din_dff]
set_property IOSTANDARD  LVCMOS25  [get_ports din_dff]

set_property PACKAGE_PIN G12      [get_ports bit_0_cp]
set_property IOSTANDARD  LVCMOS25  [get_ports bit_0_cp]

set_property PACKAGE_PIN F12      [get_ports bit_1_cp]
set_property IOSTANDARD  LVCMOS25  [get_ports bit_1_cp]


# IPbus clock
create_generated_clock -name ipbus_clk -source [get_pins ipbus_infra/clocks/mmcm/CLKIN1] [get_pins ipbus_infra/clocks/mmcm/CLKOUT3]
create_generated_clock -name clk_125M -source [get_pins ipbus_infra/clocks/mmcm/CLKIN1] [get_pins ipbus_infra/clocks/mmcm/CLKOUT1]

# Other derived clocks
create_generated_clock -name clk_aux -source [get_pins ipbus_infra/clocks/mmcm/CLKIN1] [get_pins ipbus_infra/clocks/mmcm/CLKOUT4]
create_generated_clock -name clk_REF -source [get_pins inst_sca_control/mmcm2e_drp_gen[0].MMCME2_ADV_inst/CLKIN1] [get_pins inst_sca_control/mmcm2e_drp_gen[0].MMCME2_ADV_inst/CLKOUT0]
create_generated_clock -name clk_DFF -source [get_pins inst_sca_control/mmcm2e_drp_gen[1].MMCME2_ADV_inst/CLKIN1] [get_pins inst_sca_control/mmcm2e_drp_gen[1].MMCME2_ADV_inst/CLKOUT0]
create_generated_clock -name clk_div_0 -source [get_pins inst_freq_div/clkdiv[0]] -divide_by 64 -multiply_by 1 [get_pins inst_freq_div/clk[0]]
create_generated_clock -name clk_div_1 -source [get_pins inst_freq_div/clkdiv[1]] -divide_by 64 -multiply_by 1 [get_pins inst_freq_div/clk[1]]

set_false_path -through [get_pins ipbus_infra/clocks/rst_reg/Q]
set_false_path -through [get_nets ipbus_infra/clocks/nuke_i]


set_clock_groups -asynchronous -group [get_clocks ipbus_clk] -group [get_clocks -include_generated_clocks [get_clocks clk_aux]]
set_clock_groups -asynchronous -group [get_clocks ipbus_clk] -group [get_clocks -include_generated_clocks [get_clocks clk_REF]]
set_clock_groups -asynchronous -group [get_clocks ipbus_clk] -group [get_clocks -include_generated_clocks [get_clocks clk_DFF]]
set_clock_groups -asynchronous -group [get_clocks clk_div_0] -group [get_clocks -include_generated_clocks [get_clocks clk_div_1]]