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

// Max's version
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

/*
module AES_256_Top_Module(
    input CLK,

    // Key Expansion
    input [255:0] Key, // 8 regs
    input [1:0] Key_Start_Combined, // 1 reg
    output [1:0] Key_Finish_Combined, // 1 reg
    // 00 --> No_Round_Keys; 01 --> Encryption_Only_Key_Ready; 10 ---> Decrytpion_Only_Key_Ready; 11 --> Encryption & Decryption Ready; 
    input [1:0] Core_Select, // 1 Reg
    //00--> Idle 01 --> Encryption; 10 --> Decryption; 11 --> ??? 
    // 11 Regs required

    // Encryption ports and control
    input [127:0] Plaintext_In, // 4 Regs
    input Enc_Start, // 1 Reg
    output Enc_Fin, // 1 Reg
    output [127:0] Ciphertext_Out, // 4 Regs
    // 10 Regs required

    // Decryption ports and control
    input [127:0] Ciphertext_In, // 4 regs
    input Dec_Start, // 1 reg
    output Dec_Fin, // 1 reg
    output [127:0] Plaintext_Out // 4 regs
    // 10 Regs Required

    // Total AXI regs required: 31
    );
    
    
    localparam Idle = 2'b00, Gen_Encrypt_Key = 2'b01, Gen_Decrypt_Key = 2'b10, Encrypt_Decrypt = 2'b11;  
         
    localparam Start_Key_Gen = 2'b01,  Wait_Key_Gen= 2'b10, Ready_Key = 2'b11;  
 
 
    wire [127:0] Round_Key_Wire [12:0];
    reg [127:0] Round_Key_Reg_Decryption [14:0];
    reg [127:0] Round_Key_Reg_Encryption [14:0];
    
    reg Encrypt_Key_Ready;
    reg Decrypt_Key_Ready;
    reg Key_Start;
    wire Key_Finish;
    reg [1:0] Key_State;
    
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
     
      
      always@(posedge CLK) begin: Key_Gen_FSM
      
            case(Core_Select) 
            
                Idle: begin
              
                   Key_State <= Idle;
                    
                end
                      
                Gen_Encrypt_Key: begin
                                                                                   
                   case(Key_State)  
                                      
                        Idle: begin
                        
                            if (Key_Start_Combined[0]) begin
                
                                 Encrypt_Key_Ready <= 0; 
                                 Key_Start <= 1;
                                 Key_State <= Start_Key_Gen;
                        
                            end
                        
                        end
                                              
                        Start_Key_Gen: begin
                        
                            Key_Start <= 0;
                            Key_State <= Wait_Key_Gen; 
                        
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
                        
                            if (Key_Start_Combined[1]) begin
                
                                 Decrypt_Key_Ready <= 0; 
                                 Key_Start <= 1;
                                 Key_State <= Start_Key_Gen;
                        
                            end
                        
                        end
                                              
                        Start_Key_Gen: begin
                        
                            Key_Start <= 0;
                            Key_State <= Wait_Key_Gen; 
                        
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
    Encryption_Core Cipher(
       .CLK(CLK),
       .start(Enc_Start),
       .Plaintext(Plaintext_In),
       .in_key0     (Round_Key_Reg_Encryption[0]),
       .in_key1     (Round_Key_Reg_Encryption[1]),
       .in_key2     (Round_Key_Reg_Encryption[2]),
       .in_key3     (Round_Key_Reg_Encryption[3]),
       .in_key4     (Round_Key_Reg_Encryption[4]),
       .in_key5     (Round_Key_Reg_Encryption[5]),
       .in_key6     (Round_Key_Reg_Encryption[6]),
       .in_key7     (Round_Key_Reg_Encryption[7]),
       .in_key8     (Round_Key_Reg_Encryption[8]),
       .in_key9     (Round_Key_Reg_Encryption[9]),
       .in_key10    (Round_Key_Reg_Encryption[10]),
       .in_key11    (Round_Key_Reg_Encryption[11]),
       .in_key12    (Round_Key_Reg_Encryption[12]),
       .in_key13    (Round_Key_Reg_Encryption[13]),
       .in_key14    (Round_Key_Reg_Encryption[14]),
       .Ciphertext(Ciphertext_Out),
       .finished(Enc_Fin) 
        
    );
    
    
    // Decryption Core
    Decryption_Core InvCipher(
    
       .CLK(CLK),
       .start(Dec_Start),
       .Ciphertext(Ciphertext_In),
       .in_key0     (Round_Key_Reg_Decryption[0]),
       .in_key1     (Round_Key_Reg_Decryption[1]),
       .in_key2     (Round_Key_Reg_Decryption[2]),
       .in_key3     (Round_Key_Reg_Decryption[3]),
       .in_key4     (Round_Key_Reg_Decryption[4]),
       .in_key5     (Round_Key_Reg_Decryption[5]),
       .in_key6     (Round_Key_Reg_Decryption[6]),
       .in_key7     (Round_Key_Reg_Decryption[7]),
       .in_key8     (Round_Key_Reg_Decryption[8]),
       .in_key9     (Round_Key_Reg_Decryption[9]),
       .in_key10    (Round_Key_Reg_Decryption[10]),
       .in_key11    (Round_Key_Reg_Decryption[11]),
       .in_key12    (Round_Key_Reg_Decryption[12]),
       .in_key13    (Round_Key_Reg_Decryption[13]),
       .in_key14    (Round_Key_Reg_Decryption[14]),
       .Plaintext(Plaintext_Out),
       .finished(Dec_Fin) 
    
    );
    
endmodule
*/


// Matt's version

module AES_256_Top_Module(
    input CLK,
    input [255:0] Key,
    input Key_Select, // selects where to write new generated key to 0=encryption 1=decryption.
    input Key_Start, // start key expansion
    output Key_Finish,
    
    input [127:0] Plaintext_In,
    input Enc_Start, // control signal for encryption
    output Enc_Fin, // finished bit for encryption
    output [127:0] Ciphertext_Out,
    
    input [127:0] Ciphertext_In,
    input Dec_Start, // control reg for decryption
    output Dec_Fin, // finished bit for decryption
    output [127:0] Plaintext_Out
    );
    


    // Key_Expansion
    wire [127:0] keyexp_out [14:0];

    assign keyexp_out[0] = Key[255:128];
    assign keyexp_out[1] = Key[127:0];

    Key_Expansion KeyExpansion(
        .RESET                  (Key_Start),
        .CLK                    (CLK),
        .Key                    (Key),
        .Expanded_Key_One       (keyexp_out[2] ), 
        .Expanded_Key_Two       (keyexp_out[3] ), 
        .Expanded_Key_Three     (keyexp_out[4] ), 
        .Expanded_Key_Four      (keyexp_out[5] ), 
        .Expanded_Key_Five      (keyexp_out[6] ), 
        .Expanded_Key_Six       (keyexp_out[7] ),
        .Expanded_Key_Seven     (keyexp_out[8] ),
        .Expanded_Key_Eight     (keyexp_out[9] ),
        .Expanded_Key_Nine      (keyexp_out[10]), 
        .Expanded_Key_Ten       (keyexp_out[11]),
        .Expanded_Key_Eleven    (keyexp_out[12]), 
        .Expanded_Key_Twelve    (keyexp_out[13]),
        .Expanded_Key_Thirteen  (keyexp_out[14]), 
        .Done                   (Key_Finish)                            
        );
    

    // Key Select Circuitry
    wire [127:0] enc_key_demuxout [14:0];
    wire [127:0] dec_key_demuxout [14:0];

    Key_Demux Demux(
        .Demux_Select(Key_Select),

        .in_key0 (keyexp_out[0 ]),
        .in_key1 (keyexp_out[1 ]),
        .in_key2 (keyexp_out[2 ]),
        .in_key3 (keyexp_out[3 ]),
        .in_key4 (keyexp_out[4 ]),
        .in_key5 (keyexp_out[5 ]),
        .in_key6 (keyexp_out[6 ]),
        .in_key7 (keyexp_out[7 ]),
        .in_key8 (keyexp_out[8 ]),
        .in_key9 (keyexp_out[9 ]),
        .in_key10(keyexp_out[10]),
        .in_key11(keyexp_out[11]),
        .in_key12(keyexp_out[12]),
        .in_key13(keyexp_out[13]),
        .in_key14(keyexp_out[14]),

        .sel0_key0 (enc_key_demuxout[0 ]),
        .sel0_key1 (enc_key_demuxout[1 ]),
        .sel0_key2 (enc_key_demuxout[2 ]),
        .sel0_key3 (enc_key_demuxout[3 ]),
        .sel0_key4 (enc_key_demuxout[4 ]),
        .sel0_key5 (enc_key_demuxout[5 ]),
        .sel0_key6 (enc_key_demuxout[6 ]),
        .sel0_key7 (enc_key_demuxout[7 ]),
        .sel0_key8 (enc_key_demuxout[8 ]),
        .sel0_key9 (enc_key_demuxout[9 ]),
        .sel0_key10(enc_key_demuxout[10]),
        .sel0_key11(enc_key_demuxout[11]),
        .sel0_key12(enc_key_demuxout[12]),
        .sel0_key13(enc_key_demuxout[13]),
        .sel0_key14(enc_key_demuxout[14]),

        .sel1_key0 (dec_key_demuxout[0 ]),
        .sel1_key1 (dec_key_demuxout[1 ]),
        .sel1_key2 (dec_key_demuxout[2 ]),
        .sel1_key3 (dec_key_demuxout[3 ]),
        .sel1_key4 (dec_key_demuxout[4 ]),
        .sel1_key5 (dec_key_demuxout[5 ]),
        .sel1_key6 (dec_key_demuxout[6 ]),
        .sel1_key7 (dec_key_demuxout[7 ]),
        .sel1_key8 (dec_key_demuxout[8 ]),
        .sel1_key9 (dec_key_demuxout[9 ]),
        .sel1_key10(dec_key_demuxout[10]),
        .sel1_key11(dec_key_demuxout[11]),
        .sel1_key12(dec_key_demuxout[12]),
        .sel1_key13(dec_key_demuxout[13]),
        .sel1_key14(dec_key_demuxout[14])

        );    
    // Encryption Core
    reg [127:0] enc_key_in [14:0];

    Encryption_Core Cipher(
        .CLK                (CLK),
        .start              (Enc_Start),
        .Plaintext          (Plaintext_In),
        .in_key0            (enc_key_in[0] ),
        .in_key1            (enc_key_in[1] ),
        .in_key2            (enc_key_in[2] ),
        .in_key3            (enc_key_in[3] ),
        .in_key4            (enc_key_in[4] ),
        .in_key5            (enc_key_in[5] ),
        .in_key6            (enc_key_in[6] ),
        .in_key7            (enc_key_in[7] ),
        .in_key8            (enc_key_in[8] ),
        .in_key9            (enc_key_in[9] ),
        .in_key10           (enc_key_in[10]),
        .in_key11           (enc_key_in[11]),
        .in_key12           (enc_key_in[12]),
        .in_key13           (enc_key_in[13]),
        .in_key14           (enc_key_in[14]),
        .Ciphertext         (Ciphertext_Out),
        .finished           (Enc_Fin)
        );
    // Decryption Core
    reg [127:0] dec_key_in [14:0];

    Decryption_Core InvCipher(
        .CLK                (CLK),
        .start              (Dec_Start),
        .Ciphertext         (Ciphertext_In),
        .in_key0            (dec_key_in[0] ),
        .in_key1            (dec_key_in[1] ),
        .in_key2            (dec_key_in[2] ),
        .in_key3            (dec_key_in[3] ),
        .in_key4            (dec_key_in[4] ),
        .in_key5            (dec_key_in[5] ),
        .in_key6            (dec_key_in[6] ),
        .in_key7            (dec_key_in[7] ),
        .in_key8            (dec_key_in[8] ),
        .in_key9            (dec_key_in[9] ),
        .in_key10           (dec_key_in[10]),
        .in_key11           (dec_key_in[11]),
        .in_key12           (dec_key_in[12]),
        .in_key13           (dec_key_in[13]),
        .in_key14           (dec_key_in[14]),
        .Plaintext          (Plaintext_Out),
        .finished           (Dec_Fin)
        );
    

    always @(*) begin
        enc_key_in[0]  <= enc_key_demuxout[0] ;
        enc_key_in[1]  <= enc_key_demuxout[1] ;
        enc_key_in[2]  <= enc_key_demuxout[2] ;
        enc_key_in[3]  <= enc_key_demuxout[3] ;
        enc_key_in[4]  <= enc_key_demuxout[4] ;
        enc_key_in[5]  <= enc_key_demuxout[5] ;
        enc_key_in[6]  <= enc_key_demuxout[6] ;
        enc_key_in[7]  <= enc_key_demuxout[7] ;
        enc_key_in[8]  <= enc_key_demuxout[8] ;
        enc_key_in[9]  <= enc_key_demuxout[9] ;
        enc_key_in[10] <= enc_key_demuxout[10];
        enc_key_in[11] <= enc_key_demuxout[11];
        enc_key_in[12] <= enc_key_demuxout[12];
        enc_key_in[13] <= enc_key_demuxout[13];
        enc_key_in[14] <= enc_key_demuxout[14];

        dec_key_in[0]  <= dec_key_demuxout[0] ;
        dec_key_in[1]  <= dec_key_demuxout[1] ;
        dec_key_in[2]  <= dec_key_demuxout[2] ;
        dec_key_in[3]  <= dec_key_demuxout[3] ;
        dec_key_in[4]  <= dec_key_demuxout[4] ;
        dec_key_in[5]  <= dec_key_demuxout[5] ;
        dec_key_in[6]  <= dec_key_demuxout[6] ;
        dec_key_in[7]  <= dec_key_demuxout[7] ;
        dec_key_in[8]  <= dec_key_demuxout[8] ;
        dec_key_in[9]  <= dec_key_demuxout[9] ;
        dec_key_in[10] <= dec_key_demuxout[10];
        dec_key_in[11] <= dec_key_demuxout[11];
        dec_key_in[12] <= dec_key_demuxout[12];
        dec_key_in[13] <= dec_key_demuxout[13];
        dec_key_in[14] <= dec_key_demuxout[14];

    end




endmodule


module Key_Demux(
    input Demux_Select,
    
    input [127:0] in_key0 ,
    input [127:0] in_key1 ,
    input [127:0] in_key2 ,
    input [127:0] in_key3 ,
    input [127:0] in_key4 ,
    input [127:0] in_key5 ,
    input [127:0] in_key6 ,
    input [127:0] in_key7 ,
    input [127:0] in_key8 ,
    input [127:0] in_key9 ,
    input [127:0] in_key10,
    input [127:0] in_key11,
    input [127:0] in_key12,
    input [127:0] in_key13,
    input [127:0] in_key14,

    output reg [127:0] sel0_key0 ,
    output reg [127:0] sel0_key1 ,
    output reg [127:0] sel0_key2 ,
    output reg [127:0] sel0_key3 ,
    output reg [127:0] sel0_key4 ,
    output reg [127:0] sel0_key5 ,
    output reg [127:0] sel0_key6 ,
    output reg [127:0] sel0_key7 ,
    output reg [127:0] sel0_key8 ,
    output reg [127:0] sel0_key9 ,
    output reg [127:0] sel0_key10,
    output reg [127:0] sel0_key11,
    output reg [127:0] sel0_key12,
    output reg [127:0] sel0_key13,
    output reg [127:0] sel0_key14,

    output reg [127:0] sel1_key0 ,
    output reg [127:0] sel1_key1 ,
    output reg [127:0] sel1_key2 ,
    output reg [127:0] sel1_key3 ,
    output reg [127:0] sel1_key4 ,
    output reg [127:0] sel1_key5 ,
    output reg [127:0] sel1_key6 ,
    output reg [127:0] sel1_key7 ,
    output reg [127:0] sel1_key8 ,
    output reg [127:0] sel1_key9 ,
    output reg [127:0] sel1_key10,
    output reg [127:0] sel1_key11,
    output reg [127:0] sel1_key12,
    output reg [127:0] sel1_key13,
    output reg [127:0] sel1_key14

    );

    always @(*) begin

        case (Demux_Select)
            1'b0 : begin
                sel0_key0  <= in_key0 ;
                sel0_key1  <= in_key1 ;
                sel0_key2  <= in_key2 ;
                sel0_key3  <= in_key3 ;
                sel0_key4  <= in_key4 ;
                sel0_key5  <= in_key5 ;
                sel0_key6  <= in_key6 ;
                sel0_key7  <= in_key7 ;
                sel0_key8  <= in_key8 ;
                sel0_key9  <= in_key9 ;
                sel0_key10 <= in_key10;
                sel0_key11 <= in_key11;
                sel0_key12 <= in_key12;
                sel0_key13 <= in_key13;
                sel0_key14 <= in_key14;

                sel1_key0  <= sel1_key0 ;
                sel1_key1  <= sel1_key1 ;
                sel1_key2  <= sel1_key2 ;
                sel1_key3  <= sel1_key3 ;
                sel1_key4  <= sel1_key4 ;
                sel1_key5  <= sel1_key5 ;
                sel1_key6  <= sel1_key6 ;
                sel1_key7  <= sel1_key7 ;
                sel1_key8  <= sel1_key8 ;
                sel1_key9  <= sel1_key9 ;
                sel1_key10 <= sel1_key10;
                sel1_key11 <= sel1_key11;
                sel1_key12 <= sel1_key12;
                sel1_key13 <= sel1_key13;
                sel1_key14 <= sel1_key14;
            end

            1'b1 : begin
                sel1_key0  <= in_key0 ;
                sel1_key1  <= in_key1 ;
                sel1_key2  <= in_key2 ;
                sel1_key3  <= in_key3 ;
                sel1_key4  <= in_key4 ;
                sel1_key5  <= in_key5 ;
                sel1_key6  <= in_key6 ;
                sel1_key7  <= in_key7 ;
                sel1_key8  <= in_key8 ;
                sel1_key9  <= in_key9 ;
                sel1_key10 <= in_key10;
                sel1_key11 <= in_key11;
                sel1_key12 <= in_key12;
                sel1_key13 <= in_key13;
                sel1_key14 <= in_key14;

                sel0_key0  <= sel0_key0 ;
                sel0_key1  <= sel0_key1 ;
                sel0_key2  <= sel0_key2 ;
                sel0_key3  <= sel0_key3 ;
                sel0_key4  <= sel0_key4 ;
                sel0_key5  <= sel0_key5 ;
                sel0_key6  <= sel0_key6 ;
                sel0_key7  <= sel0_key7 ;
                sel0_key8  <= sel0_key8 ;
                sel0_key9  <= sel0_key9 ;
                sel0_key10 <= sel0_key10;
                sel0_key11 <= sel0_key11;
                sel0_key12 <= sel0_key12;
                sel0_key13 <= sel0_key13;
                sel0_key14 <= sel0_key14;

            end

        endcase

    end

endmodule