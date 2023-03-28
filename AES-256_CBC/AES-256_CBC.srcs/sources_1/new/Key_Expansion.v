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


module Key_Expansion(
    input CLK,
    input [255:0] Key,
    output [15:0] Expanded_Key [127:0] //14 Generated 128-bit Keys
    );
    
    //Declaring Register Values
    reg RESET;
   // reg Lower_Upper;
   
   // Storing rcon in registers 
    reg [223:0] rcon  = 224'h0040002000100008000400020001;
    wire [7:0] rcon_cycle [6:0];
    genvar m;  
    
        for (m=0; m<7; m = m + 1) begin
             assign rcon_cycle[m][31:0] = rcon[m*32 +: 32];
    
        end
    
    integer i,j,k;
    reg [31:0] temp_schedule; 
    
    reg [5:0] loop_count;
    reg [2:0] XOR_count, rcon_count;
    reg [1:0] Key_Word_Select;
    //reg [7:0][255:0] XYZ;
    
    reg [7:0] current_round_val [31:0]; 
    reg [7:0] previous_round_val [31:0];
    
    reg [1:0] Key_State;
    localparam Rotate_Left = 2'b00, Sub = 2'b01, XOR_w_prev = 2'b10, End_Round = 2'b11;
   
   
    always@(posedge CLK, posedge RESET) begin: main_module //Pulling in new Data or asynchronous RESET 
    
    
        if (RESET) begin: pull_data // RESET Circuit when XYZ
    
        Rotate_Left_Once(Key[255:224], current_round_val[7][31:0]);
        loop_count <= 0;
        Key_State <= Sub;
        XOR_count <= 0;
        Key_count <= 2;
        Expanded_Key[0][127:0] <= Key[127:0]; //Double check?
        Expanded_Key[1][127:0] <= Key[255:128];
        
            for ( j=0; j<7; j = j+1) begin: pull_key
            
                current_round_val[j][23:0] <= 24'h000000;
               // previous_round_val[j][31:0] <= Key[j*32 +: 32];
            
            end: pull_key
        
    
        end: pull_data
        
        else begin: expand_key
    
           if (loop_count < 56) begin: key_loop 
               
              if (XOR_count == 0) begin: Mod_Eight_Zero
    
                  case(Key_State)  
                  
                        Rotate_Left: begin
                  
                            Rotate_Left_Once(Expanded_Key[Key_count - 1][127:96], current_round_val[0][31:0]);
                            Key_State <= Sub;
                  
                        end
                  
                        Sub: begin 
                   
                            S_Box_32w(current_round_val[0][31:0], current_round_val[0][31:0]);
                            Key_State <=  XOR_w_prev;
                      
                        end
    
                        XOR_w_prev: begin
                                         
                            //  previous_round_val[0][31:0] <= previous_round_val[7][31:0] ^ current_round_val[0][31:0] ^ rcon[rcon_count*32 +: 32];
                            Expanded_Key[Key_count][31:0] <= Expanded_key[key_count - 2][127:96] ^ current_round_val[0][31:0] ^ rcon[rcon_count*32 +: 32];   //can re-use this register?         
                            rcon_count <= rcon_count + 1;
                            XOR_count <= XOR_count + 1;                                                             
                            //Key_state <= XOR_w_prev; //?
                            
                         end
                                  
                 endcase
                 
              end: Mod_Eight_Zero 
                        
              
              else if (XOR_count == 4) begin: Mod_Eight_Four
              
                  case(Key_State) 
                  
                        Sub: begin 
                   
                            S_Box_32w(previous_round_val[4][31:0], current_round_val[4][31:0]);
                            Key_State <= XOR_w_prev;
                      
                        end
                        
                        XOR_w_prev: begin
                                         
                      
                         //   previous_round_val[0][31:0] <= previous_round_val[7][31:0] ^ current_round_val[0][31:0] ^ rcon_cycle[rcon_count][31:0];
                            Expanded_Key[Key_count][31:0] <= Expanded_Key[Key_count - 2][127:96] ^ current_round_val[0][31:0];  
                            //can re-use the expanded key register?         
                            XOR_count <= XOR_count + 1;                                                             
                            
                            
                         end
                        
                  endcase
                
              end: Mod_Eight_Four     
              
              else begin: XOR_Word
              
                   if (XOR_count == 3) begin
                       Key_count <= Key_count + 1; 
                  
                   end
                  
                   if (XOR_count == 7) begin
                   
                       Key_count <= Key_count + 1; 
                       XOR_count <= 0;
                   end   
                       
                   else begin
                    
                    XOR_count <= XOR_count + 1;  
                    
                   end
                   
                Expanded_Key[Key_count][31:0] <= Expanded_Key[Key_count - 2][XOR_count*32 +: 32] ^ Expanded_Key[Key_count][(XOR_count - 1)*32 +: 32];    
               // current_round_val[XOR_count] <= Expanded_Key[Key_count - 1][XOR_count*32 +: 32] ^ current_round_val[XOR_count - 1][31:0];    
                       
              end: XOR_Word
                 
           end: key_loop
            
           else begin
              

              
              
                RESET <= 1;
                
              
           end
            
        end: expand_key     
             
    end: main_module
    
endmodule



//blocking or non_blocking?? Is this correct?
module Rotate_Left_Once(
    input [31:0] word_in,
    output [31:0] word_out);
    
    integer i;     
  
  always @(*) begin  
    
    //for ( i=0; i<8; i = i+1) begin: rotate_left
   
       word_out[7:0] <= word_in[15:8];
       word_out[15:8] <= word_in[23:16];
       word_out[23:16] <= word_in[31:24];
       word_out[31:24] <= word_in[7:0];
        
 //   end: rotate_left
    
  end  
endmodule

