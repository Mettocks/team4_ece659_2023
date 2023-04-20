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


module mix_columns(
    input [127:0] in_state, 
    output wire [127:0] out_state
    );



    gf_mat_mul 
                col1(.column(in_state[127:96]), .out(out_state[127:96])), 
                col2(.column(in_state[95:64]), .out(out_state[95:64])), 
                col3(.column(in_state[63:32]), .out(out_state[63:32])), 
                col4(.column(in_state[31:0]), .out(out_state[31:0]));




//  wire [7:0] m1c1, m1c2, m2c1, m2c2, m3c1, m3c2, m4c1, m4c2;
//     gf_mult 
//         a11(column[127:120], 8'h02, m1c1),
//         a21(column[119:112], 8'h03, m1c2);
//     assign out[127:120] = m1c1 ^ m1c2 ^ column[111:104] ^ column[103:96] ;
 
//     gf_mult 
//         a12(column[119:112], 8'h02, m2c1),
//         a22(column[111:104], 8'h03, m2c2);
//     assign out[119:112] = column[127:120]^ m2c2 ^ m2c1 ^ column[103:96] ;

//     gf_mult 
//         a13(column[111:104], 8'h02, m3c1),
//         a23(column[103:96], 8'h03, m3c2);

//     assign out[111:104] = column[127:120] ^ column[119:112]^ m3c1 ^ m3c2;

//     gf_mult 
//         a14(column[127:120], 8'h03, m4c1),
//         a24(column[103:96], 8'h02, m4c2);
//     assign out[103:96] = m4c1 ^ column[119:112] ^ column[111:104] ^ m4c2;  
 
    
//  //column 2

//     wire [7:0] k1c1, k1c2, k2c1, k2c2, k3c1, k3c2, k4c1, k4c2;
//     gf_mult 
//         b11(column[95:88], 8'h02, k1c1),
//         b21(column[87:80], 8'h03, k1c2);
//     assign out[95:88] = k1c1 ^ k1c2 ^ column[79:72] ^ column[71:64] ;
 
//     gf_mult 
//         b12(column[87:80], 8'h02, k2c1),
//         b22(column[79:72], 8'h03, k2c2);
//     assign out[87:80] = column[95:88]^ k2c2 ^ k2c1 ^ column[71:64] ;

//     gf_mult 
//         b13(column[79:72], 8'h02, k3c1),
//         b23(column[71:64], 8'h03, k3c2);

//     assign out[79:72] = column[95:88] ^ column[87:80]^ k3c1 ^ k3c2;

//     gf_mult 
//         b14(column[95:88], 8'h03, k4c1),
//         b24(column[71:64], 8'h02, k4c2);
//     assign out[71:64] = k4c1 ^ column[87:80] ^ column[79:72] ^ k4c2;   
    
// //column 3
//     wire [7:0] j1c1, j1c2, j2c1, j2c2, j3c1, j3c2, j4c1, j4c2;
//     gf_mult 
//         c11(column[63:56], 8'h02, j1c1),
//         c21(column[55:48], 8'h03, j1c2);
//     assign out[63:56] = j1c1 ^ j1c2 ^ column[47:40] ^ column[39:32] ;
 
//     gf_mult 
//         c12(column[55:48], 8'h02, j2c1),
//         c22(column[47:40], 8'h03, j2c2);
//     assign out[55:48] = column[63:56]^ j2c2 ^ j2c1 ^ column[39:32] ;

//     gf_mult 
//         c13(column[47:40], 8'h02, j3c1),
//         c23(column[39:32], 8'h03, j3c2);

//     assign out[47:40] = column[63:56] ^ column[55:48]^ j3c1 ^ j3c2;

//     gf_mult 
//         c14(column[63:56], 8'h03, j4c1),
//         c24(column[39:32], 8'h02, j4c2);
//     assign out[39:32] = j4c1 ^ column[55:48] ^ column[47:40] ^ j4c2;

// //column 4
//     wire [7:0] i1c1, i1c2, i2c1, i2c2, i3c1, i3c2, i4c1, i4c2;
//     gf_mult 
//         d11(column[31:24], 8'h02, i1c1),
//         d21(column[23:16], 8'h03, i1c2);
//     assign out[31:24] = i1c1 ^ i1c2 ^ column[15:8] ^ column[7:0] ;
 
//     gf_mult 
//         d12(column[23:16], 8'h02, i2c1),
//         d22(column[15:8], 8'h03, i2c2);
//     assign out[23:16] = column[31:24]^ i2c2 ^ i2c1 ^ column[7:0] ;

//     gf_mult 
//         d13(column[15:8], 8'h02, i3c1),
//         d23(column[7:0], 8'h03, i3c2);

//     assign out[15:8] = column[31:24] ^ column[23:16]^ i3c1 ^ i3c2;

//     gf_mult 
//         d14(column[31:24], 8'h03, i4c1),
//         d24(column[7:0], 8'h02, i4c2);
//     assign out[7:0] = i4c1 ^ column[23:16] ^ column[15:8] ^ i4c2;

endmodule



module gf_mat_mul(
    input [31:0] column,
    output [31:0] out
    );

    wire [7:0] i1c1, i1c2, i2c1, i2c2, i3c1, i3c2, i4c1, i4c2;
    gf_mult_02 c11(column[31:24], i1c1);
    gf_mult_03 c21(column[23:16], i1c2);
    assign out[31:24] = i1c1 ^ i1c2 ^ column[15:8] ^ column[7:0] ;
    
 //wire [7:0] i2c1, i2c2;
    gf_mult_02 c12(column[23:16], i2c1);
    gf_mult_03 c22(column[15:8], i2c2);
    assign out[23:16] = column[31:24]^ i2c2 ^ i2c1 ^ column[7:0] ;

 //wire [7:0] i3c1, i3c2;
    gf_mult_02 c13(column[15:8], i3c1);
    gf_mult_03 c23(column[7:0], i3c2);

    assign out[15:8] = column[31:24] ^ column[23:16]^ i3c1 ^ i3c2;
    
// wire [7:0] i4c1, i4c2;
    gf_mult_03 c14(column[31:24], i4c1);
    gf_mult_02 c24(column[7:0], i4c2);
    assign out[7:0] = i4c1 ^ column[23:16] ^ column[15:8] ^ i4c2;

endmodule


module gf_mult_02(    
    input [7:0] b, // the byte from the input array/column
    output reg [7:0] out
    );
    
    always @(*) begin
        out <= double(b); // 2b   
    end

    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction
endmodule

module gf_mult_03(
    input [7:0] b, // the byte from the input array/column
    output reg [7:0] out
    );
    
    always @(*) begin
        out <= double(b) ^ b; // 3b = 2b + b 
    end

    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule

/*
module gf_mult(
    input [7:0] b, // the byte from the input array/column
    input [7:0] c, // constant
    output reg [7:0] out
    );
    
    always @(*) begin
        case (c)
            8'h02: out <= double(b); // 2b
            8'h03: out <= double(b) ^ b; // 3b = 2b + b
        endcase
    end

    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule
*/