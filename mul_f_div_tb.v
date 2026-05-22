`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2026 12:08:59
// Design Name: 
// Module Name: mul_f_div_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mul_f_div_tb();
    

reg clk;
reg rst,en;
reg [1:0]mode;
wire f_2;
wire f_4;
wire f_8;
wire f_16;




//
// DUT
//
mul_f_div dut (
    .clk(clk),
    .rst(rst),
    .en(en),
    .mode(mode),
    .f_2(f_2),
    .f_4(f_4),
    .f_8(f_8),
    .f_16(f_16)
);
   
initial begin
    {clk,rst,en,mode} = 0;
end

 always #5 clk = ~clk;

//
// Stimulus
//
initial begin

    rst = 1;

    #20;
    rst = 0;
    en =1;
    mode =2'b00;
    #100;
    mode =2'b01;
    #100;
    mode =2'b10;
    #100;
    mode =2'b11;
    
    #2050;
    en =0;
    
end


initial begin
    $monitor("TIME=%0t rst=%b clk=%b en=%0d mode=%b f_2=%b  f_4=%b  f_8=%b  f_16=%b",
              $time, rst, clk, en, mode, f_2, f_4, f_8, f_16);
end

endmodule
