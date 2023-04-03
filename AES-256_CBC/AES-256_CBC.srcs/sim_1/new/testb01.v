`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 03:04:12 PM
// Design Name: 
// Module Name: testb01
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


module testb01();

reg [127:0] Plaintext, IV;
reg [255:0] Key;
reg system_CLK;
wire [127:0] Ciphertext;

initial
begin
system_CLK=0;
forever
#10 system_CLK=!system_CLK;
end

initial
begin
a=8'd255;
Plaintext = 128'b11111111110000000000111111111100000000001111111111000000000011111111110000000000111111111100000000001111111111000000000010101010;
IV = 128'b11111111110000000000111111111100000000001111111111000000000011111111110000000000111111111100000000001111111111000000000010101010;
Key = 256'b11111111110000000000111111111100000000001111111111000000000011111111110000000000111111111100000000001111111111000000000010101010;

rst=1;
#3000 rst=0;
end 

Encryption_Core a5(.Plaintext(Plaintext),.IV(IV),.Key(Key),.system_CLK(system_CLK),.Ciphertext(Ciphertext));
endmodule 
