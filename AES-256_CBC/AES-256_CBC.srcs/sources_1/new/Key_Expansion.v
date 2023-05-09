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
// Description: Key Expansion Module for AES-256
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 1.0 - Finished preliminary testing and implementation on VCU-118 Xilinx FPGA. 4/23/2023 - Max Cohen Hoffing
// Revision 1.1 - Cleaning Up Code and Commenting  
// Additional Comments:
// Expansion Module can use a faster clock. Tested with 100MHz clock with success using VCU118 FPGA
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
    output [127:0] Expanded_Key_Thirteen, 
    output Done
   
   //for Simulation ONLY
   
//    output [31:0] round_val,
//    output [4:0] KeyCount,
//    output [1:0] KeyState, 
//    output [2:0] XORCount, rconCount,
//    output WordSelect   
     
    );
    
    //Declaring All Wires and Register Values
    
    reg Expansion_Complete;
  
    //2D Packed Register Array --> Length of Register before Name, # of Registers after name. 
    reg [127:0] Temp_Expanded_Key [14:0];
      
   // Storing rcon in registers 
    reg [223:0] rcon = 224'h01000000020000000400000008000000100000002000000040000000;   
    
    integer i;        

    reg [4:0] Key_count;
    reg [2:0] XOR_count, rcon_count;
    reg [1:0] Word_Select;

   // reg Upper_XOR;
    
    reg [31:0] current_round_val;
    
    wire [31:0] temp_val_zero;
    
    wire [31:0] temp_val_four [5:0];  
     
    reg Key_State;
    localparam Rotate_Left_Or_Sub = 1'b0, XOR_w_prev = 1'b1;
  
    //Assigning Output of Key_Expansion Module        

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

    assign Done = Expansion_Complete;
  
      //for Simulation ONLY
//    assign round_val = current_round_val; 
//    assign KeyCount = Key_count;
//    assign XORCount = XOR_count;
//    assign rconCount = rcon_count; 
//    assign WordSelect = Upper_XOR;
//    assign  KeyState = Key_State;
  
  
    //Declaring S_Box Modules for Key_Expsion 
      //S-Box Modules are declared for each operation with a different input in location
      // This can be later reduced if additional area is necessary

  
    S_Box_32w S_Mod_Zero (current_round_val, temp_val_zero);
   
   
    S_Box_32w S_Mod_Four_0 (Temp_Expanded_Key[2][31:0], temp_val_four[0][31:0]);
    S_Box_32w S_Mod_Four_1 (Temp_Expanded_Key[4][31:0], temp_val_four[1][31:0]);
    S_Box_32w S_Mod_Four_2 (Temp_Expanded_Key[6][31:0], temp_val_four[2][31:0]);
    S_Box_32w S_Mod_Four_3 (Temp_Expanded_Key[8][31:0], temp_val_four[3][31:0]);
    S_Box_32w S_Mod_Four_4 (Temp_Expanded_Key[10][31:0], temp_val_four[4][31:0]);
    S_Box_32w S_Mod_Four_5 (Temp_Expanded_Key[12][31:0], temp_val_four[5][31:0]);
    
  
    always@(posedge CLK, posedge RESET) begin: main_module //Pulling in new Data for asynchronous RESET 
    
        if (RESET) begin: pull_data // RESET and initialize circuit.
             
            //Performing rotation when key is pulled in, icreasing throughput by 1 clock cycle   
            current_round_val[31:24] <= Key[23:16];
            current_round_val[23:16] <= Key[15:8];
            current_round_val[15:8] <= Key[7:0];
            current_round_val[7:0] <= Key[31:24];           
        
            rcon_count <= 7; 
            Key_State <= XOR_w_prev;
            XOR_count <= 0;
            Key_count <= 2;
            Temp_Expanded_Key[1][127:0] <= Key[127:0]; 
            Temp_Expanded_Key[0][127:0] <= Key[255:128];
            Word_Select <= 3; 
            
            Expansion_Complete <= 0; 
        
            for (i=2; i < 15; i = i + 1) begin
        
                Temp_Expanded_Key[i][127:0] <= 0;
        
            end
        
    
        end: pull_data
        
        else begin: expand_key //Expanding the Key by generating 13 new keys
   
                
           if (Key_count < 15) begin: key_loop 
                
               
              if (XOR_count == 0) begin: Mod_Eight_Zero
    
                  case(Key_State)  //State Machine (Rotate_Word --> Substitute --> XOR Operation)
                  
                        Rotate_Left_Or_Sub: begin  
                                                                               
                            current_round_val[31:24] <= Temp_Expanded_Key[Key_count - 1][23:16];
                            current_round_val[23:16] <= Temp_Expanded_Key[Key_count - 1][15:8];
                            current_round_val[15:8] <= Temp_Expanded_Key[Key_count - 1][7:0];
                            current_round_val[7:0] <= Temp_Expanded_Key[Key_count - 1][31:24];
                                
                            Key_State <= XOR_w_prev;
                  
                        end                 
    
                        XOR_w_prev: begin //Substitute and XOR Operation is combined here
                                                                     
                            Temp_Expanded_Key[Key_count][127:96] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ temp_val_zero ^ rcon[rcon_count*32 - 1 -: 32];   //can re-use this register?         
                            rcon_count <= rcon_count - 1;
                            XOR_count <= XOR_count + 1;                                                             
                            Key_State <= Rotate_Left_Or_Sub; //?
                            Word_Select <= Word_Select - 1;
                            
                         end
                                  
                 endcase
                 
              end: Mod_Eight_Zero 
                        
              
              else if (XOR_count == 4) begin: Mod_Eight_Four
              
                  case(Key_State) //(Substitute --> XOR Operation)
                  
                        Rotate_Left_Or_Sub: begin 
                   
                            case(rcon_count)
                            
                               3'b110:                      
                                  current_round_val <= temp_val_four[0];
                      
                               3'b101:                             
                                  current_round_val <= temp_val_four[1];

                               3'b100:                             
                                  current_round_val <= temp_val_four[2];
                                 
                               3'b011:                             
                                  current_round_val <= temp_val_four[3];                                

                               3'b010:                             
                                  current_round_val <= temp_val_four[4];
                                 
                               3'b001:                            
                                  current_round_val <= temp_val_four[5];
                                                                                    
                             endcase
                           
                             Key_State <= XOR_w_prev;
                      
                        end
                        
                        XOR_w_prev: begin
                                                              
                            Temp_Expanded_Key[Key_count][127:96] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ current_round_val;  
                                   
                            XOR_count <= XOR_count + 1;
                            Key_State <= Rotate_Left_Or_Sub;
                            Word_Select <= Word_Select - 1;                                                                                         
                            
                         end
                        
                  endcase
                
              end: Mod_Eight_Four     
              
              else begin: XOR_Word //XOR Operation
              
                   if (XOR_count == 3 ) begin
                   
                       Key_count <= Key_count + 1;
                       XOR_count <= XOR_count + 1;
                 //      Upper_XOR <= 1; 
                  
                   end
                  
                   if (XOR_count == 7) begin
                   
                       Key_count <= Key_count + 1; 
                       XOR_count <= 0;
                  //     Upper_XOR <= 0;
                       
                   end   
                       
                   else begin
                    
                    XOR_count <= XOR_count + 1;  
                    
                   end
                   
                Temp_Expanded_Key[Key_count][(Word_Select + 1)*32 - 1 -: 32] <= Temp_Expanded_Key[Key_count - 2][(Word_Select+1)*32 - 1 -: 32] ^ Temp_Expanded_Key[Key_count][(Word_Select + 2)*32 - 1 -: 32];
                Word_Select <= Word_Select - 1;    
                       
              end: XOR_Word
                 
           end: key_loop
                      
           
           else begin: Write_Done
        
               Expansion_Complete <= 1;
        
           end: Write_Done                     
           
                    
        end: expand_key     
        
             
    end: main_module





//  clk_wiz_0 my_Clock
//   (
//    // Clock out ports
//    .clk_out1(CLK),     // output clk_out1
//    // Status and control signals
//    .reset(1'b0), // input reset
//    .locked(locked),       // output locked
//   // Clock in ports
//    .clk_in1_p(CLK_P),    // input clk_in1_p
//    .clk_in1_n(CLK_N));    // input clk_in1_n
    
endmodule




