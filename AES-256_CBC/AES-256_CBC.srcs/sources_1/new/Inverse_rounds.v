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
  

// Inverse


module Inv_cipher_round(
    input [127:0] in_state,
    input [127:0] round_key,
    output reg [127:0] out_state
    );

    reg [127:0] state; // memory for internal operations on state


    /***** InvShiftRows init  *****/
    reg [127:0] Shift_Input;
    wire [127:0] Shift_Output;
    Inv_shift_rows InvShiftRows(
        .in_state(Shift_Input),
        .shifted_state(Shift_Output)
        );
        

    /***** InvSubBytes init  *****/
    reg [127:0] Sub_Input;
    wire [127:0] Sub_Output;
    // Intialization of modules
    Inv_Full_Array_Sbox InvSubBytes(
        .in_state(Sub_Input),
        .out_state(Sub_Output)
        );
    

    
    /***** InvMixColumns init *****/
    reg [127:0] Mix_Input;
    wire [127:0] Mix_Output;
    Inv_mix_columns InvMixColumns(
        .in_state(Mix_Input),
        .out_state(Mix_Output) 
        );


    always @(*) begin
        state = in_state;

        // InvShiftRows
        Shift_Input = state;
        state = Shift_Output;

        // InvSubBytes
        Sub_Input = state;
        state = Sub_Output;

        // AddRoundKey
        state = state ^ round_key; // straight forward enough, XOR state to round_key to get final state

        // InvMixColumns
        Mix_Input = state;
        out_state = Mix_Output;
 
    end

endmodule


module Inv_cipher_final_round(
    input [127:0] in_state,
    input [127:0] round_key,
    output reg [127:0] out_state
    );

    reg [127:0] state; // memory for internal operations on state

    /***** InvShiftRows init  *****/
    reg [127:0] Shift_Input;
    wire [127:0] Shift_Output;
    Inv_shift_rows InvShiftRows(
        .in_state(Shift_Input),
        .shifted_state(Shift_Output)
        );

    /***** InvSubBytes init  *****/
    reg [127:0] Sub_Input;
    wire [127:0] Sub_Output;
    // Intialization of modules
    Inv_Full_Array_Sbox InvSubBytes(
        .in_state(Sub_Input),
        .out_state(Sub_Output)
        );
    
    always @(*) begin
        state = in_state;

        // InvShiftRows
        Shift_Input = state;
        state = Shift_Output;

        // InvSubBytes
        Sub_Input = state;
        state = Sub_Output;

        // AddRoundKey
        out_state = state ^ round_key; // straight forward enough, XOR state to round_key to get final state

        // No InvMixColumns on final round

    end

endmodule