`timescale 1ns / 1ps
`include "define.v"

module pipelined_regfile_5stage(clk, rst, fileid, PCOUT, INST, rdata1, rdata2, aluout, 
rdata1_out_ID_EXE, rdata2_out_ID_EXE, imm_out_ID_EXE, aluop_out_ID_EXE, alusrc_out_ID_EXE, waddr_out_ID_EXE, PCIN_out_ID_EXE, wen_out_ID_EXE, branch_out_ID_EXE, memwrite_out_ID_EXE,memread_out_ID_EXE, memtoreg_out_ID_EXE, 
result_out_EXE_MEM, rdata2_out_EXE_MEM, waddr_out_EXE_MEM, wen_out_EXE_MEM, memwrite_out_EXE_MEM, memread_out_EXE_MEM, memtoreg_out_EXE_MEM,
result_out_MEM_WB, waddr_out_MEM_WB, wen_out_MEM_WB, memtoreg_out_MEM_WB);

input clk;				
											
input	rst;
input fileid; 
 
output [`ISIZE-1:0]PCOUT;
output [`DSIZE-1:0] rdata1;
output [`DSIZE-1:0] rdata2;
output [`DSIZE-1:0]INST;	
output [`DSIZE-1:0] aluout;
output [`DSIZE-1:0] rdata1_out_ID_EXE;
output [`DSIZE-1:0] rdata2_out_ID_EXE;
output [`DSIZE-1:0] imm_out_ID_EXE;
output [2:0] aluop_out_ID_EXE;
output alusrc_out_ID_EXE;
output [`ASIZE-1:0]waddr_out_ID_EXE;
output [`ISIZE-1:0] PCIN_out_ID_EXE;
output wen_out_ID_EXE;
output branch_out_ID_EXE;	
output memwrite_out_ID_EXE;
output memread_out_ID_EXE;
output memtoreg_out_ID_EXE;
output [`DSIZE-1:0] result_out_EXE_MEM;
output [`DSIZE-1:0] rdata2_out_EXE_MEM;
output [`ASIZE-1:0] waddr_out_EXE_MEM;
output wen_out_EXE_MEM;
output memwrite_out_EXE_MEM;
output memread_out_EXE_MEM;
output memtoreg_out_EXE_MEM;
output [`DSIZE-1:0] result_out_MEM_WB;
output [`ASIZE-1:0] waddr_out_MEM_WB;
output wen_out_MEM_WB;
output memtoreg_out_MEM_WB;				
								
 	 
//Program counter
wire [`ISIZE-1:0]PCIN;
wire [`ISIZE-1:0] PC_mux;


PC1 pc(.clk(clk),.rst(rst),.nextPC(PC_mux),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


assign PCIN = PCOUT + 32'b1; //increments PC to PC +1


//instruction memory
memory im( .clk(clk), .rst(rst), .wen(1'b0), .addr(PCOUT), .data_in(32'b0), .fileid(4'b0),.data_out(INST));//note that memory read is having one clock cycle delay as memory is a slow operation

//initialization of regfiles is done as hardcoding here
wire wen;
wire [2:0] aluop;
wire regdst;
wire memtoreg;
wire memread;
wire memwrite;
wire branch;

control C0 (.inst_cntrl(INST[31:26]),.wen_cntrl(wen),.alusrc_cntrl(alusrc), .aluop_cntrl(aluop), .regdst_cntrl(regdst), .memread_cntrl(memread), .memwrite_cntrl(memwrite), .memtoreg_cntrl(memtoreg), .branch(branch));//added

wire [4:0]waddr_in_rf = regdst ? INST[15:11] : INST[20:16];// mux for selecting waddr
wire [`DSIZE-1:0]dm_out_mux=memtoreg_out_MEM_WB ? result_out_MEM_WB : dm_out;// mux for selecting alu output and output from data memory

regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen_out_MEM_WB), .raddr1(INST[25:21]), .raddr2(INST[20:16]), .waddr(waddr_out_MEM_WB), .wdata(dm_out_mux), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 


//sign extension for immediate needs to be done for I type instuction.
//you can add that here
wire [`DSIZE-1:0]extended_imm;
//assign extended_imm=({16'b0,INST[15:0]});
assign extended_imm = ({{16{INST[15]}},INST[15:0]});

ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),.imm_in(extended_imm),.aluop_in(aluop), .alusrc_in(alusrc), .waddr_in(waddr_in_rf), .waddr_out(waddr_out_ID_EXE),.imm_out(imm_out_ID_EXE), .rdata1_out(rdata1_out_ID_EXE), .rdata2_out(rdata2_out_ID_EXE),.alusrc_out(alusrc_out_ID_EXE), .aluop_out(aluop_out_ID_EXE), .PCIN_in(PCIN), .wen_in(wen), .branch_in(branch), .memwrite_in(memwrite) ,.memread_in(memread), .memtoreg_in(memtoreg), .PCIN_out(PCIN_out_ID_EXE), .wen_out(wen_out_ID_EXE), .branch_out(branch_out_ID_EXE), .memwrite_out(memwrite_out_ID_EXE), .memread_out(memread_out_ID_EXE), .memtoreg_out(memtoreg_out_ID_EXE));//immediate value is only zero extended. As we are concentrationg only on R type instuctions, this is not an issue.

EXE_MEM_stage PIPE2(.clk(clk), .rst(rst), .result_in(aluout), .rdata2_in(rdata2_out_ID_EXE), .waddr_in(waddr_out_ID_EXE),.wen_in(wen_out_ID_EXE),.memwrite_in(memwrite_out_ID_EXE), .memread_in(memread_out_ID_EXE), .memtoreg_in(memtoreg_out_ID_EXE), .result_out(result_out_EXE_MEM), .rdata2_out(rdata2_out_EXE_MEM), .waddr_out(waddr_out_EXE_MEM), .wen_out(wen_out_EXE_MEM), .memwrite_out(memwrite_out_EXE_MEM), .memread_out(memread_out_EXE_MEM), .memtoreg_out(memtoreg_out_EXE_MEM));

MEM_WB_stage PIPE3(.clk(clk), .rst(rst), .result_in(result_out_EXE_MEM), .waddr_in(waddr_out_EXE_MEM), .wen_in(wen_out_EXE_MEM), .memtoreg_in(memtoreg_out_EXE_MEM), .result_out(result_out_MEM_WB), .waddr_out(waddr_out_MEM_WB), .wen_out(wen_out_MEM_WB), .memtoreg_out(memtoreg_out_MEM_WB));


wire [`DSIZE-1:0]rdata2_mux=alusrc_out_ID_EXE ? imm_out_ID_EXE : rdata2_out_ID_EXE;// mux for selecting immediate or the rdata2 value

wire zero;
alu ALU0 ( .a(rdata1_out_ID_EXE), .b(rdata2_mux), .op(aluop_out_ID_EXE), .out(aluout), .zero(zero));//ALU takes its input from pipeline register and the output of mux.
wire PCSrc = zero & branch_out_ID_EXE;

wire [`ISIZE-1:0] res = imm_out_ID_EXE + PCIN_out_ID_EXE ;
assign PC_mux = PCSrc ? res : PCIN;// mux for selecting res or PCIN


wire [`DSIZE-1:0]dm_out;
DM DM0 (.clk(clk), .rst(rst), .memwrite(memwrite_out_EXE_MEM), .memread(memread_out_EXE_MEM), .addr(result_out_EXE_MEM), .data_in(rdata2_out_EXE_MEM), .fileid(4'b0000), .data_out(dm_out));


 
endmodule


