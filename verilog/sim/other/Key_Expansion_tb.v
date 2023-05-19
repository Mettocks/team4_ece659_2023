`timescale 10ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2023 01:46:25 PM
// Design Name: 
// Module Name: Key_Expansion_tb
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


module Key_Expansion_tb();
    
    reg clock;
    reg input_start;

    reg [255:0] test_key;
    wire [127:0] k1, k2, k3, k4, k5, k6, k7,
                   k8, k9, k10, k11, k12, k13;
    wire finished;
    //reg [7:0] j; // For loop var

    Key_Expansion DUT(
                        input_start,
                        clock,
                        test_key,
                        k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13,
                        finished
                        );
    
    initial begin
        clock = 1'b0;
    end
    always #1 clock=~clock;
    
    initial begin
        // Vector from FIP 197, Appendix C, Testvector 1
        test_key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; // Input into shift rows
                        
        #0.5 input_start = 1;
        #1 input_start = 0;  
        @(posedge finished) $display("In:   %64h\nOut1: %32h\nOut2: %32h\nOut3: %32h\nOut4: %32h\nOut5: %32h\nOut6: %32h\nOut7: %32h\nOut8: %32h\nOut9: %32h\nOut10: %32h\nOut11: %32h\nOut12: %32h\nOut13: %32\n",
                test_key, k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13);
        #1
        $stop;
    end
endmodule
