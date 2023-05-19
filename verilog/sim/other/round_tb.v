`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2023 12:49:26 PM
// Design Name: 
// Module Name: round_tb
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


module round_tb();

    reg [127:0]in;
    reg [127:0] round_key;
    wire [127:0]out;
    
    cipher_round a1(.in_state(in), .round_key(round_key), .out_state(out));
    
    /*
    reg [127:0] inv_in;
    wire [127:0] inv_out;
    Inv_cipher_round b1(.in_state(inv_in), .round_key(round_key), .out_state(inv_out));
    */
    initial begin
        
        // Test vectors pulled from FIP 197, Apendix C3.

        round_key = 256'h101112131415161718191a1b1c1d1e1f; // round[1].k_sch and round[13].ik_sch for cipher and invcipher respectively

        in = 128'h00102030405060708090a0b0c0d0e0f0; // round[1].start for cipher
        // expect 4f63760643e0aa85efa7213201a4e705

        @(out) $display("Finished Encryption");
        #1 $stop;
        
        /*
        inv_in = 128'h84e1fd6b1a5c946fdf4938977cfbac23; // round[13].istart for invcipher
        // expect 6353e08c0960e104cd70b751bacad0e7   
    
        @(inv_out) $display("Decryption finished");
        #1 $stop;
        

        $display("Finished TB");
        #1 $stop;
        */
    end
    


endmodule
