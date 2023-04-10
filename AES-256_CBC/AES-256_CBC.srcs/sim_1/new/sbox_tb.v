`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 03:57:04 PM
// Design Name: 
// Module Name: sbox_tb
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


module sbox_tb();
    reg [7:0] x;
    wire [7:0] y;
    reg [7:0] j; // For loop var

    S_Box DUT(.Byte_In(x), .Byte_Out(y));
    
    initial begin
        x = 8'h00;
        for (j = 0; j <= 8'hff; j = j + 1) begin
            {x} = j;
            #10;
            $display("In: %2h Out: %2h", x, y);
        end
        $stop;
    end
endmodule
