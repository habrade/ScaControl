`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:13:45 10/14/2013 
// Design Name: 
// Module Name:    dac_inter8568 
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
module dac_inter8568(
// for test
output reg [15:0] current_state,
input reset,//low active
input start,//edge triggier
input clk,
input [7:0] ch,
input [15:0] dataa,
input [15:0] datab,
input [15:0] datac,
input [15:0] datad,
input [15:0] datae,
input [15:0] dataf,
input [15:0] datag,
input [15:0] datah,
output din,
output sclk,
output syn,
output busy_8568
);

reg [7:0] ch_reg;
reg [15:0] a_dac_reg;
reg [15:0] b_dac_reg;
reg [15:0] c_dac_reg;
reg [15:0] d_dac_reg;
reg [15:0] e_dac_reg;
reg [15:0] f_dac_reg;
reg [15:0] g_dac_reg;
reg [15:0] h_dac_reg;
reg [31:0] pdata;
wire busy,over;
reg start_wr;//edge trigger

wr_inter wr_inter_inst(.reset(reset),.start(start_wr),.clk(clk),.data(pdata),.DIN(din),.SCLK(sclk),.SYN(syn),.over(over));
assign busy=~over;
	 
parameter WAIT=16'h0002,HARDRST=16'h0000,SOFTRST=16'h0001,REFON=16'h0004,POWERCH=16'h0008,
          SETA=16'h0010,SETB=16'h0020,SETC=16'h0040,SETD=16'h0080,SETE=16'h0100,SETF=16'h0200,SETG=16'h0400,SETH=16'h0800,
			 OVER=16'h1000,COMPARE=16'h2000,UPDATE=16'h4000;
 reg master_busy;
 reg start_buf;
 reg [15:0] next_state;
 
 //state machine
 always@(posedge clk or negedge reset)
 begin
 if(!reset)
	begin
		current_state<=HARDRST;
		start_buf<=0;
	end
 else
	begin
		current_state<=next_state;
		start_buf<=start;
	end
 end
 
always@(busy,current_state,start_buf,start)
 begin
 case(current_state)
 HARDRST:begin if(!busy) next_state<=SOFTRST; else next_state<=HARDRST;  end
 SOFTRST:begin if(!busy) next_state<=WAIT; else next_state<=SOFTRST; end
 WAIT:begin//wait start
			if(!start_buf && start)// rising edge
				next_state<=REFON;
			else
				next_state<=WAIT;
		end
 //HARDRST:begin if(!busy) next_state<=SOFTRST; else next_state<=HARDRST;  end
 //SOFTRST:begin if(!busy) next_state<=REFON; else next_state<=SOFTRST; end
 REFON:begin if(!busy) next_state<=UPDATE; else next_state<=REFON; end
 //use to update a~h when they are changed
 /*
 COMPARE:begin
			if(a_dac_reg!=dataa || b_dac_reg!=datab || c_dac_reg!=datac ||d_dac_reg!=datad ||e_dac_reg!=datae ||f_dac_reg!=dataf ||g_dac_reg!=datag ||h_dac_reg!=datah ||ch_reg!=ch)
				next_state<=UPDATE;
			else
				next_state<=COMPARE;
			end
 */
 UPDATE:begin
		  next_state<=POWERCH;
		  end
 POWERCH:begin if(!busy) next_state<=SETA; else next_state<=POWERCH; end
 
 SETA:begin if(!busy) 
              next_state<=SETB;
				else
					next_state<=SETA;
				end
 SETB:begin if(!busy) 
              next_state<=SETC;
				else
					next_state<=SETB;
				end
 SETC:begin if(!busy) 
              next_state<=SETD;
				else
					next_state<=SETC;
				end
 SETD:begin if(!busy) 
              next_state<=SETE;
				else
					next_state<=SETD;
				end
 SETE:begin if(!busy) 
              next_state<=SETF;
				else
					next_state<=SETE;
				end	
 SETF:begin if(!busy) 
              next_state<=SETG;
				else
					next_state<=SETF;
				end
 SETG:begin if(!busy) 
					next_state<=SETH; 
				else 
					next_state<=SETG; 
				end
 SETH:begin if(!busy) 
					next_state<=OVER;
				else 
					next_state<=SETH; 
				end
 OVER:begin next_state<=WAIT; end//master_busy=0
 default:begin next_state<=WAIT; end
 endcase
 end
 
 always@(posedge clk)
 begin
 case(next_state)
 WAIT:begin start_wr<=1'b0;
				master_busy<=1'b0;
				pdata<=32'h0a000000; 
				ch_reg<=0;
				a_dac_reg<=0;
				b_dac_reg<=0;
				c_dac_reg<=0;
				d_dac_reg<=0;
				e_dac_reg<=0;
				f_dac_reg<=0;
				g_dac_reg<=0;
				h_dac_reg<=0; end
 HARDRST:begin start_wr<=1'b1;
					master_busy<=1'b1;
					pdata<=32'h0a000000; 
					ch_reg<=0;
					a_dac_reg<=0;
					b_dac_reg<=0;
					c_dac_reg<=0;
					d_dac_reg<=0;
					e_dac_reg<=0;
					f_dac_reg<=0;
					g_dac_reg<=0;
					h_dac_reg<=0;
			end  //hardware reset
 SOFTRST:begin start_wr<=1'b1; master_busy<=1'b1; pdata<=32'h07000000; end  //software reset
 REFON:begin start_wr<=1'b1; master_busy<=1'b1; pdata<=32'h090a0000; end  //inter reference voltage on
 //COMPARE:begin start_wr<=1'b0; pdata<=32'h0000000; end
 UPDATE:begin  start_wr<=1'b0;
					master_busy<=1'b1;
					ch_reg<=ch;
				   a_dac_reg<=dataa;
					b_dac_reg<=datab;
					c_dac_reg<=datac;
					d_dac_reg<=datad;
					e_dac_reg<=datae;
					f_dac_reg<=dataf;
					g_dac_reg<=datag;
					h_dac_reg<=datah; 
		  end//start<=1'b0; pdata<=32'h0a00000;
 POWERCH:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={24'h040000,ch_reg};end  // Power-up DAC A, B, C, D, E, F, G, H channels
 SETA:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h030,a_dac_reg,4'h0}; end  //a
 SETB:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h031,b_dac_reg,4'h0}; end  //b
 SETC:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h032,c_dac_reg,4'h0}; end  //c
 SETD:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h033,d_dac_reg,4'h0}; end  //d
 SETE:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h034,e_dac_reg,4'h0}; end  //e
 SETF:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h035,f_dac_reg,4'h0}; end  //f
 SETG:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h036,g_dac_reg,4'h0}; end  //g
 SETH:begin start_wr<=1'b1; master_busy<=1'b1; pdata<={12'h037,h_dac_reg,4'h0}; end  //h
 OVER:begin start_wr<=1'b0; master_busy<=1'b0; pdata<=32'h0000000; end
 
 default:begin start_wr<=1'b0; 
					master_busy<=1'b0; 
					pdata<=32'h0000000; 
					ch_reg<=0;
					a_dac_reg<=0;
					b_dac_reg<=0;
					c_dac_reg<=0;
					d_dac_reg<=0;
					e_dac_reg<=0;
					f_dac_reg<=0;
					g_dac_reg<=0;
					h_dac_reg<=0;
			end
 endcase
 end


 assign busy_8568=busy | master_busy;
 
endmodule
