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
    input system_CLK,
    input [127:0] Plaintext, IV,
    input [255:0] Key,
    output [127:0] Ciphertext
    );
    
    //Declaring Essential Wires
    wire RESET, CLK; 
    
    
    //Declaring Essential Registers
    reg [127:0] Pre_RND_TXT, C_TXT, Key_128;
    reg [255:0] Key_256; 
    
    
    always@(posedge CLK, posedge REST) begin: Main_Circuit //Pulling in new Data or asynchronous RESET 
    
    
        if (RESET) begin: RESET_my_Circuit // RESET Circuit when XYZ
    
            
    
    
    
  
        end: RESET_my_Circuit
    
        else begin: Pull_Data
    
            Key_256 <= Key;
            Key_128 <= Key[127:0]; 
            Pre_RND_TXT <= Plaintext ^ IV; // XOR w/ IV
  
        end: Pull_Data
  
    end: Main_Circuit
    
endmodule
