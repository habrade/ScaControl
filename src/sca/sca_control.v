module sca_control(
input rst,
input clk_125,


output reg clk_REF,
output reg start_pad,
output reg trigger_pad,
output reg RN_DFF,
output reg SR_DFF,
output reg clk_DFF

);
reg [5:0] counter_REF;
reg [10:0] counter_trigger;
reg [4:0] counter_DFF;

reg clk_DFF_1,clk_DFF_2,clk_DFF_3,clk_DFF_4,clk_DFF_5,clk_DFF_6,clk_DFF_7;
//assign clk_REF = clk;

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		counter_REF <= 6'd0;
	else if (counter_REF == 6'd32)
		counter_REF <= 6'd0;
	else
		counter_REF <= counter_REF + 1'b1;
end



always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_REF <= 6'd1;
	else if (counter_REF == 6'd16)
		clk_REF <= 6'd0;
	else if (counter_REF == 6'd0)
		clk_REF <= 6'd1;		
	else
		clk_REF <= clk_REF;
end



always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		start_pad <= 1'd0;
	else if(counter_REF == 6'd17)
		start_pad <= 1'b1;
	else
		start_pad <= start_pad;
end



always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		counter_trigger <= 11'd1;
	else if (counter_trigger)
		counter_trigger <= counter_trigger + 1'b1;
	else 
		counter_trigger <= 11'd0;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		trigger_pad <= 1'd0;
	else if(counter_trigger == 11'd1152)
		trigger_pad <= 1'b1;
	else if(counter_trigger == 11'd1185)
		trigger_pad <= 1'b0;
	else
		trigger_pad <= trigger_pad;
end

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		RN_DFF <= 1'd0;
	else if(counter_trigger == 11'd1137)
		RN_DFF <= 1'b1;
	else
		RN_DFF <= RN_DFF;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		SR_DFF <= 1'd0;
	else if(counter_trigger == 11'd1163)
		SR_DFF <= 1'b1;
	else if(counter_trigger == 11'd1176)
		SR_DFF <= 1'b0;		
	else
		SR_DFF <= SR_DFF;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		counter_DFF <= 6'd0;
	else if (counter_DFF == 6'd14)
		counter_DFF <= 6'd0;
	else
		counter_DFF <= counter_DFF + 1'b1;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_3 <= 6'd0;
	else
		clk_DFF_3 <= clk_DFF_1;
end

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_4 <= 6'd0;
	else
		clk_DFF_4 <= clk_DFF_3;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_5 <= 6'd0;
	else
		clk_DFF_5 <= clk_DFF_4;
end

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_6 <= 6'd0;
	else
		clk_DFF_6 <= clk_DFF_5;
end

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_7 <= 6'd0;
	else
		clk_DFF_7 <= clk_DFF_6;
end



//////// clk_DFF 104us 9.35us ///////////

always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_1 <= 6'd0;
	else if (counter_DFF == 6'd7)
		clk_DFF_1 <= 6'd1;
	else if (counter_DFF == 6'd0)
		clk_DFF_1 <= 6'd0;		
	else
		clk_DFF_1 <= clk_DFF_1;
end


always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF_2 <= 1'd0;
	else if(counter_trigger == 11'd1165)
		clk_DFF_2 <= 1'b1;
	else
		clk_DFF_2 <= clk_DFF_2;
end



always @(posedge clk_125 or posedge rst)
begin
	if (rst)
		clk_DFF <= 1'd0;
	else if(clk_DFF_2)
		clk_DFF <= clk_DFF_7;
	else
		clk_DFF <= clk_DFF;
end

//////////////////////////////////////

endmodule
