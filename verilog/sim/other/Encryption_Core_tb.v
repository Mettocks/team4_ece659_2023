`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2023 04:20:27 PM
// Design Name: 
// Module Name: Encryption_Core_tb
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


 module Encryption_Core_tb();
    reg clock;
    reg test_start, key_start;
    reg [127:0] test_plain;
    reg [255:0] test_key;
    wire [127:0] test_cipher;
    wire test_ctrl;
    wire test_keyfin;

    
    Encryption_Core_Standalone DUT (.CLK(clock),
                         .start(test_start),
                         .key_start(key_start),
                         .Plaintext(test_plain),
                         .Key(test_key),
                         .Ciphertext(test_cipher),
                         .finished(test_ctrl),
                         .key_finished(test_keyfin)
                         );

    initial begin
        clock = 1'b0;
    end
    always #0.5 clock=~clock;
/**/

    initial begin
        
        // This block tests From NIST SP 800-38A, Appendix F, CTR-AES256.Encrypt
        test_key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
        #1 key_start = 1;
        #1 key_start = 0;
        @(test_keyfin) $display("Finished Key Expansion");
        #1 $stop;

        
        test_plain = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;
        #1.5 test_start = 1;
        #1 test_start = 0;
        @(test_cipher) $display("Finished Encryption");
        #1 $stop;
        // expected: 0bdf7df1591716335e9a8b15c860c502
        
        test_plain = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff00;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_cipher) $display("Finished Encryption");
        #1 $stop;
        // expected: 5a6e699d536119065433863c8f657b94
        
        test_plain = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff01;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_cipher) $display("Finished Encryption");
        #1 $stop;
        // expected: 1bc12c9c01610d5d0d8bd6a3378eca62
        
        test_plain = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff02;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_cipher) $display("Finished Encryption");
        #1 $stop;
        // expected: 2956e1c8693536b1bee99c73a31576b6
        
      
    end
/**/


/*
    initial begin
        // This block tests the Vector from FIP 197, Appendix C, Testvector 1
        test_start = 0;
        test_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; 
                        
        
        #1 key_start = 1;
        test_start = 1;
        #1 key_start = 0;
        @(test_keyfin) $display("Finished Key Expansion");
        #1 $stop;

        test_plain = 128'h00112233445566778899aabbccddeeff;
        #1 test_start = 0;
        @(test_cipher) $display("Finished Encryption");
        
        #1 $stop;
        // expect 8ea2b7ca516745bfeafc49904b496089
        
    end
*/

endmodule
