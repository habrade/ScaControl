`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:11:27 10/14/2013 
// Design Name: 
// Module Name:    DA_testmodule 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module DA_testmodule(reset,clk_50M,din,sclk,syn,start,aclr,ldac,busy
    );
input reset;  //low active
input start;  //low active
input clk_50M;
output aclr;
output ldac;
output din;
output sclk;
output syn;
output busy;

reg [15:0] cnt;
reg flag;
wire clk_50M;
always@(posedge clk_50M)// data stepping
begin
if(!start && !flag)
	begin
	flag<=1;
	cnt<=cnt+16'h00f0;
	end
else
	begin
	flag<=0;
	end
end

//DCM_50M DCM_inst_div2(.CLKIN_IN(clk_100M), .RST_IN(~reset), .CLKDV_OUT(clk_50M), .CLKIN_IBUFG_OUT(), .CLK0_OUT(),.LOCKED_OUT());


dac_inter8568 dac_inter_inst(.reset(reset),.start(~start),.clk(clk_50M),
              .ch(8'hFF), //set output channel
				  .dataa(16'h6666),.datab(16'h6666),.datac(16'h6666),.datad(16'h6666), // set output dataa,datab,datac,datad,datae,dataf,datag,datah
				  .datae(16'h6666),.dataf(16'h6666),.datag(16'h6666),.datah(16'h6666),
				  .din(din),.sclk(sclk),.syn(syn),.busy_8568(busy));


assign aclr=1'b1;
assign ldac=1'b0;


endmodule
