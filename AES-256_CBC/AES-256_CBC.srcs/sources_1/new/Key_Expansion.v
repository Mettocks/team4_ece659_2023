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
    output [13:0][127:0] Expanded_Key //14 Generated 128-bit Keys
    );
    
    //Declaring Register Values
    reg RESET;
   // reg Lower_Upper;
   
   // Storing rcon in registers 
    reg [231:0] rcon  = 112'h0040002000100008000400020001;
    wire [7:0] rcon_count [6:0];
    genvar m;  
    
        for (m=0; m<7; m = m + 1) begin
             assign rcon_cycle[m][7:0] = rcon[m*32 +: 32];
    
        end
    
    integer i,j,k;
    reg [31:0] temp_schedule; 
    
    reg [5:0] loop_count;
    reg [3:0] XOR_count;
    //reg [7:0][255:0] XYZ;
    
  
    
    reg [7:0] current_round_val [31:0]; 
    reg [7:0] previous_round_val [31:0];
    
    reg [1:0] Key_State;
    localparam Rotate_Left = 2'b00, Sub = 2'b01, XOR_w_rcon = 2'b10;
   
   
    always@(posedge CLK, posedge RESET) begin: main_module //Pulling in new Data or asynchronous RESET 
    
    
        if (RESET) begin: pull_data // RESET Circuit when XYZ
    
        Rotate_Left_Once (Key[255:224], temp);
        loop_count <= 0;
        Key_State <= Sub;
        XOR_count <= 0;
        //Expanded_Key[0][31:0] <= Key[31:0];
        
            for ( j=0; j<8; j = j+1) begin: pull_key
            
                current_round_val[j][31:0] <= 32'h00000000;
                previous_round_val[j][31:0] <= Key[j*32 +: 32];
            
            end: pull_key
        
    
        end: pull_data
        
        else begin: expand_key
    
           if (loop_count < 56) begin: key_loop 
           //needs work on timing. Is register necessary?
    
              if (!(loop_count % 8)) begin: Mod_Eight_Zero
    
                  case(Key_State)  
                  
                        Rotate_Left: begin
                  
                            Rotate_Left_Once(previous_round_val[7][31:0], current_round_val[0][31:0]);
                            Key_State <= Sub;
                  
                        end
                  
                        Sub: begin 
                   
                            S_box(current_round_val, current_round_val);
                            Key_State <=  XOR_w_rcon;
                      
                        end
    
                        XOR_w_rcon: begin
                                         
                      
                            current_round_val[0][31:0] <= previous_round_val[7][31:0] ^ rcon[rcon_count*32 +: 32];
                      
                      
                      //    for (k=0; k < 8; k = k + 1) begin
                                
                                  
                             
                               
//                                if (k == 7) begin
//                                Key_State <= Rotate_Left;
//                                loop_count <= loop_count + 1;
//                                end
                                             
                            //end
                      
                           
                        
                            Key_state <= Rotate_Left;
                            
                         end
                           // Expanded_Key[loop_count][127:0] <= 1;
    
                   //end
                 
                 endcase
                 
              end: Mod_Eight_Zero 
              
              
    

                   
                   //end
                   
                 
                   
                   
                
                      //endcase
                
                 
              
              
    
             end: key_loop
            
             else begin
              

              
              
                RESET <= 1;
                
              
             end
            
        end: expand_key     
             
    end: main_module
    
endmodule



//blocking or non_blocking?? Is this correct?
module Rotate_Left_Once(
    input [7:0][31:0] word_in,
    output [7:0][31:0] word_out);
    
    integer i;     
  
  always @(*) begin  
    
    for ( i=0; i<8; i = i+1) begin: rotate_left
   
       word_out[i][7:0] <= word_in[i][15:8];
       word_out[i][15:8] <= word_in[i][23:16];
       word_out[i][23:16] <= word_in[i][31:24];
       word_out[i][31:24] <= word_in[i][7:0];
        
    end: rotate_left
    
  end  
endmodule

