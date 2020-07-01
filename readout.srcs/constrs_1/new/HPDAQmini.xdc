#

# system clock interface
set_property VCCAUX_IO DONTCARE [get_ports SYS_CLK_P]
set_property IOSTANDARD DIFF_SSTL15 [get_ports SYS_CLK_P]

set_property IOSTANDARD DIFF_SSTL15 [get_ports SYS_CLK_N]
set_property PACKAGE_PIN AC11 [get_ports SYS_CLK_N]
set_property PACKAGE_PIN AB11 [get_ports SYS_CLK_P]

set_property PACKAGE_PIN V11 [get_ports CPU_RESET]
set_property IOSTANDARD LVCMOS15 [get_ports CPU_RESET]

# UART interface
# connect to usb port RXF
#set_property PACKAGE_PIN T23 [get_ports {USB_RX}]
#set_property IOSTANDARD LVCMOS25 [get_ports {USB_RX}]
# connect to usb port RXF
#set_property PACKAGE_PIN M19 [get_ports {USB_TX}]
#set_property IOSTANDARD LVCMOS25 [get_ports {USB_TX}]

# gigabit eth interface
# 125MHz clock, for GTP/GTH/GTX
set_property PACKAGE_PIN H5 [get_ports SGMIICLK_Q0_N]
set_property PACKAGE_PIN H6 [get_ports SGMIICLK_Q0_P]

set_property PACKAGE_PIN D16 [get_ports PHY_RESET_N]
set_property IOSTANDARD LVCMOS25 [get_ports PHY_RESET_N]
set_property PACKAGE_PIN C17 [get_ports MDIO]
set_property IOSTANDARD LVCMOS25 [get_ports MDIO]
set_property PACKAGE_PIN B25 [get_ports MDC]
set_property IOSTANDARD LVCMOS25 [get_ports MDC]

set_property PACKAGE_PIN D25 [get_ports {RGMII_RXD[3]}]
set_property PACKAGE_PIN D24 [get_ports {RGMII_RXD[2]}]
set_property PACKAGE_PIN J21 [get_ports {RGMII_RXD[1]}]
set_property PACKAGE_PIN F24 [get_ports {RGMII_RXD[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_RXD[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_RXD[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_RXD[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_RXD[0]}]
set_property PACKAGE_PIN F15 [get_ports {RGMII_TXD[3]}]
set_property PACKAGE_PIN C18 [get_ports {RGMII_TXD[2]}]
set_property PACKAGE_PIN D15 [get_ports {RGMII_TXD[1]}]
set_property PACKAGE_PIN E15 [get_ports {RGMII_TXD[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_TXD[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_TXD[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_TXD[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_TXD[0]}]
set_property PACKAGE_PIN H18 [get_ports RGMII_TX_CTL]
set_property PACKAGE_PIN J15 [get_ports RGMII_TXC]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_TX_CTL]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_TXC]
set_property PACKAGE_PIN D23 [get_ports RGMII_RX_CTL]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_RX_CTL]
set_property PACKAGE_PIN G22 [get_ports RGMII_RXC]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_RXC]

# 200MHz onboard diff clock
create_clock -period 5.000 -name system_clock [get_ports SYS_CLK_P]
# 125MHz
create_clock -period 8.000 -name sgmii_clock [get_ports SGMIICLK_Q0_P]

# clock domain interaction
set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks system_clock] -group [get_clocks -include_generated_clocks sgmii_clock]

# control interface
set_false_path -from [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *control_interface_inst*sConfigReg_reg[*]}] -filter {NAME =~ *C}]
set_false_path -from [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *control_interface_inst*sPulseReg_reg[*]}] -filter {NAME =~ *C}]
set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *control_interface_inst*sRegOut_reg[*]}] -filter {NAME =~ *D}]

#create_clock -name rgmii_rxc_clock -period 8 [get_ports RGMII_RXC]
create_clock -period 8.000 [get_ports RGMII_RXC]
#set_clock_groups -asynchronous -group [get_clocks -include_generated_clocks rgmii_rxc_clock] -group [get_clocks -include_generated_clocks sgmii_clock]

set_property IODELAY_GROUP tri_mode_ethernet_mac_iodelay_grp [get_cells -hier -filter {name =~ *trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_idelayctrl_common_i}]

# If TEMAC timing fails, use the following to relax the requirements
# The RGMII receive interface requirement allows a 1ns setup and 1ns hold - this is met but only just so constraints are relaxed
#set_input_delay -clock [get_clocks tri_mode_ethernet_mac_0_rgmii_rx_clk] -max -1.5 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks tri_mode_ethernet_mac_0_rgmii_rx_clk] -min -2.8 [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks tri_mode_ethernet_mac_0_rgmii_rx_clk] -clock_fall -max -1.5 -add_delay [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]
#set_input_delay -clock [get_clocks tri_mode_ethernet_mac_0_rgmii_rx_clk] -clock_fall -min -2.8 -add_delay [get_ports {rgmii_rxd[*] rgmii_rx_ctl}]

# the following properties can be adjusted if requried to adjuct the IO timing
# the value shown (12) is the default used by the IP
# increasing this value will improve the hold timing but will also add jitter.
# set_property IDELAY_VALUE 12 [get_cells -hier -filter {name =~ *trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/delay_rgmii_rx* *trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/rxdata_bus[*].delay_rgmii_rx*}]
set_property IDELAY_VALUE 20 [get_cells -hier -filter {name =~ *trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/delay_rgmii_rx*}]
set_property IDELAY_VALUE 20 [get_cells -hier -filter {name =~ *trimac_fifo_block/trimac_sup_block/tri_mode_ethernet_mac_i/*/rgmii_interface/rxdata_bus[*].delay_rgmii_rx*}]

# FIFO Clock Crossing Constraints
# control signal is synched separately so this is a false path
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_addr_txfer_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/rd_addr_reg[*]}] -to [get_cells -hier -filter {name =~ *fifo*wr_rd_addr_reg[*]}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/wr_store_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *fifo_i/resync_wr_store_frame_tog/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *rx_fifo_i/update_addr_tog_reg}] -to [get_cells -hier -filter {name =~ *rx_fifo_i/sync_rd_addr_tog/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/wr_frame_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_wr_frame_in_fifo/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/wr_frames_in_fifo_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_wr_frames_in_fifo/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/frame_in_fifo_valid_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_fif_valid_tog/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_txfer_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_rd_txfer_tog/data_sync_reg0}] 6.000
set_max_delay -datapath_only -from [get_cells -hier -filter {name =~ *tx_fifo_i/rd_tran_frame_tog_reg}] -to [get_cells -hier -filter {name =~ *tx_fifo_i/resync_rd_tran_frame_tog/data_sync_reg0}] 6.000

# False paths for async reset removal synchronizers
set_false_path -to [get_pins -of_objects [get_cells -hierarchical -filter {NAME =~ *tri_mode_ethernet*reset_sync*}] -filter {NAME =~ *PRE}]



