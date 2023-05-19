`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2023 04:22:37 PM
// Design Name: 
// Module Name: AES_256_TB
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


module AES_256_TB();

    reg clock;
    reg test_enc_start, test_dec_start, test_key_start;
    reg [127:0] test_plain_in, test_cipher_in;

    wire [127:0] test_cipher_out, test_plain_out;
    
    reg [255:0] test_key;
    reg test_key_select;
    
    wire test_enc_fin, test_dec_fin;
    wire test_keyfin;
    

    AES_256_Top_Module DUT(
                            .CLK            (clock),
                            .Key            (test_key),
                            .Key_Select     (test_key_select), // selects where to write new generated key to 0=encryption 1=decryption.
                            .Key_Start      (test_key_start), // start key expansion
                            .Key_Finish     (test_keyfin),
                            
                            .Plaintext_In   (test_plain_in),
                            .Enc_Start      (test_enc_start), // control signal for encryption
                            .Enc_Fin        (test_enc_fin), // finished bit for encryption
                            .Ciphertext_Out (test_cipher_out),
                            
                            .Ciphertext_In  (test_cipher_in),
                            .Dec_Start      (test_dec_start), // control reg for decryption
                            .Dec_Fin        (test_dec_fin), // finished bit for decryption
                            .Plaintext_Out  (test_plain_out)
                            );
    
    initial begin
        clock = 1'b0;
    end
    always #0.5 clock=~clock;

    initial begin
        // Encryption test
        // This block tests From NIST SP 800-38A, Appendix F, CTR-AES256.Encrypt
        

        /*** Test Encryption ***/

        test_key_select = 0;
        test_key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
        
        @(negedge clock);
        test_key_start = 1;
        @(negedge clock) test_key_start = 0;
        @(test_keyfin) $display("Finished Key expansion");
        #1 $stop;

        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin) $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 0bdf7df1591716335e9a8b15c860c502
        
        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff00;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin)  $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 5a6e699d536119065433863c8f657b94
        
        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff01;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin) $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 1bc12c9c01610d5d0d8bd6a3378eca62
        
        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff02;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin) $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 2956e1c8693536b1bee99c73a31576b6


        /*** Test Decryption ***/

        test_key_select = 1; // Decryption
        test_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

        @(negedge clock);
        test_key_start = 1;
        @(negedge clock) test_key_start = 0;
        @(test_keyfin) $display("Finished Key expansion");
        #1 $stop;

        test_cipher_in = 128'h8ea2b7ca516745bfeafc49904b496089;
        @(negedge clock) test_dec_start = 1;
        @(negedge clock) test_dec_start = 0;
        @(test_dec_fin) $display("Finished Decryption: %h", test_plain_out);
        #1 $stop;
        // expected: 00112233445566778899aabbccddeeff


        /*** Test if Encryption changed key ***/

        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdff00;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin)  $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 5a6e699d536119065433863c8f657b94

        /*** Change decryption key, but encrypt ***/

        test_key_select = 1; // Decryption
        test_key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

        @(negedge clock);
        test_key_start = 1;
        @(negedge clock) test_key_start = 0;
        @(test_keyfin) $display("Finished Key expansion");
        #1 $stop;

        test_plain_in = 128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;
        @(negedge clock) test_enc_start = 1;
        @(negedge clock) test_enc_start = 0;
        @(test_enc_fin) $display("Finished Encryption: %h", test_cipher_out);
        #1 $stop;
        // expected: 0bdf7df1591716335e9a8b15c860c502

    end



endmodule
