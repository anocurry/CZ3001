// defines
`define ADD 4'b0000
`define SUB 4'b0001
`define AND 4'b0010
`define XOR  4'b0011
`define COM 4'b0100
`define MUL  4'b0101
`define ADDI 4'b0110
`define LW 4'b0111
`define SW 4'b1000
`define BEQ 4'b1001

//for fileIO
`timescale 1ns / 10ps
`define EOF 32'hFFFF_FFFF
`define NULL 0
`define MAX_LINE_LENGTH 1000
`define DSIZE 32 // Bitwidth of each register 
`define NREG 32 //Number of registers 
`define ISIZE 32 //instuction size
`define ASIZE 5//Address size

