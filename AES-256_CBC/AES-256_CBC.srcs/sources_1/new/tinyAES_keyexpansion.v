`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2023 01:37:57 PM
// Design Name: 
// Module Name: tinyAES_keyexpansion
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

/** This wrapper is created to get functional testing going, and is not representitive of the final key expansion **/
module tinyAES_keyexpansion(
    input clk,
    input [255:0] key,
    output reg [127:0] Expanded_Key_One,        reg [127:0] Expanded_Key_Two, 
    output reg [127:0] Expanded_Key_Three,      reg [127:0] Expanded_Key_Four, 
    output reg [127:0] Expanded_Key_Five,       reg [127:0] Expanded_Key_Six,
    output reg [127:0] Expanded_Key_Seven,      reg [127:0] Expanded_Key_Eight,
    output reg [127:0] Expanded_Key_Nine,       reg [127:0] Expanded_Key_Ten,
    output reg [127:0] Expanded_Key_Eleven,     reg [127:0] Expanded_Key_Twelve,
    output reg [127:0] Expanded_Key_Thirteen,   reg [127:0] Expanded_Key_Fourteen
    );

    reg    [255:0] k0, k0a, k1;
    wire   [255:0] k2, k3, k4, k5, k6, k7, k8,
                   k9, k10, k11, k12, k13;
    wire   [127:0] k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8b,
                   k9b, k10b, k11b, k12b, k13b;

    wire [255:0] nothing_wire;

    always @ (posedge clk) begin
        k0  <= key;
        k0a <= k0;
        k1  <= k0a;
    end
    

    assign k0b = k0a[127:0];

    expand_key_type_A_256
        a1  (clk, k1,  8'h1,  k2,  k1b),
        a3  (clk, k3,  8'h2,  k4,  k3b),
        a5  (clk, k5,  8'h4,  k6,  k5b),
        a7  (clk, k7,  8'h8,  k8,  k7b),
        a9  (clk, k9,  8'h10, k10, k9b),
        a11 (clk, k11, 8'h20, k12, k11b),
        a13 (clk, k13, 8'h40, nothing_wire, k13b);

    expand_key_type_B_256
        a2  (clk, k2,  k3,  k2b),
        a4  (clk, k4,  k5,  k4b),
        a6  (clk, k6,  k7,  k6b),
        a8  (clk, k8,  k9,  k8b),
        a10 (clk, k10, k11, k10b),
        a12 (clk, k12, k13, k12b);

    wire [127:0] Expanded_Key_One_wire, Expanded_Key_Two_wire, Expanded_Key_Three_wire,
    Expanded_Key_Four_wire, Expanded_Key_Five_wire, Expanded_Key_Six_wire,
    Expanded_Key_Seven_wire, Expanded_Key_Eight_wire, Expanded_Key_Nine_wire, Expanded_Key_Ten_wire,
    Expanded_Key_Eleven_wire, Expanded_Key_Twelve_wire, Expanded_Key_Thirteen_wire, Expanded_Key_Fourteen_wire;

    assign Expanded_Key_One_wire         = k0b;
    assign Expanded_Key_Two_wire         = k1b;
    assign Expanded_Key_Three_wire       = k2b;
    assign Expanded_Key_Four_wire        = k3b;
    assign Expanded_Key_Five_wire        = k4b;
    assign Expanded_Key_Six_wire         = k5b;
    assign Expanded_Key_Seven_wire       = k6b;
    assign Expanded_Key_Eight_wire       = k7b;
    assign Expanded_Key_Nine_wire        = k8b;
    assign Expanded_Key_Ten_wire         = k9b;
    assign Expanded_Key_Eleven_wire      = k10b;
    assign Expanded_Key_Twelve_wire      = k11b;
    assign Expanded_Key_Thirteen_wire    = k12b;
    assign Expanded_Key_Fourteen_wire    = k13b;
    
    always @(*) begin
        Expanded_Key_One         <=    Expanded_Key_One_wire;
        Expanded_Key_Two         <=    Expanded_Key_Two_wire;
        Expanded_Key_Three       <=    Expanded_Key_Three_wire;
        Expanded_Key_Four        <=    Expanded_Key_Four_wire; 
        Expanded_Key_Five        <=    Expanded_Key_Five_wire; 
        Expanded_Key_Six         <=    Expanded_Key_Six_wire;
        Expanded_Key_Seven       <=    Expanded_Key_Seven_wire; 
        Expanded_Key_Eight       <=    Expanded_Key_Eight_wire; 
        Expanded_Key_Nine        <=    Expanded_Key_Nine_wire; 
        Expanded_Key_Ten         <=    Expanded_Key_Ten_wire;
        Expanded_Key_Eleven      <=    Expanded_Key_Eleven_wire;
        Expanded_Key_Twelve      <=    Expanded_Key_Twelve_wire;
        Expanded_Key_Thirteen    <=    Expanded_Key_Thirteen_wire;
        Expanded_Key_Fourteen    <=    Expanded_Key_Fourteen_wire;
    
    end

endmodule

/* expand k0,k1,k2,k3 for every two clock cycles */
module expand_key_type_A_256 (clk, in, rcon, out_1, out_2);
    input              clk;
    input      [255:0] in;
    input      [7:0]   rcon;
    output reg [255:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3, k4, k5, k6, k7,
                       v0, v1, v2, v3;
    reg        [31:0]  k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8a;

    assign {k0, k1, k2, k3, k4, k5, k6, k7} = in;
    
    assign v0 = {k0[31:24] ^ rcon, k0[23:0]};
    assign v1 = v0 ^ k1;
    assign v2 = v1 ^ k2;
    assign v3 = v2 ^ k3;

    always @ (posedge clk)
        {k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a} <= {v0, v1, v2, v3, k4, k5, k6, k7};

    S_Box_32w
        S4_0 ({k7[23:0], k7[31:24]}, k8a);

    assign k0b = k0a ^ k8a;
    assign k1b = k1a ^ k8a;
    assign k2b = k2a ^ k8a;
    assign k3b = k3a ^ k8a;
    assign {k4b, k5b, k6b, k7b} = {k4a, k5a, k6a, k7a};

    always @ (posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b};

    assign out_2 = {k0b, k1b, k2b, k3b};
endmodule

/* expand k4,k5,k6,k7 for every two clock cycles */
module expand_key_type_B_256 (clk, in, out_1, out_2);
    input              clk;
    input      [255:0] in;
    output reg [255:0] out_1;
    output     [127:0] out_2;
    wire       [31:0]  k0, k1, k2, k3, k4, k5, k6, k7,
                       v5, v6, v7;
    reg        [31:0]  k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a;
    wire       [31:0]  k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b, k8a;

    assign {k0, k1, k2, k3, k4, k5, k6, k7} = in;
    
    assign v5 = k4 ^ k5;
    assign v6 = v5 ^ k6;
    assign v7 = v6 ^ k7;

    always @ (posedge clk)
        {k0a, k1a, k2a, k3a, k4a, k5a, k6a, k7a} <= {k0, k1, k2, k3, k4, v5, v6, v7};

    S_Box_32w
        S4_0 (k3, k8a);

    assign {k0b, k1b, k2b, k3b} = {k0a, k1a, k2a, k3a};
    assign k4b = k4a ^ k8a;
    assign k5b = k5a ^ k8a;
    assign k6b = k6a ^ k8a;
    assign k7b = k7a ^ k8a;

    always @ (posedge clk)
        out_1 <= {k0b, k1b, k2b, k3b, k4b, k5b, k6b, k7b};

    assign out_2 = {k4b, k5b, k6b, k7b};
endmodule


