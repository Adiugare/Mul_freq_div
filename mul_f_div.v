`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2026 12:08:27
// Design Name: 
// Module Name: mul_f_div
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


module mul_f_div(
    input clk,rst,en,
    input [1:0] mode,
    output reg f_2,
    output reg f_4,
    output reg f_8,
    output reg f_16
    );
    
    reg [3:0] counter;
    
    always@(posedge clk)begin
            if(rst)
                counter <= 0;
            else if(en)
                counter <= counter + 1'b1;
            else
                counter <= counter;
    end
    
    always@(posedge clk)begin
        case(mode)
            2'b00 : begin
                f_2 <= counter[0];
            end
            
            2'b01 : begin
                f_4 <= counter[1];
            end
              
            2'b10 : begin
                f_8 <= counter[2];
            end
            
            2'b11 : begin
                f_16 <=counter[3];
            end
            
            default : begin
                    f_2 <= 0;
                    f_4 <= 0;
                    f_8 <= 0;
                    f_16 <= 0;
            end
            
       endcase
  end
            
endmodule       
