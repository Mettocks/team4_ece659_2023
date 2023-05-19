`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2023 03:05:08 PM
// Design Name: 
// Module Name: top
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


module top(clk_t, state_t, key_t);
    input clk_t; 
    input [127:0] state_t;
    input [255:0] key_t;
    wire [127:0] out_t;
    
    aes_256 DUT(
        .clk(clk_t), 
        .state(state_t),
        .key(key_t),
        .out(out_t)
    );

endmodule
