`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2023 12:34:56 PM
// Design Name: 
// Module Name: Testbench
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


module Testbench();


reg [255:0] Key = 256'h4ffd41903a0189d27d8016b370c253f11877d7580fea37b2eb17ac5101bed306; 
reg clk, reset;
wire [127:0] Expansion [13:0];
wire [31:0] round_val;
wire [4:0] KeyCount;
wire [1:0] KeyState;
wire [2:0] XORCount, rconCount;
wire wordSelect;

initial begin
    clk=0;
    forever
        #10 clk = !clk;
end

initial begin
    reset = 1'b1;    
    #20
    reset = 1'b0;
end


Key_Expansion Test_Key(reset, clk, Key, Expansion[0], Expansion[1], Expansion[2], Expansion[3], Expansion[4], 
              Expansion[5], Expansion[6], Expansion[7], Expansion[8], Expansion[9], 
              Expansion[10], Expansion[11],Expansion[12], Expansion[13], round_val, KeyCount, KeyState, XORCount, rconCount, wordSelect);

endmodule