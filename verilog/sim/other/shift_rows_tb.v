`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2023 10:23:29 AM
// Design Name: 
// Module Name: shift_rows_tb
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


module shift_rows_tb();
    reg [127:0] x;
    wire [127:0] y;
    //reg [7:0] j; // For loop var

    shift_rows DUT(.in_state(x), .shifted_state(y));
    
    initial begin
        // Vector from FIP 197, Appendix C, Testvector 1
        x = 128'h63cab7040953d051cd60e0e7ba70e18c; // Input into shift rows
        #10;
        $display("In:  %32h \nOut: %32h", x, y);
        // Output should be 6353e08c0960e104cd70b751bacad0e7
        $stop;
    end
    

endmodule
