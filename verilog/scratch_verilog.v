




module top();

    wire [7:0] i1, i2, i3
    gf_mult mult1(in[127:120], 8'h02, i1), mult2(), mult3();


    assign 

endmodule

module mix_mat_mul(
    input [31:0] column,
    output [31:0] out
    );

    assign out[31:24] =
    assign out[23:16] = 

    wire [7:0] i3c1, i3c2;
    gf_mult 
        3c1(column[15:8], 8'h02, i3c1),
        3c2(column[7:0], 8'h03, i3c2);

    assign out[15:8] = ;
    
    wire [7:0] i4c1, i4c2;
    gf_mult 
        4c1(column[31:24], 8'h03, i4c1),
        4c2(column[7:0], 8'h02, i4c2);
    assign out[7:0] = i4c1 ^ column[23:16] ^ column[15:8] ^ i4c2;

endmodule

module gf_mult(
    input [7:0] b,
    input [7:0] x,
    output reg [7:0] out
    );

    always @(*) begin
        out = b * x;
        if(b[7] == 1) begin
            out = out ^ 8'h1b;
        end
    end


endmodule