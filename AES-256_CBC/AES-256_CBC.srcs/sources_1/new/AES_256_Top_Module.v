`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2023 04:47:58 PM
// Design Name: 
// Module Name: AES_256_Top_Module
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


module AES_256_Top_Module(
    input CLK,
    input [255:0] Key,
    input Key_Start,
    output [1:0] Key_Finish_Combined, 
    // 00 --> No_Round_Keys; 01 --> Encryption_Only_Key_Ready; 10 ---> Decrytpion_Only_Key_Ready; 11 --> Encryption & Decryption Ready; 
    
    input Core_Select,   //0 --> Encryption; 1 --> Decryption; 
    
    input [127:0] Plaintext_In,
    input Enc_Start,
    output Enc_Fin,
    output [127:0] Ciphertext_Out,
    
    input [127:0] Ciphertext_In,
    input Dec_Start,
    output Dec_Fin,
    output [127:0] Plaintext_Out
    );
    
    
   localparam Gen_Encrypt_Key = 1'b0, Gen_Decrypt_Key = 1'b1;

    
 //   localparam Idle = 2'b00, Gen_Encrypt_Key = 2'b01, Gen_Decrypt_Key = 2'b10, Encrypt_Decrypt = 2'b11;  
         
    localparam Idle = 1'b0,  Wait_Key_Gen= 1'b1;  
 
 
    wire [127:0] Round_Key_Wire [12:0]; //reg or wire?
    reg [127:0] Round_Key_Reg_Decryption [14:0];
    reg [127:0] Round_Key_Reg_Encryption [14:0];
    
    reg Encrypt_Key_Ready;
    reg Decrypt_Key_Ready;
   // reg Key_Start;
    wire Key_Finish;
    reg  Key_State;
    
    assign Key_Finish_Combined[0] = Encrypt_Key_Ready;
    assign Key_Finish_Combined[1] = Decrypt_Key_Ready; 
    
   
       
  
    // Key_Expansion
    Key_Expansion KeyExpansion(
      .RESET(Key_Start),
      .CLK(CLK),
      .Key(Key),
      .Expanded_Key_One(Round_Key_Wire[0]),
      .Expanded_Key_Two(Round_Key_Wire[1]),
      .Expanded_Key_Three(Round_Key_Wire[2]),
      .Expanded_Key_Four(Round_Key_Wire[3]), 
      .Expanded_Key_Five(Round_Key_Wire[4]),
      .Expanded_Key_Six(Round_Key_Wire[5]),
      .Expanded_Key_Seven(Round_Key_Wire[6]),
      .Expanded_Key_Eight(Round_Key_Wire[7]),
      .Expanded_Key_Nine(Round_Key_Wire[8]),
      .Expanded_Key_Ten(Round_Key_Wire[9]),
      .Expanded_Key_Eleven(Round_Key_Wire[10]),
      .Expanded_Key_Twelve(Round_Key_Wire[11]),
      .Expanded_Key_Thirteen(Round_Key_Wire[12]),
      .Done(Key_Finish)    
     ); 
     
      
//      always@(posedge CLK) begin: Key_Gen_FSM
      
//            case(Core_Select) 
            
//                Idle: begin
              
//                   Key_State <= Idle;
                    
//                end
                      
//                Gen_Encrypt_Key: begin
                                                                                   
//                   case(Key_State)  
                                      
//                        Idle: begin
                        
//                            if (Key_Start_Combined[0]) begin
                
//                                 Encrypt_Key_Ready <= 0; 
//                                 Key_Start <= 1;
//                                 Key_State <= Start_Key_Gen;
                        
//                            end
                        
//                        end
                                              
//                        Start_Key_Gen: begin
                        
//                            Key_Start <= 0;
//                            Key_State <= Wait_Key_Gen; 
                        
//                        end
                         
//                        Wait_Key_Gen: begin 
                         
//                            if (Key_Finish) begin
                            
//                                Key_State <= Idle;
//                                Encrypt_Key_Ready <=1; 
           
//                                Round_Key_Reg_Encryption[0] <= Key[255:128];
//                                Round_Key_Reg_Encryption[1] <= Key[127:0];
//                                Round_Key_Reg_Encryption[2] <= Round_Key_Wire[0];
//                                Round_Key_Reg_Encryption[3] <= Round_Key_Wire[1];
//                                Round_Key_Reg_Encryption[4] <= Round_Key_Wire[2];
//                                Round_Key_Reg_Encryption[5] <= Round_Key_Wire[3];
//                                Round_Key_Reg_Encryption[6] <= Round_Key_Wire[4];
//                                Round_Key_Reg_Encryption[7] <= Round_Key_Wire[5];
//                                Round_Key_Reg_Encryption[8] <= Round_Key_Wire[6];
//                                Round_Key_Reg_Encryption[9] <= Round_Key_Wire[7];
//                                Round_Key_Reg_Encryption[10] <= Round_Key_Wire[8];
//                                Round_Key_Reg_Encryption[11] <= Round_Key_Wire[9];
//                                Round_Key_Reg_Encryption[12] <= Round_Key_Wire[10];
//                                Round_Key_Reg_Encryption[13] <= Round_Key_Wire[11];
//                                Round_Key_Reg_Encryption[14] <= Round_Key_Wire[12]; 
                                                       
//                            end
                    
//                        end
                    
//                   endcase      
   
//                end            
                      
//                Gen_Decrypt_Key: begin
      
//                   case(Key_State)  
                                      
//                        Idle: begin
                        
//                            if (Key_Start_Combined[1]) begin
                
//                                 Decrypt_Key_Ready <= 0; 
//                                 Key_Start <= 1;
//                                 Key_State <= Start_Key_Gen;
                        
//                            end
                        
//                        end
                                              
//                        Start_Key_Gen: begin
                        
//                            Key_Start <= 0;
//                            Key_State <= Wait_Key_Gen; 
                        
//                        end
                         
//                        Wait_Key_Gen: begin 
                         
//                            if (Key_Finish) begin
                            
//                                Key_State <= Idle;
//                                Decrypt_Key_Ready <=1; 
           
//                                Round_Key_Reg_Decryption[0] <= Key[255:128];
//                                Round_Key_Reg_Decryption[1] <= Key[127:0];
//                                Round_Key_Reg_Decryption[2] <= Round_Key_Wire[0];
//                                Round_Key_Reg_Decryption[3] <= Round_Key_Wire[1];
//                                Round_Key_Reg_Decryption[4] <= Round_Key_Wire[2];
//                                Round_Key_Reg_Decryption[5] <= Round_Key_Wire[3];
//                                Round_Key_Reg_Decryption[6] <= Round_Key_Wire[4];
//                                Round_Key_Reg_Decryption[7] <= Round_Key_Wire[5];
//                                Round_Key_Reg_Decryption[8] <= Round_Key_Wire[6];
//                                Round_Key_Reg_Decryption[9] <= Round_Key_Wire[7];
//                                Round_Key_Reg_Decryption[10] <= Round_Key_Wire[8];
//                                Round_Key_Reg_Decryption[11] <= Round_Key_Wire[9];
//                                Round_Key_Reg_Decryption[12] <= Round_Key_Wire[10];
//                                Round_Key_Reg_Decryption[13] <= Round_Key_Wire[11];
//                                Round_Key_Reg_Decryption[14] <= Round_Key_Wire[12]; 
                                                       
//                            end
                    
//                        end
                    
//                   endcase      
   
//                end
                          
//            endcase
            
//    end: Key_Gen_FSM
                                
    
//    // Encryption Core
//    Encryption_Core_Standalone Cipher(
//       .CLK(CLK),
//       .start(Enc_Start),
//       .Plaintext(Plaintext_In),
//       .Key_Zero(Round_Key_Reg_Encryption[0]),
//       .Key_One(Round_Key_Reg_Encryption[1]),
//       .Key_Two(Round_Key_Reg_Encryption[2]),
//       .Key_Three(Round_Key_Reg_Encryption[3]),
//       .Key_Four(Round_Key_Reg_Encryption[4]),
//       .Key_Five(Round_Key_Reg_Encryption[5]),
//       .Key_Six(Round_Key_Reg_Encryption[6]),
//       .Key_Seven(Round_Key_Reg_Encryption[7]),
//       .Key_Eight(Round_Key_Reg_Encryption[8]),
//       .Key_Nine(Round_Key_Reg_Encryption[9]),
//       .Key_Ten(Round_Key_Reg_Encryption[10]),
//       .Key_Eleven(Round_Key_Reg_Encryption[11]),
//       .Key_Twelve(Round_Key_Reg_Encryption[12]),
//       .Key_Thirteen(Round_Key_Reg_Encryption[13]),
//       .Key_Fourteen(Round_Key_Reg_Encryption[14]),
//       .Ciphertext(Ciphertext_Out),
//       .finished(Enc_Fin) 
        
//    );
    
    
//    // Decryption Core
//    Decryption_Core_Standalone InvCipher(
    
//       .CLK(CLK),
//       .start(Dec_Start),
//       .Ciphertext(Ciphertext_In),
//       .Key_Zero(Round_Key_Reg_Decryption[0]),
//       .Key_One(Round_Key_Reg_Decryption[1]),
//       .Key_Two(Round_Key_Reg_Decryption[2]),
//       .Key_Three(Round_Key_Reg_Decryption[3]),
//       .Key_Four(Round_Key_Reg_Decryption[4]),
//       .Key_Five(Round_Key_Reg_Decryption[5]),
//       .Key_Six(Round_Key_Reg_Decryption[6]),
//       .Key_Seven(Round_Key_Reg_Decryption[7]),
//       .Key_Eight(Round_Key_Reg_Decryption[8]),
//       .Key_Nine(Round_Key_Reg_Decryption[9]),
//       .Key_Ten(Round_Key_Reg_Decryption[10]),
//       .Key_Eleven(Round_Key_Reg_Decryption[11]),
//       .Key_Twelve(Round_Key_Reg_Decryption[12]),
//       .Key_Thirteen(Round_Key_Reg_Decryption[13]),
//       .Key_Fourteen(Round_Key_Reg_Decryption[14]),
//       .Plaintext(Plaintext_Out),
//       .finished(Dec_Fin) 
    
//    );
    
//endmodule


      always@(posedge CLK) begin: Key_Gen_FSM
      
            case(Core_Select) 
                                 
                Gen_Encrypt_Key: begin
                                                                                   
                   case(Key_State)  
                                      
                        Idle: begin
                        
                            if (Key_Start) begin
                
                                 Encrypt_Key_Ready <= 0; 
                                 Key_State <= Wait_Key_Gen;
                        
                            end
                                              
                        end
                         
                        Wait_Key_Gen: begin 
                         
                            if (Key_Finish) begin
                            
                                Key_State <= Idle;
                                Encrypt_Key_Ready <=1; 
           
                                Round_Key_Reg_Encryption[0] <= Key[255:128];
                                Round_Key_Reg_Encryption[1] <= Key[127:0];
                                Round_Key_Reg_Encryption[2] <= Round_Key_Wire[0];
                                Round_Key_Reg_Encryption[3] <= Round_Key_Wire[1];
                                Round_Key_Reg_Encryption[4] <= Round_Key_Wire[2];
                                Round_Key_Reg_Encryption[5] <= Round_Key_Wire[3];
                                Round_Key_Reg_Encryption[6] <= Round_Key_Wire[4];
                                Round_Key_Reg_Encryption[7] <= Round_Key_Wire[5];
                                Round_Key_Reg_Encryption[8] <= Round_Key_Wire[6];
                                Round_Key_Reg_Encryption[9] <= Round_Key_Wire[7];
                                Round_Key_Reg_Encryption[10] <= Round_Key_Wire[8];
                                Round_Key_Reg_Encryption[11] <= Round_Key_Wire[9];
                                Round_Key_Reg_Encryption[12] <= Round_Key_Wire[10];
                                Round_Key_Reg_Encryption[13] <= Round_Key_Wire[11];
                                Round_Key_Reg_Encryption[14] <= Round_Key_Wire[12]; 
                                                       
                            end
                    
                        end
                    
                   endcase      
   
                end            
                      
                Gen_Decrypt_Key: begin
      
                   case(Key_State)  
                                      
                        Idle: begin
                        
                            if (Key_Start) begin
                
                                 Decrypt_Key_Ready <= 0; 
                                 Key_State <= Wait_Key_Gen;
                        
                            end
                        
                        end
                                           
                         
                        Wait_Key_Gen: begin 
                         
                            if (Key_Finish) begin
                            
                                Key_State <= Idle;
                                Decrypt_Key_Ready <=1; 
           
                                Round_Key_Reg_Decryption[0] <= Key[255:128];
                                Round_Key_Reg_Decryption[1] <= Key[127:0];
                                Round_Key_Reg_Decryption[2] <= Round_Key_Wire[0];
                                Round_Key_Reg_Decryption[3] <= Round_Key_Wire[1];
                                Round_Key_Reg_Decryption[4] <= Round_Key_Wire[2];
                                Round_Key_Reg_Decryption[5] <= Round_Key_Wire[3];
                                Round_Key_Reg_Decryption[6] <= Round_Key_Wire[4];
                                Round_Key_Reg_Decryption[7] <= Round_Key_Wire[5];
                                Round_Key_Reg_Decryption[8] <= Round_Key_Wire[6];
                                Round_Key_Reg_Decryption[9] <= Round_Key_Wire[7];
                                Round_Key_Reg_Decryption[10] <= Round_Key_Wire[8];
                                Round_Key_Reg_Decryption[11] <= Round_Key_Wire[9];
                                Round_Key_Reg_Decryption[12] <= Round_Key_Wire[10];
                                Round_Key_Reg_Decryption[13] <= Round_Key_Wire[11];
                                Round_Key_Reg_Decryption[14] <= Round_Key_Wire[12]; 
                                                       
                            end
                    
                        end
                    
                   endcase      
   
                end
                          
            endcase
            
    end: Key_Gen_FSM
                                
    
    // Encryption Core
    Encryption_Core_Standalone Cipher(
       .CLK(CLK),
       .start(Enc_Start),
       .Plaintext(Plaintext_In),
       .Key_Zero(Round_Key_Reg_Encryption[0]),
       .Key_One(Round_Key_Reg_Encryption[1]),
       .Key_Two(Round_Key_Reg_Encryption[2]),
       .Key_Three(Round_Key_Reg_Encryption[3]),
       .Key_Four(Round_Key_Reg_Encryption[4]),
       .Key_Five(Round_Key_Reg_Encryption[5]),
       .Key_Six(Round_Key_Reg_Encryption[6]),
       .Key_Seven(Round_Key_Reg_Encryption[7]),
       .Key_Eight(Round_Key_Reg_Encryption[8]),
       .Key_Nine(Round_Key_Reg_Encryption[9]),
       .Key_Ten(Round_Key_Reg_Encryption[10]),
       .Key_Eleven(Round_Key_Reg_Encryption[11]),
       .Key_Twelve(Round_Key_Reg_Encryption[12]),
       .Key_Thirteen(Round_Key_Reg_Encryption[13]),
       .Key_Fourteen(Round_Key_Reg_Encryption[14]),
       .Ciphertext(Ciphertext_Out),
       .finished(Enc_Fin) 
        
    );
    
    
    // Decryption Core
    Decryption_Core_Standalone InvCipher(
    
       .CLK(CLK),
       .start(Dec_Start),
       .Ciphertext(Ciphertext_In),
       .Key_Zero(Round_Key_Reg_Decryption[0]),
       .Key_One(Round_Key_Reg_Decryption[1]),
       .Key_Two(Round_Key_Reg_Decryption[2]),
       .Key_Three(Round_Key_Reg_Decryption[3]),
       .Key_Four(Round_Key_Reg_Decryption[4]),
       .Key_Five(Round_Key_Reg_Decryption[5]),
       .Key_Six(Round_Key_Reg_Decryption[6]),
       .Key_Seven(Round_Key_Reg_Decryption[7]),
       .Key_Eight(Round_Key_Reg_Decryption[8]),
       .Key_Nine(Round_Key_Reg_Decryption[9]),
       .Key_Ten(Round_Key_Reg_Decryption[10]),
       .Key_Eleven(Round_Key_Reg_Decryption[11]),
       .Key_Twelve(Round_Key_Reg_Decryption[12]),
       .Key_Thirteen(Round_Key_Reg_Decryption[13]),
       .Key_Fourteen(Round_Key_Reg_Decryption[14]),
       .Plaintext(Plaintext_Out),
       .finished(Dec_Fin) 
    
    );
    
endmodule
