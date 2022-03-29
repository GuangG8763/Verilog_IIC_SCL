module SCL
(
	input			I_clk_100Mhz	,	// input 100Mhz:10ns
	input			I_rst_n			,	// reset system
	input			I_SCL_en		,	// enable 
	output			O_SCL_POS		,	// 上緣pulse
	output			O_SCL_HIG		,	// HIGH中間pulse
	output			O_SCL_NEG		,	// 下緣pulse
	output			O_SCL_LOW		,	// LOW中間pulse
	output			O_SCL				// SCL實際輸出
);

parameter       C_1Mhz			= 12'd100	,	
				C_400Khz		= 12'd250	,
				C_100khz		= 12'd1000	;
				
parameter       C_CLK_SELECT	= C_1Mhz	; //selet HZ

parameter		C_DIV_SELECT0   = (C_CLK_SELECT >> 2) - 1, //  1/4 = HIG中間 		
				C_DIV_SELECT1	= (C_CLK_SELECT >> 1) - 1, //  1/2 = 下緣			
				C_DIV_SELECT2	= (C_DIV_SELECT0 + C_DIV_SELECT1) + 1;// 3/4 = LOG中間

reg	[11:0]		R_SCL_cnt	= 0		;	//產生SCL計數器 

assign			O_SCL_POS	= (R_SCL_cnt == 0) ? 1'b1 : 1'b0;				// 
assign			O_SCL_HIG	= (R_SCL_cnt == C_DIV_SELECT0) ? 1'b1 : 1'b0;	// 
assign			O_SCL_NEG	= (R_SCL_cnt == C_DIV_SELECT1) ? 1'b1 : 1'b0;	// 
assign			O_SCL_LOW	= (R_SCL_cnt == C_DIV_SELECT2) ? 1'b1 : 1'b0;	// 
assign 			O_SCL  		= (R_SCL_cnt <  C_DIV_SELECT1) ? 1'b1 : 1'b0;	// counter 小於下緣

always@(posedge I_clk_100Mhz or negedge I_rst_n)  
begin  
	if(!I_rst_n)
		R_SCL_cnt <= 0;
	else if(I_SCL_en == 1'b1)	//en pin high action
	begin
		if(R_SCL_cnt == C_CLK_SELECT) //計算到counter次數清0
			R_SCL_cnt <= 0;
		else
			R_SCL_cnt <= R_SCL_cnt + 1'b1;
	end
	else
		R_SCL_cnt <= 0;
end


endmodule 