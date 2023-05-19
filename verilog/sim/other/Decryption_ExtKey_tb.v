`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2023 11:59:45 AM
// Design Name: 
// Module Name: Encryption_ExtKey_tb
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


module Decryption_ExtKey_tb();
    reg clock;
    reg test_start, key_start;
    reg [127:0] test_cipher;
    reg [255:0] test_key;
    wire [127:0] test_plain;
    wire test_ctrl;
    wire test_keyfin;


    wire [127:0] k1, k2, k3, k4, k5, k6, k7,
                   k8, k9, k10, k11, k12, k13;
    wire finished;
    //reg [7:0] j; // For loop var

    Key_Expansion KEYEXP(
                        key_start,
                        clock,
                        test_key,
                        k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13,
                        test_keyfin
                        );

    wire [127:0] k0a, k0b;
    assign k0a = test_key[255:128];
    assign k0b = test_key[127:0];
    Decryption_Core DUT (.CLK(clock),
                         .start(test_start),
                         .Ciphertext(test_cipher),
                         .in_key0 (k0a),
                         .in_key1 (k0b),
                         .in_key2 (k1),
                         .in_key3 (k2),
                         .in_key4 (k3),
                         .in_key5 (k4),
                         .in_key6 (k5),
                         .in_key7 (k6),
                         .in_key8 (k7),
                         .in_key9 (k8),
                         .in_key10(k9),
                         .in_key11(k10),
                         .in_key12(k11),
                         .in_key13(k12),
                         .in_key14(k13),
                         .Plaintext(test_plain),
                         .finished(test_ctrl)
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
        @(test_keyfin) $display("Finished Key Decryption");
        #1 $stop;

        
        test_cipher = 128'h0bdf7df1591716335e9a8b15c860c502;
        #1.5 test_start = 1;
        #1 test_start = 0;
        @(test_plain) $display("Finished Decryption");
        #1 $stop;
        // expected: f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff 
        
        test_cipher = 128'h5a6e699d536119065433863c8f657b94;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_plain) $display("Finished Decryption");
        #1 $stop;
        // expected: f0f1f2f3f4f5f6f7f8f9fafbfcfdff00 
        
        test_cipher = 128'h1bc12c9c01610d5d0d8bd6a3378eca62;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_plain) $display("Finished Encryption");
        #1 $stop;
        // expected: f0f1f2f3f4f5f6f7f8f9fafbfcfdff01 
        
        test_cipher = 128'h2956e1c8693536b1bee99c73a31576b6;
        #0.5 test_start = 1;
        #1 test_start = 0;
        @(test_plain) $display("Finished Decryption");
        #1 $stop;
        // expected: f0f1f2f3f4f5f6f7f8f9fafbfcfdff02
        
      
    end
endmodule
