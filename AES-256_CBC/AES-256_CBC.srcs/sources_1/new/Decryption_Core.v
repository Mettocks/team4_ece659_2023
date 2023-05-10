`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2023 03:28:34 PM
// Design Name: 
// Module Name: Decryption_Core
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

module Decryption_Core(
    input CLK,
    input start,
    input key_start,
    input [127:0] Ciphertext,
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
    output reg [127:0] Plaintext,
    output reg finished,
    output reg key_finished
    );
    
    //Key Expansion
    reg [255:0] key_input;
    wire [127:0] keys [14:0]; // Fourteen key array + "round 0" key
    
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

    // Key_Expansion KeyExpansion( // remaining keys
    //     .RESET(key_start),
    //     .CLK(CLK),
    //     .Key(key_input),
    //     .Expanded_Key_One(keys[2]), 
    //     .Expanded_Key_Two(keys[3]), 
    //     .Expanded_Key_Three(keys[4]),
    //     .Expanded_Key_Four(keys[5]), 
    //     .Expanded_Key_Five(keys[6]),
    //     .Expanded_Key_Six(keys[7]),
    //     .Expanded_Key_Seven(keys[8]), 
    //     .Expanded_Key_Eight(keys[9]),
    //     .Expanded_Key_Nine(keys[10]), 
    //     .Expanded_Key_Ten(keys[11]),
    //     .Expanded_Key_Eleven(keys[12]),
    //     .Expanded_Key_Twelve(keys[13]),
    //     .Expanded_Key_Thirteen(keys[14]), 
    //     .Done(key_finished)
    //     );
    
    
    //reg key_gen_finished; // internal ctrl wire, used to block encryption until keygen finished

    // Rounds
    wire [127:0] thirteenth_state;
    wire thirteen_finished;
    reg [127:0] ciphertext_input;
    reg round_reset;

    // input keys in reverse order (e.g 14th key of encryption is "inv round 0", 13th is "inv round 1" key, etc)
    Inv_thirteen_rounds Rounds (.CLK(CLK),
                                .reset(round_reset), 
                                .initial_state(ciphertext_input),
                                .key1(keys[13]),
                                .key2(keys[12]), 
                                .key3(keys[11]), 
                                .key4(keys[10]), 
                                .key5(keys[9]), 
                                .key6(keys[8]), 
                                .key7(keys[7]), 
                                .key8(keys[6]), 
                                .key9(keys[5]), 
                                .key10(keys[4]), 
                                .key11(keys[3]), 
                                .key12(keys[2]), 
                                .key13(keys[1]),
                                .final_state(thirteenth_state),
                                .finished(thirteen_finished)
                                );
     
    reg [127:0] finalRoundState;
    wire [127:0] finalRoundStateOut;
    Inv_cipher_final_round FinalRound(.in_state(finalRoundState), .round_key(keys[0]), .out_state(finalRoundStateOut));

    // init
    // TODO: Check for deadlocks
    localparam [1:0] S_WAIT = 2'b00, S_DECRYPT = 2'b01, S_FINALROUND = 2'b10, S_KEYS = 2'b11;
    
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
                    NS <= S_DECRYPT;
                    ciphertext_input <= Ciphertext ^ keys[14];
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
            
            S_DECRYPT: 
            begin
                round_reset <= 0;
                if (thirteen_finished) begin
                    NS <= S_FINALROUND;
                    finalRoundState <= thirteenth_state;
                end else
                    NS <= S_DECRYPT;
            end

            S_FINALROUND: 
            begin
                NS <= S_WAIT;
                Plaintext <= finalRoundStateOut;
                finished <= 1;
            end
            
        endcase
    end
   
    
endmodule

module Decryption_Core_Standalone(
    input CLK,
    input start,
    input key_start,
    input [127:0] Ciphertext,
    input [255:0] Key,
    output reg [127:0] Plaintext,
    output reg finished,
    output key_finished
    );
    
    //Key Expansion
    reg [255:0] key_input;
    wire [127:0] keys [14:0]; // Fourteen key array + "round 0" key
    
    assign keys[0] = Key[255:128]; // Round 0 key is the first 16 bytes (4 columns) of the 32 byte array
    assign keys[1] = Key[127:0]; // Round 1 key is lower 16 bytes of original key
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
    
    
    //reg key_gen_finished; // internal ctrl wire, used to block encryption until keygen finished

    // Rounds
    wire [127:0] thirteenth_state;
    wire thirteen_finished;
    reg [127:0] ciphertext_input;
    reg round_reset;

    // input keys in reverse order (e.g 14th key of encryption is "inv round 0", 13th is "inv round 1" key, etc)
    Inv_thirteen_rounds Rounds (.CLK(CLK),
                                .reset(round_reset), 
                                .initial_state(ciphertext_input),
                                .key1(keys[13]),
                                .key2(keys[12]), 
                                .key3(keys[11]), 
                                .key4(keys[10]), 
                                .key5(keys[9]), 
                                .key6(keys[8]), 
                                .key7(keys[7]), 
                                .key8(keys[6]), 
                                .key9(keys[5]), 
                                .key10(keys[4]), 
                                .key11(keys[3]), 
                                .key12(keys[2]), 
                                .key13(keys[1]),
                                .final_state(thirteenth_state),
                                .finished(thirteen_finished)
                                );
     
    reg [127:0] finalRoundState;
    wire [127:0] finalRoundStateOut;
    Inv_cipher_final_round FinalRound(.in_state(finalRoundState), .round_key(keys[0]), .out_state(finalRoundStateOut));

    // init
    // TODO: Check for deadlocks
    localparam [1:0] S_WAIT = 2'b00, S_DECRYPT = 2'b01, S_FINALROUND = 2'b10, S_KEYS = 2'b11;
    
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
                    NS <= S_DECRYPT;
                    ciphertext_input <= Ciphertext ^ keys[14];
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
            
            S_DECRYPT: 
            begin
                round_reset <= 0;
                if (thirteen_finished) begin
                    NS <= S_FINALROUND;
                    finalRoundState <= thirteenth_state;
                end else
                    NS <= S_DECRYPT;
            end

            S_FINALROUND: 
            begin
                NS <= S_WAIT;
                Plaintext <= finalRoundStateOut;
                finished <= 1;
            end
            
        endcase
    end
   
    
endmodule



module Inv_thirteen_rounds(
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

    integer i; // counter var
    reg [127:0] roundState, roundKey;
    wire [127:0] roundStateOut;
    Inv_cipher_round OneRound(.in_state(roundState), .round_key(roundKey), .out_state(roundStateOut));
    
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


