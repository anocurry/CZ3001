`timescale 1ns / 1ps
`include "define.v"

////////////////////////////////////////////////////////////////////////////////
// Company: NTU
// Engineer:Dr. Smitha K G

// 
////////////////////////////////////////////////////////////////////////////////

module test_bench_5_stage_pipeline;

	// Inputs
	reg clk;
	reg rst;
	reg fileid;
	wire [`ISIZE-1:0]PCOUT;
	wire [`DSIZE-1:0] rdata1;
	wire [`DSIZE-1:0] rdata2;
	wire [`DSIZE-1:0]INST;	
	wire [`DSIZE-1:0] aluout;
	wire [`DSIZE-1:0] rdata1_out_ID_EXE;
	wire [`DSIZE-1:0] rdata2_out_ID_EXE;
	wire [`DSIZE-1:0] imm_out_ID_EXE;
	wire [2:0] aluop_out_ID_EXE;
	wire alusrc_out_ID_EXE;
	wire [`ASIZE-1:0]waddr_out_ID_EXE;
	wire [`ISIZE-1:0] PCIN_out_ID_EXE;
	wire wen_out_ID_EXE;
	wire branch_out_ID_EXE;	
	wire memwrite_out_ID_EXE;
	wire memread_out_ID_EXE;
	wire memtoreg_out_ID_EXE;
	wire [`DSIZE-1:0] result_out_EXE_MEM;
	wire [`DSIZE-1:0] rdata2_out_EXE_MEM;
	wire [`ASIZE-1:0] waddr_out_EXE_MEM;
	wire wen_out_EXE_MEM;
	wire memwrite_out_EXE_MEM;
	wire memread_out_EXE_MEM;
	wire memtoreg_out_EXE_MEM;
	wire [`DSIZE-1:0] result_out_MEM_WB;
	wire [`ASIZE-1:0] waddr_out_MEM_WB;
	wire wen_out_MEM_WB;
	wire memtoreg_out_MEM_WB;				
			
	pipelined_regfile_5stage uut(
		.clk(clk), 
		.rst(rst), 
		.fileid(fileid),
		.PCOUT(PCOUT), 
		.INST(INST), 
		.rdata1(rdata1), 
		.rdata2(rdata2), 
		.aluout(aluout), 
		.rdata1_out_ID_EXE(rdata1_out_ID_EXE), 
		.rdata2_out_ID_EXE(rdata2_out_ID_EXE), 
		.imm_out_ID_EXE(imm_out_ID_EXE), 
		.aluop_out_ID_EXE(aluop_out_ID_EXE),
		.alusrc_out_ID_EXE(alusrc_out_ID_EXE), 
		.waddr_out_ID_EXE(waddr_out_ID_EXE), 
		.PCIN_out_ID_EXE(PCIN_out_ID_EXE), 
		.wen_out_ID_EXE(wen_out_ID_EXE), 
		.branch_out_ID_EXE(branch_out_ID_EXE), 
		.memwrite_out_ID_EXE(memwrite_out_ID_EXE),
		.memread_out_ID_EXE(memread_out_ID_EXE), 
		.memtoreg_out_ID_EXE(memtoreg_out_ID_EXE), 
		.result_out_EXE_MEM(result_out_EXE_MEM), 
		.rdata2_out_EXE_MEM(rdata2_out_EXE_MEM), 
		.waddr_out_EXE_MEM(waddr_out_EXE_MEM), 
		.wen_out_EXE_MEM(wen_out_EXE_MEM), 
		.memwrite_out_EXE_MEM(memwrite_out_EXE_MEM), 
		.memread_out_EXE_MEM(memread_out_EXE_MEM), 
		.memtoreg_out_EXE_MEM(memtoreg_out_EXE_MEM),
		.result_out_MEM_WB(result_out_MEM_WB), 
		.waddr_out_MEM_WB(waddr_out_MEM_WB),
		.wen_out_MEM_WB(wen_out_MEM_WB), 
		.memtoreg_out_MEM_WB(memtoreg_out_MEM_WB)
	);				

	// Instantiate the Unit Under Test (UUT)

always #15 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		fileid = 0;


		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
#25 rst =1;
#25 rst=0;


	end
      
endmodule

