`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 04:54:56 PM
// Design Name: 
// Module Name: Key_Expansion
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

//Should we clock gate this module?
module Key_Expansion(
    input RESET,
    input CLK,
    input [255:0] Key,
    output [127:0] Expanded_Key_One, [127:0] Expanded_Key_Two, 
    output [127:0] Expanded_Key_Three, [127:0] Expanded_Key_Four, 
    output [127:0] Expanded_Key_Five, [127:0] Expanded_Key_Six,
    output [127:0] Expanded_Key_Seven, [127:0] Expanded_Key_Eight,
    output [127:0] Expanded_Key_Nine, [127:0] Expanded_Key_Ten,
    output [127:0] Expanded_Key_Eleven, [127:0] Expanded_Key_Twelve,
    output [127:0] Expanded_Key_Thirteen, [127:0] Expanded_Key_Fourteen 
    //14 Generated 128-bit Keys
    );
    
    //Declaring Register Values
    //reg RESET;
   // reg Lower_Upper;
   
   
  
   reg [127:0] Temp_Expanded_Key [15:0];
   
   
   // Storing rcon in registers 
    reg [223:0] rcon = 224'h0040002000100008000400020001;
 //   wire [6:0] rcon_cycle [31:0];
    genvar j, m;  
    
//        for (m=0; m<7; m = m + 1) begin
//             assign rcon_cycle[m][31:0] = rcon[m*32 +: 32];
    
//        end
            
    assign Expanded_Key_One = Temp_Expanded_Key[2];
    assign Expanded_Key_Two = Temp_Expanded_Key[3];
    assign Expanded_Key_Three = Temp_Expanded_Key[4];
    assign Expanded_Key_Four = Temp_Expanded_Key[5];
    assign Expanded_Key_Five = Temp_Expanded_Key[6];
    assign Expanded_Key_Six = Temp_Expanded_Key[7];
    assign Expanded_Key_Seven = Temp_Expanded_Key[8];
    assign Expanded_Key_Eight = Temp_Expanded_Key[9];
    assign Expanded_Key_Nine = Temp_Expanded_Key[10];
    assign Expanded_Key_Ten = Temp_Expanded_Key[11];
    assign Expanded_Key_Eleven = Temp_Expanded_Key[12];
    assign Expanded_Key_Twelve = Temp_Expanded_Key[13];
    assign Expanded_Key_Thirteen = Temp_Expanded_Key[14];
    assign Expanded_Key_Fourteen = Temp_Expanded_Key[15];
   // integer i,k;        
    
    
    reg [3:0] Key_count;
    reg [2:0] XOR_count, rcon_count;
    reg [1:0] Key_Word_Select;
    
    reg [31:0] current_round_val;
    
    wire [31:0] temp_val_zero;
    
    wire [31:0] temp_val_four [6:0]; 
   //reg temp_val_zero [31:0];   
    
    reg [1:0] Key_State;
    localparam Rotate_Left = 2'b00, Sub = 2'b01, XOR_w_prev = 2'b10, End_Round = 2'b11;
   
   
  // if (Key_State == Sub) begin
    S_Box_32w S_Mod_Zero (CLK, current_round_val, temp_val_zero);
    
//    generate 
//        for (j = 0; j<6; j = j+1) begin: 
//            S_Box_32w S_Mod_Four (Temp_Expanded_Key[(j*2)+2][127:96], temp_val_four[j][31:0]);
//        end
//    endgenerate 
   
    S_Box_32w S_Mod_Four_0 (CLK, Temp_Expanded_Key[2][127:96], temp_val_four[0][31:0]);
    S_Box_32w S_Mod_Four_1 (CLK, Temp_Expanded_Key[4][127:96], temp_val_four[1][31:0]);
    S_Box_32w S_Mod_Four_2 (CLK, Temp_Expanded_Key[6][127:96], temp_val_four[2][31:0]);
    S_Box_32w S_Mod_Four_3 (CLK, Temp_Expanded_Key[8][127:96], temp_val_four[3][31:0]);
    S_Box_32w S_Mod_Four_4 (CLK, Temp_Expanded_Key[10][127:96], temp_val_four[4][31:0]);
    S_Box_32w S_Mod_Four_5 (CLK, Temp_Expanded_Key[12][127:96], temp_val_four[5][31:0]);
    S_Box_32w S_Mod_Four_6 (CLK, Temp_Expanded_Key[14][127:96], temp_val_four[6][31:0]);
    

   
   
   
   
    always@(posedge CLK, posedge RESET) begin: main_module //Pulling in new Data or asynchronous RESET 
    
    
        if (RESET) begin: pull_data // RESET Circuit when XYZ
    
      //  Rotate_Left_Once(CLK, Key[255:224], current_round_val); // Is this correct?
        current_round_val[7:0] <= Key[239:232];
        current_round_val[15:8] <= Key[247:240];
        current_round_val[23:16] <= Key[255:248];
        current_round_val[31:24] <= Key[231:224];
        
        
        //loop_count <= 0;
        Key_State <= Sub;
        XOR_count <= 0;
        Key_count <= 2;
        Temp_Expanded_Key[0][127:0] <= Key[127:0]; //Double check?
        Temp_Expanded_Key[1][127:0] <= Key[255:128];
        
    
        end: pull_data
        
        else begin: expand_key
    
           if (Key_count < 14) begin: key_loop 
               
              if (XOR_count == 0) begin: Mod_Eight_Zero
    
                  case(Key_State)  
                  
                        Rotate_Left: begin
                  
                            //Rotate_Left_Once R_Mod_Zero (CLK, Temp_Expanded_Key[Key_count - 1][127:96], current_round_val);
                           
                            current_round_val[7:0] <= Temp_Expanded_Key[Key_count - 1][111:104];
                            current_round_val[15:8] <= Temp_Expanded_Key[Key_count - 1][119:112];
                            current_round_val[23:16] <= Temp_Expanded_Key[Key_count - 1][127:120];
                            current_round_val[31:24] <= Temp_Expanded_Key[Key_count - 1][103:96];
                                
                            Key_State <= Sub;
                  
                        end
                  
                        Sub: begin 
                            
                            
                            //S_Box_32w S_Mod_Zero (current_round_val, current_round_val);
                            current_round_val <= temp_val_zero;
                            
                            Key_State <= XOR_w_prev;
                      
                        end
    
                        XOR_w_prev: begin
                                         
                            
                            Temp_Expanded_Key[Key_count][31:0] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ current_round_val ^ rcon[rcon_count*32 +: 32];   //can re-use this register?         
                            rcon_count <= rcon_count + 1;
                            XOR_count <= XOR_count + 1;                                                             
                            Key_State <= Sub; //?
                            
                         end
                                  
                 endcase
                 
              end: Mod_Eight_Zero 
                        
              
              else if (XOR_count == 4) begin: Mod_Eight_Four
              
                  case(Key_State) 
                  
                        Sub: begin 
                   
                            //S_Box_32w  S_Mod_Four (Temp_Expanded_Key[Key_count - 1][127:96], current_round_val);
                            case(rcon_count)
                            
                               3'b000:                      
                                  current_round_val <= temp_val_four[0];
                      
                               3'b001:                             
                                  current_round_val <= temp_val_four[1];

                               3'b010:                             
                                  current_round_val <= temp_val_four[2];
                                 
                               3'b011:                             
                                  current_round_val <= temp_val_four[3];                                

                               3'b100:                             
                                  current_round_val <= temp_val_four[4];
                                 
                               3'b101:                            
                                  current_round_val <= temp_val_four[5];

                               3'b110:                            
                                  current_round_val <= temp_val_four[6];
                                                                                    
                             endcase
                           
                             Key_State <= XOR_w_prev;
                      
                        end
                        
                        XOR_w_prev: begin
                                                              
                            Temp_Expanded_Key[Key_count][31:0] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ current_round_val;  
                                   
                            XOR_count <= XOR_count + 1;
                            Key_State <= Rotate_Left;                                                             
                            
                            
                         end
                        
                  endcase
                
              end: Mod_Eight_Four     
              
              else begin: XOR_Word
              
                   if (XOR_count == 3) begin
                   
                       Key_count <= Key_count + 1;
                       XOR_count <= XOR_count + 1; 
                  
                   end
                  
                   if (XOR_count == 7) begin
                   
                       Key_count <= Key_count + 1; 
                       XOR_count <= 0;
                       
                   end   
                       
                   else begin
                    
                    XOR_count <= XOR_count + 1;  
                    
                   end
                   
                Temp_Expanded_Key[Key_count][31:0] <= Temp_Expanded_Key[Key_count - 2][XOR_count*32 +: 32] ^ Temp_Expanded_Key[Key_count][(XOR_count - 1)*32 +: 32];    
                       
              end: XOR_Word
                 
           end: key_loop
                     
        end: expand_key     
             
    end: main_module
    
endmodule



//blocking or non_blocking?? Is this correct?

//module Rotate_Left_Once(
//    input CLK,
//    input [31:0] word_in,
//    output reg [31:0] word_out);
    
 
  
//    always @(posedge CLK) begin  
    
   
//       word_out[7:0] <= word_in[15:8];
//       word_out[15:8] <= word_in[23:16];
//       word_out[23:16] <= word_in[31:24];
//       word_out[31:24] <= word_in[7:0];
        
    
//    end 
   
//endmodule


