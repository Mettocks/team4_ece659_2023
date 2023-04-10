`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2023 05:08:01 PM
// Design Name: 
// Module Name: rounds
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

// Single round on the input text
// State refers to the current encrypted 128 bit input. Prior to the first round
// this is equivelent to the plaintext put together
// It follows this loop:
// for every round except the last one:
//      SubBytes(state) // S_Box
//      ShiftRows(state) // Shift_Row
//      MixColumns(state) // Mix_Cols
//      AddRoundKey(state)
// end loop
// This loop structure does require sequentiality, since each round relies on the last
//
// This
module cipher_round(
    input [127:0] in_state,
    input [127:0] round_key,
    output reg [127:0] out_state
    );
    
    reg [127:0] state; // memory for internal operations on state
    
    
    /***** SubBytes init  *****/
    integer i; // for loop var
    reg [31:0] Sub_Input;
    wire [31:0] Sub_Output;
    // Intialization of modules
    S_Box_32w SubBytes(
        .Word_In(Sub_Input),
        .Word_Out(Sub_Output)
    );
    
    /***** ShiftRows init  *****/
    
    
    // sXY, is an elemeent in the byte array of the in_state, as a 4x4. x is row, y is column
    // For isntance, s00 is Byte 0 (LSB), s01 is Byte 4, s10 is Byte 2, etc
    // Following notaions as set forth in NIST AES document FIPS 197
    wire [7:0] s00, s01, s02, s03,
               s10, s11, s12, s13,
               s20, s21, s22, s23,
               s30, s31, s32, s33;
    
    //formula: [8*i + 7 : 8*i] where i is the byte index given that the 128-bit block is divided in the 4x4 array
    // First row
    assign s00 = state[7:0]; // byte 0 LSB
    assign s01 = state[39:32]; // byte 4
    assign s02 = state[71:64]; // byte 8
    assign s03 = state[103:96]; // byte 12
    
    // second row
    assign s10 = state[15:8]; // byte 1
    assign s11 = state[47:40]; // byte 5 
    assign s12 = state[79:72]; // byte 9 
    assign s13 = state[112:104]; // byte 13  
    
    // third row
    assign s20 = state[23:16]; // byte 2 
    assign s21 = state[55:48]; // byte 6 
    assign s22 = state[87:80]; // byte 10 
    assign s23 = state[119:112]; // byte 14 
    
    // fourth row
    assign s30 = state[31:24]; // byte 3 
    assign s31 = state[63:56]; // byte 7 
    assign s32 = state[95:88]; // byte 11 
    assign s33 = state[127:120]; // byte 15 MSB
    
    
    
    /***** MixColumns init *****/
    
    
    /***** Procedural block *****/
    always @(*) begin // blocking assignments   
        // init
        
        // SubBytes
        // Implementation note: if room available, could be accelerated by using 4 32w SBox modules
        state = in_state; // assign in_state to state   
        for(i = 0; i < 4; i = i + 1) begin // need to shift state by 4 times to keep only 1 SBox in use
            Sub_Input = state[31:0];
            state[31:0] = Sub_Output;
            state = (state << 32) | (state >> 96); // Circular shift left by 32 bits       
        end
        
        
        // ShiftRows
        // Reassigning the shift rows to their appropriate shift
        // However, since we are writting as big endian, the entire array is transposed so rows become columns and columns become rows
        //(e.g. s00, the LSB, in most documentation is shown in the top left of the array, but here it will be put in the bottom right for ordering)
        
        state = {s30, s21, s12, s03, s33, s20, s11, s02, s32, s23, s10, s01, s31, s22, s13, s00};
        
        
        // MixColumns
        
        
        // AddRoundKey
        out_state = state ^ round_key; // straight forward enough, XOR state to round_key to get final state
        
    end
    
    
        
    
    
    
endmodule

// Same as round, except discludes the Mixcolumns step
module cipher_final_round(
    input [127:0] in_state,
    input [127:0] round_key,
    output [127:0] out_state
    );
    
    
    
endmodule


module shift_rows(
    input [127:0] in_state,
    output reg [127:0] out_state
    );
    
    // sXY, is an elemeent in the byte array of the in_state, as a 4x4. x is row, y is column
    // For isntance, s00 is Byte 0 (LSB), s01 is Byte 4, s10 is Byte 2, etc
    // Following nations as set forth in NIST AES document FIPS 197
    wire [7:0] s00, s01, s02, s03,
               s10, s11, s12, s13,
               s20, s21, s22, s23,
               s30, s31, s32, s33;
    
    
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
   
    always @(*) begin
        // Reassigning the shift rows to their appropriate shift
        // However, since we are writting as big endian, the entire array is transposed so rows become columns and columns become rows
        //(e.g. s00, the LSB, in most documentation is shown in the top left of the array, but here it will be put in the bottom right for ordering)
  
        
        out_state = {
                        s30, s21, s12, s03,
                        s33, s20, s11, s02,
                        s32, s23, s10, s01,
                        s31, s22, s13, s00
                    };
        
    end
endmodule


