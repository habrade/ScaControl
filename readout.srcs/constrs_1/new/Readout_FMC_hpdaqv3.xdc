#USER_IN1
#set_property PACKAGE_PIN P21 [get_ports USER_SMA_GPIO_P] 
#set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_P]



# TOF-------------------------------------------------------

set_property PACKAGE_PIN T22      [get_ports DAC_SCLK_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SCLK_FPGA]

set_property PACKAGE_PIN T20      [get_ports DAC_DIN_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_DIN_FPGA]

set_property PACKAGE_PIN F19      [get_ports DAC_SYNC_N_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SYNC_N_FPGA]

set_property PACKAGE_PIN B15      [get_ports clk_p_REF]
set_property IOSTANDARD  LVDS_25  [get_ports clk_p_REF]
set_property PACKAGE_PIN A15      [get_ports clk_n_REF]
set_property IOSTANDARD  LVDS_25  [get_ports clk_n_REF]

set_property PACKAGE_PIN B14      [get_ports clk_p_DFF]
set_property IOSTANDARD  LVDS_25  [get_ports clk_p_DFF]
set_property PACKAGE_PIN A14      [get_ports clk_n_DFF]
set_property IOSTANDARD  LVDS_25  [get_ports clk_n_DFF]


set_property PACKAGE_PIN F14     [get_ports start_pad_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports start_pad_FPGA]

set_property PACKAGE_PIN F13      [get_ports trigger_pad_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports trigger_pad_FPGA]

set_property PACKAGE_PIN F10      [get_ports RN_DFF_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports RN_DFF_FPGA]

set_property PACKAGE_PIN G11      [get_ports SR_DFF_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports SR_DFF_FPGA]

set_property PACKAGE_PIN G12      [get_ports BIT0_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports BIT0_FPGA]

set_property PACKAGE_PIN F12      [get_ports BIT1_FPGA]
set_property IOSTANDARD  LVCMOS25  [get_ports BIT1_FPGA]


#set_property PACKAGE_PIN F14      [get_ports CLK_LDD_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_LDD_P]
#set_property PACKAGE_PIN F13      [get_ports CLK_LDD_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_LDD_N]

#set_property PACKAGE_PIN G12      [get_ports PULSE_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports PULSE_FPGA]

#set_property PACKAGE_PIN F12      [get_ports RN_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports RN_FPGA]

#set_property PACKAGE_PIN M25      [get_ports CLK_S_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports CLK_S_FPGA]

#set_property PACKAGE_PIN L25      [get_ports RST_S_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports RST_S_FPGA]

#set_property PACKAGE_PIN A18      [get_ports SPEAK_S_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports SPEAK_S_FPGA]

#set_property PACKAGE_PIN A19      [get_ports START_S_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports START_S_FPGA]

#set_property PACKAGE_PIN B15      [get_ports EN_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports EN_FPGA]

#set_property PACKAGE_PIN A15      [get_ports ARSTN_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports ARSTN_FPGA]

#set_property PACKAGE_PIN B14      [get_ports CTR0_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports CTR0_FPGA]

#set_property PACKAGE_PIN A14      [get_ports CTR90_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports CTR90_FPGA]

#set_property PACKAGE_PIN C14      [get_ports CTR180_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports CTR180_FPGA]

#set_property PACKAGE_PIN C13      [get_ports CTR270_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports CTR270_FPGA]

#set_property PACKAGE_PIN A13      [get_ports MARKER_A]
#set_property IOSTANDARD  LVCMOS25  [get_ports MARKER_A]

#IO1
#set_property PACKAGE_PIN H12      [get_ports LDD_EN]
#set_property IOSTANDARD  LVCMOS25  [get_ports LDD_EN]
# IO2
#set_property PACKAGE_PIN H11      [get_ports clk_test]
#set_property IOSTANDARD  LVCMOS25  [get_ports clk_test]

#set_property PACKAGE_PIN C9      [get_ports IO3]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO3]

#set_property PACKAGE_PIN B9      [get_ports IO4]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO4]

#set_property PACKAGE_PIN F9      [get_ports IO5]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO5]

#set_property PACKAGE_PIN F8      [get_ports IO6]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO6]

#set_property PACKAGE_PIN H9      [get_ports IO7]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO7]

#set_property PACKAGE_PIN H8      [get_ports IO8]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO8]


# -----------------set IODELAY CTRL location-------
#set_property LOC IDELAYCTRL_X0Y4 [get_cells delayctrl_inst]