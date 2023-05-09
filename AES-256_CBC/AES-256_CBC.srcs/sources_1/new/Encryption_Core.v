`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bala Akankshah, Max Cohen Hoffing, Matt Corcoran  
// 
// Create Date: 03/08/2023 03:28:34 PM
// Design Name: 
// Module Name: Encryption_Core
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

module Encryption_Core(
    input CLK,
    input start,
    input key_start,
    input [127:0] Plaintext,
    input [127:0] in_key0,
    input [127:0] in_key1,
    input [127:0] in_key3,
    input [127:0] in_key4,
    input [127:0] in_key5,
    input [127:0] in_key6,
    input [127:0] in_key7,
    input [127:0] in_key8,
    input [127:0] in_key9,
    input [127:0] in_key10,
    input [127:0] in_key11,
    input [127:0] in_key12,
    input [127:0] in_key13,
    input [127:0] in_key14,
    output reg [127:0] Ciphertext,
    output reg finished,
    output reg key_finished
    );

    //Key Expansion
    reg [255:0] key_input;
    wire [127:0] keys [14:0]; // Fourteen key array + "round 0" key

    // Assigning keys
    assign keys[0]  = in_key0; // Round 0 key is the first 16 bytes (4 columns) of the 32 byte array
    assign keys[1]  = in_key1; // Round 1 key is lower 16 bytes of original key
    assign keys[2]  = in_key2;
    assign keys[3]  = in_key3;
    assign keys[4]  = in_key4;
    assign keys[5]  = in_key5;
    assign keys[6]  = in_key6;
    assign keys[7]  = in_key7;
    assign keys[8]  = in_key8;
    assign keys[9]  = in_key9;
    assign keys[10] = in_key10;
    assign keys[11] = in_key11;
    assign keys[12] = in_key12;
    assign keys[13] = in_key13;
    assign keys[14] = in_key14;
    /*
    Key_Expansion KeyExpansion( // remaining keys
        .RESET(key_start),
        .CLK(CLK),
        .Key(key_input),
        .Expanded_Key_One(keys[2]), 
        .Expanded_Key_Two(keys[3]), 
        .Expanded_Key_Three(keys[4]),
        .Expanded_Key_Four(keys[5]), 
        .Expanded_Key_Five(keys[6]),
        .Expanded_Key_Six(keys[7]),
        .Expanded_Key_Seven(keys[8]), 
        .Expanded_Key_Eight(keys[9]),
        .Expanded_Key_Nine(keys[10]), 
        .Expanded_Key_Ten(keys[11]),
        .Expanded_Key_Eleven(keys[12]),
        .Expanded_Key_Twelve(keys[13]),
        .Expanded_Key_Thirteen(keys[14]), 
        .Done(key_finished)
        );
    
    */

    // Rounds
    wire [127:0] thirteenth_state;
    wire thirteen_finished;
    reg [127:0] plaintext_input;
    reg round_reset;

    thirteen_rounds Rounds (.CLK(CLK),
                            .reset(round_reset),
                            .initial_state(plaintext_input),
                            .key1(keys[1]),
                            .key2(keys[2]), 
                            .key3(keys[3]), 
                            .key4(keys[4]), 
                            .key5(keys[5]), 
                            .key6(keys[6]), 
                            .key7(keys[7]), 
                            .key8(keys[8]), 
                            .key9(keys[9]), 
                            .key10(keys[10]), 
                            .key11(keys[11]), 
                            .key12(keys[12]), 
                            .key13(keys[13]),
                            .final_state(thirteenth_state),
                            .finished(thirteen_finished)
                            );
     
    reg [127:0] finalRoundState;
    wire [127:0] finalRoundStateOut;
    cipher_final_round FinalRound(.in_state(finalRoundState), .round_key(keys[14]), .out_state(finalRoundStateOut));

    // init
    // TODO: Check for deadlocks

    localparam [1:0] S_WAIT = 2'b00, S_ENCRYPT = 2'b01, S_FINALROUND = 2'b10, S_KEYS = 2'b11;
    
    reg [1:0] CS, NS;
    
    initial begin
        CS <= S_WAIT;
        finished <= 1;
    end
    
    always @(posedge CLK) begin
        CS <= NS;
    end
    
    always @(*) begin
        case(CS)
            S_WAIT: 
            begin
                if (key_start) begin
                    NS <= S_KEYS;
                    key_input <= Key;
                end else if(start) begin
                    NS <= S_ENCRYPT;
                    plaintext_input <= Plaintext ^ keys[0];
                    round_reset <= 1;
                    finished <= 0; 
                end else
                    NS <= S_WAIT;      
            end
            
            S_KEYS:
            begin
                if(key_finished) begin
                    NS <= S_WAIT;
                end else begin
                    NS <= S_KEYS;
                end
            end
            
            S_ENCRYPT: 
            begin
                round_reset <= 0;
                if (thirteen_finished) begin
                    NS <= S_FINALROUND;
                    finalRoundState <= thirteenth_state;
                end else
                    NS <= S_ENCRYPT;
            end

            S_FINALROUND: 
            begin
                NS <= S_WAIT;
                Ciphertext <= finalRoundStateOut;
                finished <= 1;
            end
            
        endcase
    end    

endmodule



