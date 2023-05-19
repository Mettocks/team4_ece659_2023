`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2023 04:38:58 PM
// Design Name: 
// Module Name: Decryption_Core_tb
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


module Decryption_Core_tb();

        
    reg clock;
    reg test_start;
    reg key_start;
    reg [127:0] test_cipher;
    reg [255:0] test_key;
    wire [127:0] test_plain;
    wire test_ctrl;
    wire test_keyfin;
    //reg [7:0] j; // For loop var
    
    
    Decryption_Core_Standalone DUT (.CLK(clock),
                         .start(test_start),
                         .key_start(key_start),
                         .Ciphertext(test_cipher),
                         .Key(test_key),
                         .Plaintext(test_plain),
                         .finished(test_ctrl),
                         .key_finished(test_keyfin)
                         );

    initial begin
        clock = 1'b0;
    end
    always #0.5 clock=~clock;


     initial begin
        // This block tests the Vector from FIP 197, Appendix C, Testvector 1
        test_start = 0;
        test_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;            
        
        #1 key_start = 1;
        test_start = 1;
        #1 key_start = 0;
        @(test_keyfin) $display("Finished Key Expansion");
        #1 $stop;

        test_cipher = 128'h8ea2b7ca516745bfeafc49904b496089;
        #1 test_start = 0;
        @(test_plain) $display("Finished Encryption");
        
        #1 $stop;
        // expect  00112233445566778899aabbccddeeff
    end

endmodule
