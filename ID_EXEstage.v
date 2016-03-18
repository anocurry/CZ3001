`include "define.v"

module ID_EXE_stage (
	
	input  clk,  rst, 
	input [`DSIZE-1:0] rdata1_in,
	input [`DSIZE-1:0] rdata2_in,
	input [`DSIZE-1:0] imm_in,
	input [2:0] aluop_in, //change
	input alusrc_in,
	input [`ASIZE-1:0]waddr_in,
	input [`ISIZE-1:0] PCIN_in,
	input wen_in,
	input branch_in,
	input memwrite_in,
	input memread_in,
	input memtoreg_in,

	output reg [`DSIZE-1:0] rdata1_out,
	output reg [`DSIZE-1:0] rdata2_out,
	output reg [`DSIZE-1:0] imm_out,
	output reg [2:0] aluop_out,
	output reg alusrc_out,
	output reg[`ASIZE-1:0]waddr_out,
	output reg [`ISIZE-1:0] PCIN_out,
	output reg wen_out,
	output reg branch_out,
	output reg memwrite_out,
	output reg memread_out,
	output reg memtoreg_out
);



//here we have not taken write enable (wen) as it is always 1 for R and I type instructions.
//ID_EXE register to save the values.



always @ (posedge clk) begin
	if(rst)
	begin
		waddr_out <= 0;
		rdata1_out <= 0;
		rdata2_out <= 0;
		imm_out<=0;
		aluop_out<=0;
		alusrc_out<=0;
		PCIN_out<=0;
		wen_out<=0;
		branch_out<=0;
		memwrite_out<=0;
		memread_out<=0;
		memtoreg_out<=0;
	end
   else
	begin
		waddr_out <= waddr_in;
		rdata1_out <= rdata1_in;
		rdata2_out <= rdata2_in;
		imm_out<=imm_in;
		aluop_out<=aluop_in;
		alusrc_out<=alusrc_in;
		PCIN_out<=PCIN_in;
		wen_out<=wen_in;
		branch_out<=branch_in;
		memwrite_out<=memwrite_in;
		memread_out<=memread_in;
		memtoreg_out<=memtoreg_in;
	end
 
end
endmodule


