`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 04:47:58 PM
// Design Name: 
// Module Name: AES_256_Top_Module
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


module AES_256_Top_Module(
    input CLK,
    input [255:0] Key,
    input Key_Start,
    output Key_Finish,
    
    input [127:0] Plaintext_In,
    input Enc_Start,
    output Enc_Fin,
    output [127:0] Ciphertext_Out,
    
    input [127:0] Ciphertext_In,
    input Dec_Start,
    output Dec_Fin,
    output [127:0] Plaintext_Out
    );
    
    // Key_Expansion
    Key_Expansion KeyExpansion(
                                
    
                                );
    
    // Encryption Core
    Encryption_Core EncryptionCore();
    // Decryption Core
    Decryption_Core DecryptionCore();
    
endmodule
