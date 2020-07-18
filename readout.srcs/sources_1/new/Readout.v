`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CCNU
// Engineer: Shen
// 
// Create Date: 2019/10/18 19:03:46
// Design Name: 
// Module Name: Readout
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Readout(
    input wire SYS_CLK_P, //200Mhz
    input wire SYS_CLK_N,
    input wire CPU_RESET,    
    // gig ethernet 
    input wire SGMIICLK_Q0_P,
    input wire SGMIICLK_Q0_N,
    output wire PHY_RESET_N,
    output wire [3:0] RGMII_TXD,
    output wire RGMII_TX_CTL,
    output wire RGMII_TXC,
    input wire [3:0] RGMII_RXD,
    input wire RGMII_RX_CTL,
    input wire RGMII_RXC,
    inout wire MDIO,
    output wire MDC,
    // TOF 

    

    output wire DAC_SCLK_FPGA,
    output wire DAC_DIN_FPGA,
    output wire DAC_SYNC_N_FPGA,
    
    output wire clk_p_REF, //256ns  
    output wire clk_n_REF,
    
    output wire clk_p_DFF, //120ns
    output wire clk_n_DFF,
    
    output wire start_pad_FPGA,
    output wire trigger_pad_FPGA,
    output wire RN_DFF_FPGA,
    output wire SR_DFF_FPGA,
    
    output wire BIT0_FPGA,
    output wire BIT1_FPGA
    );

////////////////////////////////////////////////////////////////
// clock and reset
////////////////////////////////////////////////////////////////
wire reset;
wire sys_clk,clk_50MHz,clk_100MHz,clk_10MHz,clk_125M;
wire clk_DFF_FPGA,clk_REF_FPGA;
global_clock_reset global_clock_reset_inst(
    .SYS_CLK_P(SYS_CLK_P),
    .SYS_CLK_N(SYS_CLK_N),
    .FORCE_RST(CPU_RESET),
    //      -- output
    .GLOBAL_RST(reset),
    .SYS_CLK(sys_clk),
    .CLK_OUT1(clk_50MHz),
    .CLK_OUT2(clk_100MHz),
    .CLK_OUT3(clk_10MHz),
    .CLK_OUT4(clk_125M)
    );     
    
////////////////////////////////////////////////////////////////
// control interface
////////////////////////////////////////////////////////////////

wire [35:0] control_fifo_q;
wire control_fifo_empty;
wire control_fifo_rdreq;
wire control_fifo_rdclk;
wire [35:0] cmd_fifo_q;
wire cmd_fifo_empty;
wire cmd_fifo_rdreq;
wire [575:0] config_reg;
wire [15:0] pulse_reg;
wire [175:0] status_reg;  //?
wire [31:0] fmc112_data_fifo_dout;
wire fmc112_data_fifo_empty;
wire fmc112_data_fifo_rden;
wire fmc112_data_fifo_rdclk;

control_interface control_interface_inst(
    .RESET(reset),
    .CLK(clk_100MHz),
    //      -- From FPGA to PC
    .FIFO_Q(control_fifo_q),
    .FIFO_EMPTY(control_fifo_empty),
    .FIFO_RDREQ(control_fifo_rdreq),
    .FIFO_RDCLK(control_fifo_rdclk),
    //      -- From PC to FPGA, FWFT
    .CMD_FIFO_Q(cmd_fifo_q),
    .CMD_FIFO_EMPTY(cmd_fifo_empty),
    .CMD_FIFO_RDREQ(cmd_fifo_rdreq),
    //      -- Digital I/O
    .CONFIG_REG(config_reg),
    .PULSE_REG(pulse_reg),
    .STATUS_REG(status_reg),
    //      -- Memory interface
    .MEM_WE(),
    .MEM_ADDR(),
    .MEM_DIN(),
    .MEM_DOUT(32'h0),
    //      -- Data FIFO interface, FWFT
    .DATA_FIFO_Q(fmc112_data_fifo_dout),
    .DATA_FIFO_EMPTY(fmc112_data_fifo_empty),
    .DATA_FIFO_RDREQ(fmc112_data_fifo_rden),
    .DATA_FIFO_RDCLK(fmc112_data_fifo_rdclk)
    );
////////////////////////////////////////////////////////////////
// gig_eth
////////////////////////////////////////////////////////////////
wire clk_sgmii_i, clk_125MHz;
IBUFDS_GTE2 #(
    .CLKCM_CFG("TRUE"),   // Refer to Transceiver User Guide
    .CLKRCV_TRST("TRUE"), // Refer to Transceiver User Guide
    .CLKSWING_CFG(2'b11)  // Refer to Transceiver User Guide
    )
    
IBUFDS_GTE2_inst (
    .O(clk_sgmii_i),        // 1-bit output: Refer to Transceiver User Guide
    .ODIV2(),               // 1-bit output: Refer to Transceiver User Guide
    .CEB(1'b0),             // 1-bit input: Refer to Transceiver User Guide
    .I(SGMIICLK_Q0_P),      // 1-bit input: Refer to Transceiver User Guide
    .IB(SGMIICLK_Q0_N)      // 1-bit input: Refer to Transceiver User Guide
    );
    
BUFG BUFG_inst (
    .O(clk_125MHz), // 1-bit output: Clock output
    .I(clk_sgmii_i)  // 1-bit input: Clock input
    );

wire [7:0] gig_eth_tx_tdata,gig_eth_rx_tdata;
wire gig_eth_tx_tvalid,gig_eth_rx_tvalid;
wire gig_eth_tx_tready,gig_eth_rx_tready;
wire gig_eth_tcp_use_fifo;
wire gig_eth_tx_fifo_wrclk;
wire [31:0] gig_eth_tx_fifo_q;
wire gig_eth_tx_fifo_wren;
wire gig_eth_tx_fifo_full;
wire gig_eth_rx_fifo_rdclk;
wire [31:0] gig_eth_rx_fifo_q;
wire gig_eth_rx_fifo_rden;
wire gig_eth_rx_fifo_empty;

wire control_clk;
assign control_clk = clk_100MHz;

gig_eth gig_eth_inst(
    //         -- asynchronous reset
    .GLBL_RST(reset),
    //         -- clocks
    .GTX_CLK(clk_125MHz),
    .REF_CLK(sys_clk), // 200MHz for IODELAY
    //         -- PHY interface
    .PHY_RESETN(PHY_RESET_N),
    //         -- RGMII Interface
    .RGMII_TXD(RGMII_TXD),
    .RGMII_TX_CTL(RGMII_TX_CTL),
    .RGMII_TXC(RGMII_TXC),
    .RGMII_RXD(RGMII_RXD),
    .RGMII_RX_CTL(RGMII_RX_CTL),
    .RGMII_RXC(RGMII_RXC),
    //         -- MDIO Interface
    .MDIO(MDIO),
    .MDC(MDC),
    //         -- TCP
    .TCP_CONNECTION_RESET(1'b0),
    .TX_TDATA(gig_eth_tx_tdata),
    .TX_TVALID(gig_eth_tx_tvalid),
    .TX_TREADY(gig_eth_tx_tready),
    .RX_TDATA(gig_eth_rx_tdata),
    .RX_TVALID(gig_eth_rx_tvalid),
    .RX_TREADY(gig_eth_rx_tready),
    //         -- FIFO
    .TCP_USE_FIFO(gig_eth_tcp_use_fifo),
    .TX_FIFO_WRCLK(gig_eth_tx_fifo_wrclk),
    .TX_FIFO_Q(gig_eth_tx_fifo_q),
    .TX_FIFO_WREN(gig_eth_tx_fifo_wren),
    .TX_FIFO_FULL(gig_eth_tx_fifo_full),
    .RX_FIFO_RDCLK(gig_eth_rx_fifo_rdclk),
    .RX_FIFO_Q(gig_eth_rx_fifo_q),
    .RX_FIFO_RDEN(gig_eth_rx_fifo_rden),
    .RX_FIFO_EMPTY(gig_eth_rx_fifo_empty)
    );   

//    -- loopback
assign gig_eth_tx_tdata = gig_eth_rx_tdata;
assign gig_eth_tx_tvalid = gig_eth_rx_tvalid;
assign gig_eth_rx_tready = gig_eth_tx_tready;

//    -- receive to cmd_fifo
assign gig_eth_tcp_use_fifo = 1'b1;
assign gig_eth_rx_fifo_rdclk = control_clk;
assign cmd_fifo_q[31:0] = gig_eth_rx_fifo_q;  //
//    dbg_ila_probe0(63 DOWNTO 32) <= gig_eth_rx_fifo_q;
assign cmd_fifo_empty = gig_eth_rx_fifo_empty; //
assign gig_eth_rx_fifo_rden = cmd_fifo_rdreq;  //

//    -- send control_fifo data through gig_eth_tx_fifo
assign gig_eth_tx_fifo_wrclk = clk_125MHz;
//    -- connect FWFT fifo interface
assign control_fifo_rdclk = gig_eth_tx_fifo_wrclk;   //
assign gig_eth_tx_fifo_q = control_fifo_q[31:0];     //
assign gig_eth_tx_fifo_wren = ~control_fifo_empty; //
assign control_fifo_rdreq = ~gig_eth_tx_fifo_full;  //

////////////////////////////////////////////////////////////////
// TOF
//////////////////////////////////////////////////////////////// 

reg dac_start_tof;
always @ (posedge clk_10MHz or posedge pulse_reg[1])
begin
    if(pulse_reg[1])
        dac_start_tof <= 1'b1;
    else
        dac_start_tof <= 1'b0;
end

dac_inter8568 dac_inter8568_tof(
    .reset(config_reg[(16*22+8)]), //input reset,//low active
    .start(dac_start_tof), //input start,//edge triggier
    .clk(clk_10MHz), //input clk,
    .ch(config_reg[(16*22+7):(16*22)]), //input [7:0] ch,
    .dataa(config_reg[(16*19+15) : (16*19)]), //input [15:0] dataa,
    .datab(), //input [15:0] datab,
    .datac(config_reg[(16*20+15) : (16*20)]), //input [15:0] datac,
    .datad(), //input [15:0] datad,
    .datae(config_reg[(16*21+15) : (16*21)]), //input [15:0] datae,
    .dataf(), //input [15:0] dataf,
    .datag(), //input [15:0] datag,
    .datah(), //input [15:0] datah,
    .din(DAC_DIN_FPGA), // output din,
    .sclk(DAC_SCLK_FPGA), //output sclk,
    .syn(DAC_SYNC_N_FPGA), //output syn,
    .busy_8568(status_reg[64*2+32]) //output busy_8568 status_reg[64*2+32]
    );
    
//ila_1 ila_1_inst (
//    .clk(clk_100MHz), // input wire clk
//    .probe0(dac_clk), // input wire [0:0]  probe0  
//    .probe1(dac_rst), // input wire [0:0]  probe1 
//    .probe2(dac_start), // input wire [0:0]  probe2 
//    .probe3(dac_busy), // input wire [0:0]  probe3 
//    .probe4(DAC_DIN_FPGA), // input wire [0:0]  probe4 
//    .probe5(DAC_SCLK_FPGA), // input wire [0:0]  probe5 
//    .probe6(DAC_SYNC_N_FPGA), // input wire [0:0]  probe6 
//    .probe7(dac_ch), // input wire [7:0]  probe7 
//    .probe8(dac_A), // input wire [14:0]  probe8 
//    .probe9(dac_C), // input wire [14:0]  probe9
//    .probe10(current_state) // input wire [15:0]  probe10
//);

sca_control sca_control_inst(
.rst( CPU_RESET ),
.clk_125( clk_125M ),   // 125M --- 8ns

.clk_REF(clk_REF_FPGA),
.start_pad(start_pad_FPGA),
.trigger_pad(trigger_pad_FPGA),
.RN_DFF(RN_DFF_FPGA),
.SR_DFF(SR_DFF_FPGA),
.clk_DFF(clk_DFF_FPGA)

);


assign BIT0_FPGA = 1'b1;
assign BIT1_FPGA = 1'b1;


//assign LED_0 = mark_s ? 1'b1: 1'b0;
//spad_single spad_single_inst(
//    .rst( CPU_RESET ),
//    .clk( sys_clk ),
//    .conf(config_reg[16*28:16*27]),
    
//    .CLK( clk_tof ),//64M
//    .RESET_N( RST_S_FPGA ),
//    .STOP( STOP_FPGA ),
//    .R_TAC( R_TAC_FPGA ),
//    .C_TAC( C_TAC_FPGA ),
//    .VK( VK_FPGA )  
//);




//tof tof_inst(           
//    .sys_clk_i(sys_clk),         
//    .rst_p(reset),             
//    .config_reg(config_reg[575:0]),// [575:0]
//    .pulse_reg(pulse_reg[15:0] ),  // 
//    // for test
//    .state_t(state_t),
//    .start_t(start_t),
//    // tof interface
//    .clk_ldd(clk_ldd),
//    .LDD_EN(LDD_EN),
//    .clk_tof(clk_tof),                                                              
//    .PULSE(PULSE_FPGA),                          
//    .RN(RN_FPGA),                                
//    .ARSTN(ARSTN_FPGA),                          
//    .ROWSEL(CLK_S_FPGA),                                   
//    .EN(EN_FPGA),                                
//    .CTR0(CTR0_FPGA),                            
//    .CTR90(CTR90_FPGA),                          
//    .CTR180(CTR180_FPGA),                        
//    .CTR270(CTR270_FPGA),                        
//    .RST_S(RST_S_FPGA),                          
//    .CLK_S(),                          
//    .START_S(START_S_FPGA),                      
//    .SPEAK_S(SPEAK_S_FPGA),                      
//    .MARKER_A(MARKER_A)                          
//    );                                       

OBUFDS #(
    .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
    .SLEW("SLOW")           // Specify the output slew rate
    ) OBUFDS_clk_REF (
    .O(clk_p_REF),     
    .OB(clk_n_REF),   
    .I(clk_REF_FPGA)      // Buffer input 
    );
    
OBUFDS #(
        .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
        .SLEW("SLOW")           // Specify the output slew rate
        ) OBUFDS_clk_DFF (
        .O(clk_p_DFF),     
        .OB(clk_n_DFF),   
        .I(clk_DFF_FPGA)      // Buffer input 
        );
    

endmodule                                    
                                             