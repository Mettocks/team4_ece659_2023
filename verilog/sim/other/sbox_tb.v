`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2023 12:59:36 PM
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

    reg [127:0] in;
    
    wire [127:0] out;
    

    Full_Array_Sbox DUT(
        .in_state(in),
        .out_state(out)
        );

    
    initial begin
        in = 128'h4f63760643e0aa85efa7213201a4e705;
        //expect 84fb386f1ae1ac97df5cfd237c49946b;
        #1
        $stop;
    end
    

endmodule



