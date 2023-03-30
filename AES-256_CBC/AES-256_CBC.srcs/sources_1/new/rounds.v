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

module cipher_round(
    input [127:0] in_state,
    input [127:0] round_key,
    output reg [127:0] out_state
    );
    
    reg [127:0] state; // memory for internal operations on state
    integer i; // loop
    
    reg [31:0] Sub_Input;
    wire [31:0] Sub_Output;
    // Intialization of modules
    S_Box_32w SubBytes(
        .Word_In(Sub_Input),
        .Word_Out(Sub_Output)
    );
    
    always @(*) begin // blocking assignments
    
        // init
        state = in_state; // assign in_state to state
        
        // SubBytes
        for(i = 0; i < 4; i = i + 1) begin // need to shift state by 4 times to keep only 1 SBox in use
            Sub_Input = state[31:0];
            state[31:0] = Sub_Output;
            state = (state << 32) | (state >> 96); // Circular shift left by 32 bits       
        end
        
        // Shiftrows
        
        
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