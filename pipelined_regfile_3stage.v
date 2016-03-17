`timescale 1ns / 1ps
`include "define.v"

//module pipelined_regfile_3stage(clk, rst, fileid, PCOUT, INST, rdata1, rdata2, rdata1_ID_EXE, rdata2_ID_EXE, imm_ID_EXE,rdata2_imm_ID_EXE, aluop_ID_EXE, alusrc_ID_EXE, waddr_out_ID_EXE,aluout,waddr_out_EXE_WB,aluout_EXE_WB);

module pipelined_regfile_3stage(clk, rst, fileid, PCOUT, INST, rdata1, rdata2, aluout);

input clk;				
											
input	rst;
input fileid; 
 
output [`ISIZE-1:0]PCOUT;
output [`DSIZE-1:0] rdata1;
//output [`DSIZE-1:0] rdata1_ID_EXE;
output [`DSIZE-1:0] rdata2;
//output [`DSIZE-1:0] rdata2_ID_EXE;
//output [`DSIZE-1:0] imm_ID_EXE;
//output [`DSIZE-1:0] rdata2_imm_ID_EXE;
output [`DSIZE-1:0]INST;
//output alusrc_ID_EXE;
//output [2:0]aluop_ID_EXE;
//output [`ASIZE-1:0] waddr_out_ID_EXE;	
output [`DSIZE-1:0] aluout;
//output [`ASIZE-1:0] waddr_out_EXE_WB;
//output [`DSIZE-1:0] aluout_EXE_WB;				
								
 	 
//Program counter
wire [`ISIZE-1:0]PCIN;


PC1 pc(.clk(clk),.rst(rst),.nextPC(PCIN),.currPC(PCOUT));//PCOUT is your PC value and PCIN is your next PC


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

control C0 (.inst_cntrl(INST[31:26]),.wen_cntrl(wen),.alusrc_cntrl(alusrc), .aluop_cntrl(aluop), .regdst_cntrl(regdst), .memread_cntrl(memread), .memwrite_cntrl(memwrite), .memtoreg_cntrl(memtoreg));//added

wire [4:0]waddr_in_rf=regdst ? INST[15:11] : INST[20:16];// mux for selecting waddr
wire [`DSIZE-1:0]dm_out_mux=memtoreg ? aluout : dm_out;// mux for selecting alu output and output from data memory

regfile  RF0 ( .clk(clk), .rst(rst), .wen(wen), .raddr1(INST[25:21]), .raddr2(INST[20:16]), .waddr(waddr_in_rf), .wdata(dm_out_mux), .rdata1(rdata1), .rdata2(rdata2));//note that waddr needs to come from pipeline register 


//sign extension for immediate needs to be done for I type instuction.
//you can add that here
wire [`DSIZE-1:0]extended_imm;
//assign extended_imm=({16'b0,INST[15:0]});
assign extended_imm = ({{16{INST[15]}},INST[15:0]});

//ID_EXE_stage PIPE1(.clk(clk), .rst(rst), .rdata1_in(rdata1),.rdata2_in(rdata2),.imm_in(extended_imm),.opcode_in(aluop), .alusrc_in(alusrc), .waddr_in(INST[15:11]), .waddr_out(waddr_out_ID_EXE),.imm_out(imm_ID_EXE), .rdata1_out(rdata1_ID_EXE), .rdata2_out(rdata2_ID_EXE),.alusrc_out(alusrc_ID_EXE), .opcode_out(aluop_ID_EXE));//immediate value is only zero extended. As we are concentrationg only on R type instuctions, this is not an issue.
//EXE_WB_stage PIPE2(.clk(clk), .rst(rst), .alu_in(aluout),.waddr_in(waddr_out_ID_EXE),.alu_out(aluout_EXE_WB),.waddr_out(waddr_out_EXE_WB));
wire [`DSIZE-1:0]rdata2_mux=alusrc ? extended_imm : rdata2;// mux for selecting immedaite or the rdata2 value

alu ALU0 ( .a(rdata1), .b(rdata2_mux), .op(aluop), .out(aluout));//ALU takes its input from pipeline register and the output of mux.

wire [`DSIZE-1:0]dm_out;
DM DM0 (.clk(clk), .rst(rst), .memwrite(memwrite), .memread(memread), .addr(aluout), .data_in(rdata2), .fileid(4'b1000), .data_out(dm_out));


 
endmodule


