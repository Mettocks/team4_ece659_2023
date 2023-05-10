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
    input Key_Select, // selects where to write new generated key to 0=encryption 1=decryption.
    input Key_Start, // start key expansion
    output Key_Finish,
    
    input [127:0] Plaintext_In,
    input Enc_Start, // control signal for encryption
    output Enc_Fin, // finished bit for encryption
    output [127:0] Ciphertext_Out,
    
    input [127:0] Ciphertext_In,
    input Dec_Start, // control reg for decryption
    output Dec_Fin, // finished bit for decryption
    output [127:0] Plaintext_Out
    );
    
    // Key_Expansion
    Key_Expansion KeyExpansion(
        RESET(),
        CLK(),
        Key(),
        Expanded_Key_One(), 
        Expanded_Key_Two(), 
        Expanded_Key_Three(), 
        Expanded_Key_Four(), 
        Expanded_Key_Five(), 
        Expanded_Key_Six(),
        Expanded_Key_Seven(),
        Expanded_Key_Eight(),
        Expanded_Key_Nine(), 
        Expanded_Key_Ten(),
        Expanded_Key_Eleven(), 
        Expanded_Key_Twelve(),
        Expanded_Key_Thirteen(), 
        Done()                            
        );
    
    // Encryption Core
    Encryption_Core Cipher(
        .CLK(),
        .start(),
        .key_start(),
        .Plaintext(),
        .in_key0(),
        .in_key1(),
        .in_key3(),
        .in_key4(),
        .in_key5(),
        .in_key6(),
        .in_key7(),
        .in_key8(),
        .in_key9(),
        .in_key10(),
        .in_key11(),
        .in_key12(),
        .in_key13(),
        .in_key14(),
        .Ciphertext(),
        .finished(),
        .key_finished()
        );
    // Decryption Core
    Decryption_Core InvCipher(
        .CLK(),
        .start(),
        .key_start(),
        .Ciphertext(),
        .in_key0(),
        .in_key1(),
        .in_key3(),
        .in_key4(),
        .in_key5(),
        .in_key6(),
        .in_key7(),
        .in_key8(),
        .in_key9(),
        .in_key10(),
        .in_key11(),
        .in_key12(),
        .in_key13(),
        .in_key14(),
        .Plaintext(),
        .finished(),
        .key_finished()
        );
    
endmodule
