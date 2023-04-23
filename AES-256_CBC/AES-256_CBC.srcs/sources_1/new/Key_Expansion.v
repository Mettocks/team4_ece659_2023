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
  //  input RESET,
    input CLK_P, CLK_N
   // input [255:0] Key,
//    output [127:0] Expanded_Key_One, [127:0] Expanded_Key_Two, 
//    output [127:0] Expanded_Key_Three, [127:0] Expanded_Key_Four, 
//    output [127:0] Expanded_Key_Five, [127:0] Expanded_Key_Six,
//    output [127:0] Expanded_Key_Seven, [127:0] Expanded_Key_Eight,
//    output [127:0] Expanded_Key_Nine, [127:0] Expanded_Key_Ten,
//    output [127:0] Expanded_Key_Eleven, [127:0] Expanded_Key_Twelve,
//    output [127:0] Expanded_Key_Thirteen, [127:0] Expanded_Key_Fourteen
   
   //for simulation only
   
//    output [31:0] round_val,
//    output [4:0] KeyCount,
//    output [1:0] KeyState, 
//    output [2:0] XORCount, rconCount,
//    output WordSelect   
     
    //14 Generated 128-bit Keys
    );
    
    //Declaring Register Values
 //   reg RESET;
   
   wire CLK;
  
   reg [127:0] Temp_Expanded_Key [14:0];
   
   
   // Storing rcon in registers 
    reg [223:0] rcon = 224'h01000000020000000400000008000000100000002000000040000000; 

    
       
    //reg [255:0] Key = 256'h4ffd41903a0189d27d8016b370c253f11877d7580fea37b2eb17ac5101bed306; 
    reg [255:0] Key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4; 
   
   
    genvar j, m;  
    
            
//    assign Expanded_Key_One = Temp_Expanded_Key[2];
//    assign Expanded_Key_Two = Temp_Expanded_Key[3];
//    assign Expanded_Key_Three = Temp_Expanded_Key[4];
//    assign Expanded_Key_Four = Temp_Expanded_Key[5];
//    assign Expanded_Key_Five = Temp_Expanded_Key[6];
//    assign Expanded_Key_Six = Temp_Expanded_Key[7];
//    assign Expanded_Key_Seven = Temp_Expanded_Key[8];
//    assign Expanded_Key_Eight = Temp_Expanded_Key[9];
//    assign Expanded_Key_Nine = Temp_Expanded_Key[10];
//    assign Expanded_Key_Ten = Temp_Expanded_Key[11];
//    assign Expanded_Key_Eleven = Temp_Expanded_Key[12];
//    assign Expanded_Key_Twelve = Temp_Expanded_Key[13];
//    assign Expanded_Key_Thirteen = Temp_Expanded_Key[14];
//    assign Expanded_Key_Fourteen = Temp_Expanded_Key[15];
    
    //for Simulation ONLY
//    assign round_val = current_round_val; 
//    assign KeyCount = Key_count;
//    assign XORCount = XOR_count;
//    assign rconCount = rcon_count; 
//    assign WordSelect = Upper_XOR;
//    assign  KeyState = Key_State;
    
    
    
    integer i;        

    reg [4:0] Key_count;
    reg [2:0] XOR_count, rcon_count;
    reg [1:0] Word_Select;

    reg Upper_XOR;
    reg trigger;

    
    reg [31:0] current_round_val;
    
    wire [31:0] temp_val_zero;
    
    wire [31:0] temp_val_four [6:0];  
    
    reg [1:0] Key_State;
    localparam Rotate_Left = 2'b00, Sub = 2'b01, XOR_w_prev = 2'b10, End_Round = 2'b11;
  
    S_Box_32w S_Mod_Zero (current_round_val, temp_val_zero);
   
    S_Box_32w S_Mod_Four_0 (Temp_Expanded_Key[2][31:0], temp_val_four[0][31:0]);
    S_Box_32w S_Mod_Four_1 (Temp_Expanded_Key[4][31:0], temp_val_four[1][31:0]);
    S_Box_32w S_Mod_Four_2 (Temp_Expanded_Key[6][31:0], temp_val_four[2][31:0]);
    S_Box_32w S_Mod_Four_3 (Temp_Expanded_Key[8][31:0], temp_val_four[3][31:0]);
    S_Box_32w S_Mod_Four_4 (Temp_Expanded_Key[10][31:0], temp_val_four[4][31:0]);
    S_Box_32w S_Mod_Four_5 (Temp_Expanded_Key[12][31:0], temp_val_four[5][31:0]);
    
  
    always@(posedge CLK, posedge RESET) begin: main_module //Pulling in new Data or asynchronous RESET 
    
    
        if (RESET) begin: pull_data // RESET and initialize circuit.
    
            
            current_round_val[31:24] <= Key[23:16];
            current_round_val[23:16] <= Key[15:8];
            current_round_val[15:8] <= Key[7:0];
            current_round_val[7:0] <= Key[31:24];           
        
            trigger <= 0;
            rcon_count <= 7; 
            Key_State <= Sub;
            XOR_count <= 0;
            Key_count <= 2;
            Temp_Expanded_Key[1][127:0] <= Key[127:0]; 
            Temp_Expanded_Key[0][127:0] <= Key[255:128];
            Word_Select <= 3; 
            
        
            for (i=2; i < 15; i = i + 1) begin
        
                Temp_Expanded_Key[i][127:0] <= 0;
        
            end
        
    
        end: pull_data
        
        else begin: expand_key
   
                
           if (Key_count < 15) begin: key_loop 
               
              trigger <= 1; 
 
               
              if (XOR_count == 0) begin: Mod_Eight_Zero
    
                  case(Key_State)  
                  
                        Rotate_Left: begin
                                                                               
                            current_round_val[31:24] <= Temp_Expanded_Key[Key_count - 1][23:16];
                            current_round_val[23:16] <= Temp_Expanded_Key[Key_count - 1][15:8];
                            current_round_val[15:8] <= Temp_Expanded_Key[Key_count - 1][7:0];
                            current_round_val[7:0] <= Temp_Expanded_Key[Key_count - 1][31:24];
                                
                            Key_State <= Sub;
                  
                        end
                  
                        Sub: begin 
                                                      
                            current_round_val <= temp_val_zero;
                            
                            Key_State <= XOR_w_prev;
                      
                        end
    
                        XOR_w_prev: begin
                                         
                            
                            Temp_Expanded_Key[Key_count][127:96] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ current_round_val ^ rcon[rcon_count*32 - 1 -: 32];   //can re-use this register?         
                            rcon_count <= rcon_count - 1;
                            XOR_count <= XOR_count + 1;                                                             
                            Key_State <= Sub; //?
                            Word_Select <= Word_Select - 1;
                            
                         end
                                  
                 endcase
                 
              end: Mod_Eight_Zero 
                        
              
              else if (XOR_count == 4) begin: Mod_Eight_Four
              
                  case(Key_State) 
                  
                        Sub: begin 
                   
                            //S_Box_32w  S_Mod_Four (Temp_Expanded_Key[Key_count - 1][127:96], current_round_val);
                            case(7 - rcon_count)
                            
                               3'b001:                      
                                  current_round_val <= temp_val_four[0];
                      
                               3'b010:                             
                                  current_round_val <= temp_val_four[1];

                               3'b011:                             
                                  current_round_val <= temp_val_four[2];
                                 
                               3'b100:                             
                                  current_round_val <= temp_val_four[3];                                

                               3'b101:                             
                                  current_round_val <= temp_val_four[4];
                                 
                               3'b110:                            
                                  current_round_val <= temp_val_four[5];

                           //    3'b111:                            
                             //     current_round_val <= temp_val_four[6];
                                                                                    
                             endcase
                           
                             Key_State <= XOR_w_prev;
                      
                        end
                        
                        XOR_w_prev: begin
                                                              
                            Temp_Expanded_Key[Key_count][127:96] <= Temp_Expanded_Key[Key_count - 2][127:96] ^ current_round_val;  
                                   
                            XOR_count <= XOR_count + 1;
                            Key_State <= Rotate_Left;
                            Word_Select <= Word_Select - 1;                                                             
                            
                            
                         end
                        
                  endcase
                
              end: Mod_Eight_Four     
              
              else begin: XOR_Word
              
                   if (XOR_count == 3 ) begin
                   
                       Key_count <= Key_count + 1;
                       XOR_count <= XOR_count + 1;
                       Upper_XOR <= 1; 
                  
                   end
                  
                   if (XOR_count == 7) begin
                   
                       Key_count <= Key_count + 1; 
                       XOR_count <= 0;
                       Upper_XOR <= 0;
                       
                   end   
                       
                   else begin
                    
                    XOR_count <= XOR_count + 1;  
                    
                   end
                   
                Temp_Expanded_Key[Key_count][(Word_Select + 1)*32 - 1 -: 32] <= Temp_Expanded_Key[Key_count - 2][(Word_Select+1)*32 - 1 -: 32] ^ Temp_Expanded_Key[Key_count][(Word_Select + 2)*32 - 1 -: 32];
                Word_Select <= Word_Select - 1;    
                       
              end: XOR_Word
                 
           end: key_loop
                     
        end: expand_key     
             
    end: main_module

vio_0 my_Reset (
  .clk(CLK),                // input wire clk
  .probe_out0(RESET)  // output wire [0 : 0] probe_out0
);


ila_0 my_ILA (
	.clk(CLK), // input wire clk

	.trig_in(trigger),// input wire trig_in 
	//.trig_in_ack(trig_in_ack),// output wire trig_in_ack 
	.probe0(Key), // input wire [255:0]  probe0  
	.probe1(Temp_Expanded_Key[0]), // input wire [127:0]  probe1 
	.probe2(Temp_Expanded_Key[1]), // input wire [127:0]  probe2 
	.probe3(Temp_Expanded_Key[2]), // input wire [127:0]  probe3 
	.probe4(Temp_Expanded_Key[3]), // input wire [127:0]  probe4 
	.probe5(Temp_Expanded_Key[4]), // input wire [127:0]  probe5 
	.probe6(Temp_Expanded_Key[5]), // input wire [127:0]  probe6 
	.probe7(Temp_Expanded_Key[6]), // input wire [127:0]  probe7 
	.probe8(Temp_Expanded_Key[7]), // input wire [127:0]  probe8 
	.probe9(Temp_Expanded_Key[8]), // input wire [127:0]  probe9 
	.probe10(Temp_Expanded_Key[9]), // input wire [127:0]  probe10 
	.probe11(Temp_Expanded_Key[10]), // input wire [127:0]  probe11 
	.probe12(Temp_Expanded_Key[11]), // input wire [127:0]  probe12 
	.probe13(Temp_Expanded_Key[12]), // input wire [127:0]  probe13 
	.probe14(Temp_Expanded_Key[13]), // input wire [127:0]  probe14 
	.probe15(Temp_Expanded_Key[14]), // input wire [127:0]  probe15 
	.probe16(Temp_Expanded_Key[15]), // input wire [127:0]  probe16 
	.probe17(current_round_val), // input wire [31:0]  probe17 
	.probe18(Key_count), // input wire [4:0]  probe18 
	.probe19(XOR_count), // input wire [2:0]  probe19 
	.probe20(rcon_count), // input wire [2:0]  probe20 
	.probe21(Key_State), // input wire [1:0]  probe21 
	.probe22(Upper_XOR), // input wire [0:0]  probe22
	.probe23(rcon[rcon_count*32 - 1 -: 32]), // input wire [31:0]  probe23 
	.probe24(temp_val_zero), // input wire [31:0]  probe24
	.probe25(Word_Select) // input wire [1:0]  probe25
);

  clk_wiz_0 my_Clock
   (
    // Clock out ports
    .clk_out1(CLK),     // output clk_out1
    // Status and control signals
    .reset(1'b0), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1_p(CLK_P),    // input clk_in1_p
    .clk_in1_n(CLK_N));    // input clk_in1_n
    
endmodule




