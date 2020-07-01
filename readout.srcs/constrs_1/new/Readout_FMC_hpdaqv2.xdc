#USER_IN1
#set_property PACKAGE_PIN P21 [get_ports USER_SMA_GPIO_P] 
#set_property IOSTANDARD LVCMOS25 [get_ports USER_SMA_GPIO_P]

# AD9656
set_property PACKAGE_PIN H9        [get_ports ADC_DSYSREF_P]
set_property IOSTANDARD LVDS_25     [get_ports ADC_DSYSREF_P]
set_property PACKAGE_PIN H8        [get_ports ADC_DSYSREF_N]
set_property IOSTANDARD LVDS_25     [get_ports ADC_DSYSREF_N]

set_property PACKAGE_PIN H14        [get_ports ADC_DSYNC_P]
set_property IOSTANDARD  LVDS_25    [get_ports ADC_DSYNC_P]
set_property PACKAGE_PIN G14        [get_ports ADC_DSYNC_N]
set_property IOSTANDARD  LVDS_25    [get_ports ADC_DSYNC_N]

set_property PACKAGE_PIN G4 [get_ports ADC_SERDOUT0_P] 
set_property PACKAGE_PIN G3 [get_ports ADC_SERDOUT0_N] 
set_property PACKAGE_PIN E4 [get_ports ADC_SERDOUT1_P] 
set_property PACKAGE_PIN E3 [get_ports ADC_SERDOUT1_N] 
set_property PACKAGE_PIN C4 [get_ports ADC_SERDOUT2_P] 
set_property PACKAGE_PIN C3 [get_ports ADC_SERDOUT2_N] 
set_property PACKAGE_PIN B6 [get_ports ADC_SERDOUT3_P] 
set_property PACKAGE_PIN B5 [get_ports ADC_SERDOUT3_N] 

set_property PACKAGE_PIN C16        [get_ports ADC_SYNC]
set_property IOSTANDARD LVCMOS25    [get_ports ADC_SYNC]

# AD9656 & AD9517 control SPI
set_property PACKAGE_PIN G11        [get_ports SCLK_FROM_FPGA]
set_property IOSTANDARD LVCMOS25    [get_ports SCLK_FROM_FPGA]
set_property PACKAGE_PIN F10        [get_ports SDI_FROM_FPGA]
set_property IOSTANDARD LVCMOS25    [get_ports SDI_FROM_FPGA]
set_property PACKAGE_PIN H13        [get_ports SDO_TO_FPGA]
set_property IOSTANDARD LVCMOS25    [get_ports SDO_TO_FPGA]
set_property PACKAGE_PIN J10        [get_ports CSB_FPGA_TO_9517]
set_property IOSTANDARD LVCMOS25    [get_ports CSB_FPGA_TO_9517]
set_property PACKAGE_PIN J13        [get_ports CSB_FPGA_TO_9656]
set_property IOSTANDARD LVCMOS25    [get_ports CSB_FPGA_TO_9656]

# additional SPI interface--------------------------------------
#set_property PACKAGE_PIN R26       [get_ports SPI_CLK]
#set_property IOSTANDARD  LVCMOS25  [get_ports SPI_CLK]
#set_property PACKAGE_PIN N19       [get_ports SPI_SDI]
#set_property IOSTANDARD  LVCMOS25  [get_ports SPI_SDI]
#set_property PACKAGE_PIN N26       [get_ports SPI_CS]
#set_property IOSTANDARD  LVCMOS25  [get_ports SPI_CS]
#set_property PACKAGE_PIN M26       [get_ports SPI_SDO]
#set_property IOSTANDARD  LVCMOS25  [get_ports SPI_SDO]

# DAC8568
set_property PACKAGE_PIN F13        [get_ports DAC_SYNC_N]
set_property IOSTANDARD LVCMOS25    [get_ports DAC_SYNC_N]
set_property PACKAGE_PIN E13        [get_ports DAC_DIN]
set_property IOSTANDARD LVCMOS25    [get_ports DAC_DIN]
set_property PACKAGE_PIN G12        [get_ports DAC_SCLK]
set_property IOSTANDARD LVCMOS25    [get_ports DAC_SCLK]

# AD9517
set_property PACKAGE_PIN A19        [get_ports RESET_N_9517]
set_property IOSTANDARD LVCMOS25    [get_ports RESET_N_9517]
set_property PACKAGE_PIN B16        [get_ports SYNC_N_9517]
set_property IOSTANDARD LVCMOS25    [get_ports SYNC_N_9517]
set_property PACKAGE_PIN C13        [get_ports PD_N_9517]
set_property IOSTANDARD LVCMOS25    [get_ports PD_N_9517]
set_property PACKAGE_PIN D14        [get_ports REF_SEL]
set_property IOSTANDARD LVCMOS25    [get_ports REF_SEL]

#set_property PACKAGE_PIN F17      [get_ports CLK_9517_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_9517_P]
#set_property PACKAGE_PIN E17      [get_ports CLK_9517_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_9517_N]

# CLK0_M2C_P CLK0_M2C_N
set_property PACKAGE_PIN E18     [get_ports glblclk_p]
set_property IOSTANDARD LVDS_25 [get_ports glblclk_p]
set_property PACKAGE_PIN D18     [get_ports glblclk_n]
set_property IOSTANDARD LVDS_25 [get_ports glblclk_n]

#FMC_HPC_GBTCLK1_M2C_C_N FMC_HPC_GBTCLK1_M2C_C_P
set_property PACKAGE_PIN F6 [get_ports refclk_p] 
set_property PACKAGE_PIN F5 [get_ports refclk_n] 

#set_property PACKAGE_PIN F17      [get_ports CLK_9517_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_9517_P]
#set_property PACKAGE_PIN E17      [get_ports CLK_9517_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_9517_N]

#set_property PACKAGE_PIN N21      [get_ports CLK0_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK0_P]
#set_property PACKAGE_PIN N22      [get_ports CLK0_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK0_N]

#set_property PACKAGE_PIN C12      [get_ports CLK1_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK1_P]
#set_property PACKAGE_PIN C11      [get_ports CLK1_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK1_N]

#set_property PACKAGE_PIN E11      [get_ports CLK2_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK2_P]
#set_property PACKAGE_PIN D11      [get_ports CLK2_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK2_N]

#set_property PACKAGE_PIN R21      [get_ports CLK3_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK3_P]
#set_property PACKAGE_PIN P21      [get_ports CLK3_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK3_N]

#set_property PACKAGE_PIN K6      [get_ports GBTCLK0_M2C_P]
#set_property IOSTANDARD  LVDS_25  [get_ports GBTCLK0_M2C_P]
#set_property PACKAGE_PIN K5      [get_ports GBTCLK0_M2C_N]
#set_property IOSTANDARD  LVDS_25  [get_ports GBTCLK0_M2C_N]

# TOF-------------------------------------------------------

#set_property PACKAGE_PIN T22      [get_ports DAC_SCLK_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SCLK_FPGA]

#set_property PACKAGE_PIN T20      [get_ports DAC_DIN_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports DAC_DIN_FPGA]

#set_property PACKAGE_PIN F19      [get_ports DAC_SYNC_N_FPGA]
#set_property IOSTANDARD  LVCMOS25  [get_ports DAC_SYNC_N_FPGA]

#set_property PACKAGE_PIN G11      [get_ports CLK_P]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_P]
#set_property PACKAGE_PIN F10      [get_ports CLK_N]
#set_property IOSTANDARD  LVDS_25  [get_ports CLK_N]

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

#set_property PACKAGE_PIN H12      [get_ports IO1]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO1]

#set_property PACKAGE_PIN H11      [get_ports IO2]
#set_property IOSTANDARD  LVCMOS25  [get_ports IO2]

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