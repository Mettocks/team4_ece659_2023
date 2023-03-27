`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UMass Amherst
// Engineer: Matt Corcoran, Max C. Hoffing, Bala Akanksha Kandula
// 
// Create Date: 03/08/2023 03:34:45 PM
// Design Name: 
// Module Name: S-box
// Project Name: AES CBC Core
// Target Devices: XC7Z010
// Tool Versions: Vivado 2022.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Started modifying for mathematical hardware based SBox
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 8 Bit width S_Box using Eucledian Algorithm inverse
// 1. Calculate multiplicative inverse "b"
//    - Inverse in GF(256) as such:
//      - g(x) = x^8 + x^4 + x^3 + x + 1
//      - p(x) is the input into the program
//      - Have to find q(x), the inverse of p(x)
//    - Can use extended Eculidean theorem, which requires loops
// 2. Perform affine transformation on "b" as s
// 3. Output s
module S_box(
    input [7:0] Byte_In,
    output [7:0] Byte_Out
    );
    
    
        
endmodule

// Calculate the multiplicative inverser
// 
// Needs to do three things:
// MAP the GF(2^8) element to two GF(2^4) elements of form a = alp1 * x + alp2
// 
// https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Computing_multiplicative_inverses_in_modular_structures
module mult_inverse(
    input [7:0] p, // inverse input
    output [7:0] b // inverse output
    );
    

    
endmodule

// Map GF(2^8) to two GF(2^4)
// From: [1] https://ieeexplore.ieee.org/document/8641387
// It is shown that the choice of polynomials can increase the effciency of LUT6 mapping during synthesis
// As such: pick Q(z) = z^4 + z + 1 and P(y) = y^2 + y + 13
// Note that Q(z)
module GF8_to_GF4(

);

endmodule

// Calculate the mult inverse in GF(2^4)
module GF4_mult_inverse(

);

endmodule    


// 
module GF4_to_GF8(

);
    
endmodule



