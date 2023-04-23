`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 04:46:53 PM
// Design Name: 
// Module Name: mix_columns
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

// entire matrix multiply
module Inv_mix_columns(
    input [127:0] in_state, 
    output wire [127:0] out_state
    );



    inv_gf_mat_mul 
                col1(.column(in_state[127:96]), .out(out_state[127:96])), 
                col2(.column(in_state[95:64]), .out(out_state[95:64])), 
                col3(.column(in_state[63:32]), .out(out_state[63:32])), 
                col4(.column(in_state[31:0]), .out(out_state[31:0]));


endmodule


// Single column multiply with inverse matrix
module inv_gf_mat_mul(
    input [31:0] column,
    output [31:0] out
    );

    // wire is named as column x, index y, etc
    // column 0
    wire [7:0] c0i0, c0i1, c0i2, c0i3;
     
    inv_gf_mult_14   m00(column[31:24], c0i0);
    inv_gf_mult_11   m01(column[23:16], c0i1);
    inv_gf_mult_13   m02(column[15:8] , c0i2);
    inv_gf_mult_09   m03(column[7:0]  , c0i3);

    assign out[31:24] = c0i0 ^ c0i1 ^ c0i2 ^ c0i3;
    
    //column 1
    wire [7:0] c1i0, c1i1, c1i2, c1i3;
    inv_gf_mult_09   m10(column[31:24], c1i0);
    inv_gf_mult_14   m11(column[23:16], c1i1);
    inv_gf_mult_11   m12(column[15:8] , c1i2);
    inv_gf_mult_13   m13(column[7:0]  , c1i3);

    assign out[23:16] = c1i0 ^ c1i1 ^ c1i2 ^ c1i3;


    //column 2
    wire [7:0] c2i0, c2i1, c2i2, c2i3;
    inv_gf_mult_13   m20(column[31:24], c2i0);
    inv_gf_mult_09   m21(column[23:16], c2i1);
    inv_gf_mult_14   m22(column[15:8] , c2i2);
    inv_gf_mult_11   m23(column[7:0]  , c2i3);

    assign out[15:8] = c2i0 ^ c2i1 ^ c2i2 ^ c2i3;


    //column 3
    wire [7:0] c3i0, c3i1, c3i2, c3i3;
    inv_gf_mult_11   m30(column[31:24], c3i0);
    inv_gf_mult_13   m31(column[23:16], c3i1);
    inv_gf_mult_09   m32(column[15:8] , c3i2);
    inv_gf_mult_14   m33(column[7:0]  , c3i3);

    assign out[7:0] = c3i0 ^ c3i1 ^ c3i2 ^ c3i3;


endmodule


// ****** Multipliers ******
//Inverse Matrix uses 9 (09), 11 (0B),  13 (0D), and 14 (0E)
module inv_gf_mult_09(
        input [7:0] b,
        output reg [7:0] out
        );

    always @(*) begin // 9b = 8b + b = 2(2(2b)) + b
        out <= double(double(double(b))) ^ b;
    end


    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule


module inv_gf_mult_11(
        input [7:0] b,
        output reg [7:0] out
        );

    always @(*) begin // 11b = 8b + 2b + b = 2(2(2b)) + 2b + b
        out <= double(double(double(b))) ^ double(b) ^ b;
    end


    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule

module inv_gf_mult_13(
        input [7:0] b,
        output reg [7:0] out
        );

    always @(*) begin // 13b = 8b + 4b + b = 2(2(2b)) + 2(2b) + b
        out <= double(double(double(b))) ^ double(double(b)) ^ b;
    end


    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule

module inv_gf_mult_14(
        input [7:0] b,
        output reg [7:0] out
        );

    always @(*) begin // 14b = 8b + 4b + 2b = 2(2(2b)) + 2(2b) + 2b
        out <= double(double(double(b))) ^ double(double(b)) ^ double(b);
    end


    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule

