`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2023 05:01:18 PM
// Design Name: 
// Module Name: mix_columns_tb
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


module mix_columns_tb();
    
    reg [127:0]in;
    wire [127:0]out;
    initial begin
        in=128'h6353e08c0960e104cd70b751bacad0e7;
        #100;
        // expect 5f72641557f5bc92f7be3b291db9f91a
    $stop;
    end
    mix_columns a1(.in_state(in), .out_state(out));

    
    
    
    /*
    reg [7:0] in_t;
    reg [7:0] const_t;
    wire [7:0] out_t;
    

    gf_mult DUT(in_t, const_t, out_t);
    
    initial begin
        in_t = 8'hdb;
        const_t = 8'h02;
        #2;
        $stop;
        in_t = 8'hdb;
        const_t = 8'h03;
        $stop;
    end
    */

    /*
    reg [31:0] in_t;
    wire [31:0] out_t;
    
    gf_mat_mul DUT(.column(in_t), .out(out_t));
    
    initial begin
        in_t = 32'h6353e08c;
        // expect 5f726415
        #2 $stop;
    end
    
    */

endmodule
