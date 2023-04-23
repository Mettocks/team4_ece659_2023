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

//Declaring Encryption Module
module Encryption_Core(
    input CLK,
    input start,
    input [127:0] Plaintext,
    input [255:0] Key,
    output reg [127:0] Ciphertext,
    output reg finished
    );

    //Key Expansion
    reg [255:0] key_input;
    wire [127:0] keys [14:0]; // Fourteen key array + "round 0" key
    
    assign keys[0] = Key[255:128]; // Round 0 key is the first 16 bytes (4 columns) of the 32 byte array
    tinyAES_keyexpansion KeyExpansion( // temp
        .clk(CLK),
        .key(key_input),
        .Expanded_Key_One(keys[1]), 
        .Expanded_Key_Two(keys[2]), 
        .Expanded_Key_Three(keys[3]),
        .Expanded_Key_Four(keys[4]), 
        .Expanded_Key_Five(keys[5]),
        .Expanded_Key_Six(keys[6]),
        .Expanded_Key_Seven(keys[7]), 
        .Expanded_Key_Eight(keys[8]),
        .Expanded_Key_Nine(keys[9]), 
        .Expanded_Key_Ten(keys[10]),
        .Expanded_Key_Eleven(keys[11]),
        .Expanded_Key_Twelve(keys[12]),
        .Expanded_Key_Thirteen(keys[13]), 
        .Expanded_Key_Fourteen(keys[14])
        );

    //reg key_gen_finished; // internal ctrl wire, used to block encryption until keygen finished

    wire [127:0] thirteenth_state;
    

    // Rounds
    reg round_reset;
    reg [127:0] plaintext_input;
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
        finished <= 0;
    end
    
    
    always @(posedge CLK) begin
        CS <= NS;
    end
   
    
    always @(*) begin
        key_input <= Key;
        case(CS)
            S_WAIT: 
            begin
                if(start) begin
                    NS <= S_ENCRYPT;
                    plaintext_input <= Plaintext ^ keys[0];
                    round_reset <= 1;
                    finished <= 0;
                end else
                    NS <= S_WAIT;      
            end
            
            S_ENCRYPT: 
            begin
                round_reset = 0;
                if (thirteen_finished) begin
                    NS <= S_FINALROUND;
                    finalRoundState <= thirteenth_state;
                end else
                    NS <= S_ENCRYPT;
            end

            S_FINALROUND: 
            begin
                Ciphertext <= finalRoundStateOut;
                finished <= 1;
                NS <= S_WAIT;
            end
            
        endcase
    end
    




endmodule

module thirteen_rounds(
    input CLK,
    input reset,
    input [127:0] initial_state,
    input [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13,
    output reg [127:0] final_state,
    output reg finished
    );

    wire [127:0] keys [12:0];
    assign keys[0] = key1;
    assign keys[1] = key2;
    assign keys[2] = key3;
    assign keys[3] = key4;
    assign keys[4] = key5;
    assign keys[5] = key6;
    assign keys[6] = key7;
    assign keys[7] = key8;
    assign keys[8] = key9;
    assign keys[9] = key10;
    assign keys[10] = key11;
    assign keys[11] = key12;
    assign keys[12] = key13;

    integer i; // loop
    reg [127:0] roundState, roundKey;
    wire [127:0] roundStateOut;
    cipher_round OneRound(.in_state(roundState), .round_key(roundKey), .out_state(roundStateOut));
    
    initial begin
        i <= 13;
        final_state <= 0;

    end

    always @(posedge CLK or posedge reset) begin
        if(reset) begin
            i <= 1;
            finished <= 0;
            roundState <= initial_state;
            roundKey <= keys[0];
        end
        else if ( i < 13 ) begin
            
            i <= i + 1;
            roundState <= roundStateOut;
            roundKey <= keys[i];
        end
        else if (i == 13) begin
            final_state <= roundStateOut;
            finished <= 1;
        end
    end

    


endmodule

