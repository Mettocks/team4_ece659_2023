`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2023 04:46:53 PM
// Design Name: 
// Module Name: mix_columns
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


module mix_columns(input [127:0]in, output wire [127:0]out);

    //formula: [8*i + 7 : 8*i] where i is the byte index given that the 128-bit block is divided in the 4x4 array


//multiplication
//First column

assign out[127:120] = in[127:120]*8'h02+in[119:112]*8'h03+in[111:104]*8'h01+in[103:96]*8'h01;

assign out[119:112] = in[127:120]*8'h01+in[119:112]*8'h02+in[111:104]*8'h03+in[103:96]*8'h01;
    
assign out[111:104] = in[127:120]*8'h01+in[119:112]*8'h01+in[111:104]*8'h02+in[103:96]*8'h03;

assign out[103:96] = in[127:120]*8'h03+in[119:112]*8'h01+in[111:104]*8'h01+in[103:96]*8'h02;

/*    
 //second column
 
assign out[119:112] = in[119:112]*8'h02^in[87:80]*8'h03^in[55:48]*8'h01^in[23:16]*8'h01;

assign out[87:80] = in[119:112]*8'h01^in[87:80]*8'h02^in[55:48]*8'h03^in[23:16]*8'h01;
    
assign out[55:48] = in[119:112]*8'h01^in[87:80]*8'h01^in[55:48]*8'h02^in[23:16]*8'h03;

assign out[23:16] = in[119:112]*8'h03^in[87:80]*8'h01^in[55:48]*8'h01^in[23:16]*8'h02;  


 //third column

assign out[111:104] = in[111:104]*8'h02^in[79:72]*8'h03^in[47:40]*8'h01^in[15:8]*8'h01;

assign out[79:72] = in[111:104]*8'h01^in[79:72]*8'h02^in[47:40]*8'h03^in[15:8]*8'h01;
    
assign out[47:40] = in[111:104]*8'h01^in[79:72]*8'h01^in[47:40]*8'h02^in[15:8]*8'h03;

assign out[15:8] = in[111:104]*8'h03^in[79:72]*8'h01^in[47:40]*8'h01^in[15:8]*8'h02; 

 //fourth column
 
assign out[103:96] = in[103:96]*8'h02^in[71:64]*8'h03^in[39:32]*8'h01^in[7:0]*8'h01;

assign out[71:64] = in[103:96]*8'h01^in[71:64]*8'h02^in[39:32]*8'h03^in[7:0]*8'h01;
    
assign out[39:32] = in[103:96]*8'h01^in[71:64]*8'h01^in[39:32]*8'h02^in[7:0]*8'h03; 

assign out[7:0] = in[103:96]*8'h03^in[71:64]*8'h01^in[39:32]*8'h01^in[7:0]*8'h0;  

*/
//for(i=j;i>j-4;i--)
//always@(*)begin 

// state = in_state; // assign in_state to state   
// for(i = 0; i < 4; i = i + 1) begin // need to shift state by 4 times to keep only 1 SBox in use
//       V1 = state[i:i-4];
       
//end

endmodule
