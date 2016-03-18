
`include "define.v"

module MEM_WB_stage(
	input clk, rst,
	input [`DSIZE-1:0] result_in,
	input [`ASIZE-1:0] waddr_in,
	input wen_in,
	input memtoreg_in,
	
	output reg [`DSIZE-1:0] result_out,
	output reg [`ASIZE-1:0] waddr_out,
	output reg wen_out,
	output reg memtoreg_out
		
    );
	 
always @ (posedge clk) begin
	if(rst)
	begin
		result_out<=0;
		waddr_out<=0;
		wen_out<=0;
		memtoreg_out<=0;
	
	end
   else
	begin
		result_out<=result_in;
		waddr_out<=waddr_in;
		wen_out<=wen_in;
		memtoreg_out<=memtoreg_in;	
	end
 
end
endmodule
