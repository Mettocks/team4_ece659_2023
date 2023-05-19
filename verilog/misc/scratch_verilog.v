`timescale 1ns/1ps


module mix_mat_mul(
    input [31:0] column,
    output [31:0] out
    );

    wire [7:0] i1c1, i1c2, i2c1, i2c2, i3c1, i3c2, i4c1, i4c2;
    gf_mult 
        c11(column[31:24], 8'h02, i1c1),
        c21(column[23:16], 8'h03, i1c2);
    assign out[31:24] = i1c1 ^ i1c2 ^ column[15:8] ^ column[7:0] ;
    
 //wire [7:0] i2c1, i2c2;
    gf_mult 
        c12(column[23:16], 8'h02, i2c1),
        c22(column[15:8], 8'h03, i2c2);
    assign out[23:16] = column[31:24]^ i2c2 ^ i2c1 ^ column[7:0] ;

 //wire [7:0] i3c1, i3c2;
    gf_mult 
        c13(column[15:8], 8'h02, i3c1),
        c23(column[7:0], 8'h03, i3c2);

    assign out[15:8] = column[31:24] ^ column[23:16]^ i3c1 ^ i3c2;
    
// wire [7:0] i4c1, i4c2;
    gf_mult 
        c14(column[31:24], 8'h03, i4c1),
        c24(column[7:0], 8'h02, i4c2);
    assign out[7:0] = i4c1 ^ column[23:16] ^ column[15:8] ^ i4c2;

endmodule

module gf_mult(
    input [7:0] b, // the byte from the input array/column
    input [7:0] c, // constant
    output reg [7:0] out
    );
    
    always @(*) begin
        case (c)
            8'h02: out = double(b); // 2b
            8'h03: out = double(b) ^ b; // 3b = 2b + b
        endcase
    end

    function integer double (input [7:0] x);
        double = (x << 1) ^ (8'h1b & -(x >> 7));
    endfunction

endmodule
