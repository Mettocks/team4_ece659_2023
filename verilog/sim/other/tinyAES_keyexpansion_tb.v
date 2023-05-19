`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2023 04:26:34 PM
// Design Name: 
// Module Name: tinyAES_keyexpansion_tb
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
`timescale 10ps/1ps

module tinyAES_keyexpansion_tb();
    reg clock;
    reg [255:0] test_key;
    wire [127:0] k1, k2, k3, k4, k5, k6, k7,
                   k8, k9, k10, k11, k12, k13, k14;
    //reg [7:0] j; // For loop var

    tinyAES_keyexpansion DUT(clock,
                            test_key,
                            k1, 
                            k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14);
    
    initial begin
        clock = 1'b0;
    end
    always #1 clock=~clock;
    
    initial begin
        // Vector from FIP 197, Appendix C, Testvector 1
        test_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; // Input into shift rows
        @(k14) $display("In:   %64h\nOut1:  %32h\nOut2: %32h\nOut3: %32h\nOut4: %32h\nOut5: %32h\nOut6: %32h\nOut7: %32h\nOut8: %32h\nOut9: %32h\nOut10: %32h\nOut11: %32h\nOut12: %32h\nOut13: %32h\nOut14: %32h",
                test_key, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13, k14);
        #1
        $stop;
    end
    

endmodule
