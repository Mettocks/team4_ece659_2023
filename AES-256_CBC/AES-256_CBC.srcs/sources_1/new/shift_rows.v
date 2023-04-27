`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 04:42:18 PM
// Design Name: 
// Module Name: shift_rows
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


module shift_rows(
    input [127:0] in_state,
    output reg [127:0] shifted_state
    );
    
    wire [7:0] s00, s01, s02, s03,
               s10, s11, s12, s13,
               s20, s21, s22, s23,
               s30, s31, s32, s33;           
    
    // First row, no change
    assign s00 = in_state[127:120]; // byte 0 MSB
    assign s01 = in_state[95:88]; // byte 4
    assign s02 = in_state[63:56]; // byte 8
    assign s03 = in_state[31:24]; // byte 12

    // second row, circular shift over one byte
    assign s10 = in_state[119:112]; // byte 1
    assign s11 = in_state[87:80]; // byte 5 
    assign s12 = in_state[55:48]; // byte 9 
    assign s13 = in_state[23:16]; // byte 13  

    // third row, circular shift two bytes
    assign s20 = in_state[111:104]; // byte 2 
    assign s21 = in_state[79:72]; // byte 6 
    assign s22 = in_state[47:40]; // byte 10 
    assign s23 = in_state[15:8]; // byte 14 

    // fourth row, circular shift three bytes
    assign s30 = in_state[103:96]; // byte 3 
    assign s31 = in_state[71:64]; // byte 7 
    assign s32 = in_state[39:32]; // byte 11 
    assign s33 = in_state[7:0]; // byte 15 LSB
    
    
    always @(*) begin

        // If you are comparing this to the FIP 197 document in Figure 8,
        // due to the indexing, imagine the figure 8 array is transposed
        //  from bottom left to top right corner
        shifted_state = {s00, s11, s22, s33,
                         s01, s12, s23, s30,
                         s02, s13, s20, s31,
                         s03, s10, s21, s32};
                         
    
    end
    
endmodule

/*
module shift_rows(
    input [127:0] in_state,
    output reg [127:0] shifted_state
    );

    // sXY, is an elemeent in the byte array of the in_state, as a 4x4. x is row, y is column
    // For isntance, s00 is Byte 0 (LSB), s01 is Byte 4, s10 is Byte 2, etc
    // Following nations as set forth in NIST AES document FIPS 197
    wire [7:0] s00, s01, s02, s03,
               s10, s11, s12, s13,
               s20, s21, s22, s23,
               s30, s31, s32, s33;

    wire [127:0] shifted_out;

    //formula: [8*i + 7 : 8*i] where i is the byte index given that the 128-bit block is divided in the 4x4 array
    // First row, no change
    assign s00 = in_state[7:0]; // byte 0 LSB
    assign s01 = in_state[39:32]; // byte 4
    assign s02 = in_state[71:64]; // byte 8
    assign s03 = in_state[103:96]; // byte 12

    // second row, circular shift over one byte
    assign s10 = in_state[15:8]; // byte 1
    assign s11 = in_state[47:40]; // byte 5 
    assign s12 = in_state[79:72]; // byte 9 
    assign s13 = in_state[112:104]; // byte 13  

    // third row, circular shift two bytes
    assign s20 = in_state[23:16]; // byte 2 
    assign s21 = in_state[55:48]; // byte 6 
    assign s22 = in_state[87:80]; // byte 10 
    assign s23 = in_state[119:112]; // byte 14 

    // fourth row, circular shift three bytes
    assign s30 = in_state[31:24]; // byte 3 
    assign s31 = in_state[63:56]; // byte 7 
    assign s32 = in_state[95:88]; // byte 11 
    assign s33 = in_state[127:120]; // byte 15 MSB

    // Reassigning the shift rows to their appropriate shift
    // However, since we are writting as big endian, the entire array is transposed so rows become columns and columns become rows
    //(e.g. s00, the LSB, in most documentation is shown in the top left of the array, but here it will be put in the bottom right for ordering)

   assign shifted_out = {s30, s21, s12, s03,
                         s33, s20, s11, s02, 
                         s32, s23, s10, s01, 
                         s31, s22, s13, s00};
                         

    always @(*) begin
        shifted_state = {s30, s21, s12, s03,
                         s33, s20, s11, s02,
                         s32, s23, s10, s01,
                         s31, s22, s13, s00};
    end

endmodule
*/
