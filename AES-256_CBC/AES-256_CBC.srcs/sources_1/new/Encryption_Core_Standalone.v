`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2023 06:25:04 PM
// Design Name: 
// Module Name: Encryption_2
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


module Encryption_Core_Standalone(
    input CLK,
    input start,
    input [127:0] Plaintext,
    input [127:0] Key_Zero,
    input [127:0] Key_One,
    input [127:0] Key_Two,
    input [127:0] Key_Three,
    input [127:0] Key_Four,
    input [127:0] Key_Five,
    input [127:0] Key_Six,
    input [127:0] Key_Seven,
    input [127:0] Key_Eight,
    input [127:0] Key_Nine,
    input [127:0] Key_Ten,
    input [127:0] Key_Eleven,
    input [127:0] Key_Twelve,
    input [127:0] Key_Thirteen,
    input [127:0] Key_Fourteen,
    output reg [127:0] Ciphertext,
    output reg finished
    );

    //Key Expansion
    
    //Assigning all keys from Input
    wire [127:0] key [14:0]; // Fourteen key array + "round 0" key
    
    assign key[0] = Key_Zero;
    assign key[1] = Key_One;
    assign key[2] = Key_Two;
    assign key[3] = Key_Three;
    assign key[4] = Key_Four;
    assign key[5] = Key_Five;
    assign key[6] = Key_Six;
    assign key[7] = Key_Seven;
    assign key[8] = Key_Eight;
    assign key[9] = Key_Nine;
    assign key[10] = Key_Ten;        
    assign key[11] = Key_Eleven;
    assign key[12] = Key_Twelve;
    assign key[13] = Key_Thirteen;
    assign key[14] = Key_Fourteen;

    // Rounds
    wire [127:0] thirteenth_state;
    wire thirteen_finished;
    reg [127:0] plaintext_input;
    reg round_reset;

    thirteen_rounds Rounds (.CLK(CLK),
                            .reset(round_reset),
                            .initial_state(plaintext_input),
                            .key1(key[1]),
                            .key2(key[2]), 
                            .key3(key[3]), 
                            .key4(key[4]), 
                            .key5(key[5]), 
                            .key6(key[6]), 
                            .key7(key[7]), 
                            .key8(key[8]), 
                            .key9(key[9]), 
                            .key10(key[10]), 
                            .key11(key[11]), 
                            .key12(key[12]), 
                            .key13(key[13]),
                            .final_state(thirteenth_state),
                            .finished(thirteen_finished)
                            );
     
    reg [127:0] finalRoundState;
    wire [127:0] finalRoundStateOut;
    cipher_final_round FinalRound(.in_state(finalRoundState), .round_key(key[14]), .out_state(finalRoundStateOut));

    // init
    // TODO: Check for deadlocks

    localparam [1:0] S_WAIT = 2'b00, S_ENCRYPT = 2'b01, S_FINALROUND = 2'b10; // S_KEYS = 2'b11;
    
    reg [1:0] CS, NS;
    
    
    //For Simulation Only!
//    initial begin
//        CS <= S_WAIT;
//        finished <= 1;
//    end
    
    always @(posedge CLK) begin
        CS <= NS;
    end
    
    always @(*) begin
        case(CS)
            S_WAIT: 
            begin
                if(start) begin
                    NS <= S_ENCRYPT;
                    plaintext_input <= Plaintext ^ key[0];
                    round_reset <= 1;
                    finished <= 0; 
                end 
                
                else NS <= S_WAIT;      
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