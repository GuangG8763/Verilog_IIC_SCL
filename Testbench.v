`timescale 1ns / 1ns
    
module Testbench;

reg R_CLK = 0; // 100Mzh
reg R_rest = 1;

wire W_SCL_POS	;
wire W_SCL_HIG	;
wire W_SCL_NEG	;
wire W_SCL_LOW	;
wire W_SCL		;

always #5 R_CLK = ~R_CLK; // 100Mzh

initial
begin
	R_rest = 1'b0;
	#100
	R_rest = 1'b1;
	//repeat (1_000_000) @(posedge R_CLK) //10ms
	//R_cnt <= R_cnt + 1'b1;
end

SCL SCL
(
	.I_clk_100Mhz	(R_CLK		),	// input 100Mhz:10ns
	.I_rst_n		(R_rest		),	// reset system
	.I_SCL_en		(1'b1		),	// enable 
	.O_SCL_POS		(W_SCL_POS	),  // 上緣pulse
	.O_SCL_HIG		(W_SCL_HIG	),  // HIGH中間pulse
	.O_SCL_NEG		(W_SCL_NEG	),  // 下緣pulse
	.O_SCL_LOW		(W_SCL_LOW	),  // LOW中間pulse
	.O_SCL          (W_SCL		)   // SCL實際輸出
);

endmodule