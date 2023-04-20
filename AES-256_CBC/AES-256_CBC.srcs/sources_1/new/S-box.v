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
// Revision 0.04 - Created Diverging files for Comp. Field SBox and Predefined SBox
// Revision 0.9  - Synthesized SBox, awaiting for simulation to verify correctness.
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Full_Array_Sbox(
    input [127:0] in_state,
    output reg [127:0] out_state
    );
    
    
    wire [127:0] state;
    
    S_Box_32w SubBytes0(
        .Word_In(in_state[127:96]),
        .Word_Out(state[127:96])
    );
    
    S_Box_32w SubBytes1(
        .Word_In(in_state[95:64]),
        .Word_Out(state[95:64])
    );
    
    S_Box_32w SubBytes2(
        .Word_In(in_state[63:32]),
        .Word_Out(state[63:32])
    );
    
    S_Box_32w SubBytes3(
        .Word_In(in_state[31:0]),
        .Word_Out(state[31:0])
    );
    
    
    always @(*) begin
        out_state = state;
    end
    
    
endmodule

// 32 Bit width SBox (4 Sbox in parallel)
module S_Box_32w(
    input [31:0] Word_In,
    output reg [31:0] Word_Out
    );



    wire [31:0] Word;
    // MSB
    S_Box S_Box3(
        .Byte_In (Word_In[31:24]),
        .Byte_Out(Word[31:24])
    );

    // MSB - 1
    S_Box S_Box2(
        .Byte_In(Word_In[23:16]),
        .Byte_Out(Word[23:16])
    );

    // LSB + 1
    S_Box S_Box1(
        .Byte_In(Word_In[15:8]),
        .Byte_Out(Word[15:8])
    );

    // LSB
    S_Box S_Box0(
        .Byte_In(Word_In[7:0]),
        .Byte_Out(Word[7:0])
    );
    
    always @(*) begin
        Word_Out = Word;
    end

endmodule






module Compact_Array_SBox(
    input [127:0] in_state,
    output reg [127:0] out_state
    );
    
    
    reg [127:0] state;
    
    
    
    integer i; // for loop var
    reg [31:0] Sub_Input;
    wire [31:0] Sub_Output;
    // Intialization of modules
    S_Box_32w SubBytes(
        .Word_In(Sub_Input),
        .Word_Out(Sub_Output)
    );
    
    always @(*) begin
        state = in_state;
        //for(i = 0; i < 4; i = i + 1) begin // need to shift state by 4 times to keep only 1 SBox in use
            Sub_Input = state[31:0];
            state[31:0] = Sub_Output;
            //state = (state << 32) | (state >> 96); // Circular shift left by 32 bits       
        //end
        out_state = state;
    end
    
    
endmodule


// 8 Bit width S_Box using Predfined Look up table combinational
// On XC7Z010 PL w/o BRAM, should be 40 LUT, no FF
// with BRAM, uses 0.5 of a BRAM
// Table courtesy of tinyAES core
module S_Box(
    input [7:0] Byte_In,
    output reg [7:0] Byte_Out
    );
    
    // Combinational, w/o intermediate output register (flip flops)

    always @(Byte_In) begin
        case (Byte_In)
            8'h00: Byte_Out <= 8'h63;
            8'h01: Byte_Out <= 8'h7c;
            8'h02: Byte_Out <= 8'h77;
            8'h03: Byte_Out <= 8'h7b;
            8'h04: Byte_Out <= 8'hf2;
            8'h05: Byte_Out <= 8'h6b;
            8'h06: Byte_Out <= 8'h6f;
            8'h07: Byte_Out <= 8'hc5;
            8'h08: Byte_Out <= 8'h30;
            8'h09: Byte_Out <= 8'h01;
            8'h0a: Byte_Out <= 8'h67;
            8'h0b: Byte_Out <= 8'h2b;
            8'h0c: Byte_Out <= 8'hfe;
            8'h0d: Byte_Out <= 8'hd7;
            8'h0e: Byte_Out <= 8'hab;
            8'h0f: Byte_Out <= 8'h76;
            8'h10: Byte_Out <= 8'hca;
            8'h11: Byte_Out <= 8'h82;
            8'h12: Byte_Out <= 8'hc9;
            8'h13: Byte_Out <= 8'h7d;
            8'h14: Byte_Out <= 8'hfa;
            8'h15: Byte_Out <= 8'h59;
            8'h16: Byte_Out <= 8'h47;
            8'h17: Byte_Out <= 8'hf0;
            8'h18: Byte_Out <= 8'had;
            8'h19: Byte_Out <= 8'hd4;
            8'h1a: Byte_Out <= 8'ha2;
            8'h1b: Byte_Out <= 8'haf;
            8'h1c: Byte_Out <= 8'h9c;
            8'h1d: Byte_Out <= 8'ha4;
            8'h1e: Byte_Out <= 8'h72;
            8'h1f: Byte_Out <= 8'hc0;
            8'h20: Byte_Out <= 8'hb7;
            8'h21: Byte_Out <= 8'hfd;
            8'h22: Byte_Out <= 8'h93;
            8'h23: Byte_Out <= 8'h26;
            8'h24: Byte_Out <= 8'h36;
            8'h25: Byte_Out <= 8'h3f;
            8'h26: Byte_Out <= 8'hf7;
            8'h27: Byte_Out <= 8'hcc;
            8'h28: Byte_Out <= 8'h34;
            8'h29: Byte_Out <= 8'ha5;
            8'h2a: Byte_Out <= 8'he5;
            8'h2b: Byte_Out <= 8'hf1;
            8'h2c: Byte_Out <= 8'h71;
            8'h2d: Byte_Out <= 8'hd8;
            8'h2e: Byte_Out <= 8'h31;
            8'h2f: Byte_Out <= 8'h15;
            8'h30: Byte_Out <= 8'h04;
            8'h31: Byte_Out <= 8'hc7;
            8'h32: Byte_Out <= 8'h23;
            8'h33: Byte_Out <= 8'hc3;
            8'h34: Byte_Out <= 8'h18;
            8'h35: Byte_Out <= 8'h96;
            8'h36: Byte_Out <= 8'h05;
            8'h37: Byte_Out <= 8'h9a;
            8'h38: Byte_Out <= 8'h07;
            8'h39: Byte_Out <= 8'h12;
            8'h3a: Byte_Out <= 8'h80;
            8'h3b: Byte_Out <= 8'he2;
            8'h3c: Byte_Out <= 8'heb;
            8'h3d: Byte_Out <= 8'h27;
            8'h3e: Byte_Out <= 8'hb2;
            8'h3f: Byte_Out <= 8'h75;
            8'h40: Byte_Out <= 8'h09;
            8'h41: Byte_Out <= 8'h83;
            8'h42: Byte_Out <= 8'h2c;
            8'h43: Byte_Out <= 8'h1a;
            8'h44: Byte_Out <= 8'h1b;
            8'h45: Byte_Out <= 8'h6e;
            8'h46: Byte_Out <= 8'h5a;
            8'h47: Byte_Out <= 8'ha0;
            8'h48: Byte_Out <= 8'h52;
            8'h49: Byte_Out <= 8'h3b;
            8'h4a: Byte_Out <= 8'hd6;
            8'h4b: Byte_Out <= 8'hb3;
            8'h4c: Byte_Out <= 8'h29;
            8'h4d: Byte_Out <= 8'he3;
            8'h4e: Byte_Out <= 8'h2f;
            8'h4f: Byte_Out <= 8'h84;
            8'h50: Byte_Out <= 8'h53;
            8'h51: Byte_Out <= 8'hd1;
            8'h52: Byte_Out <= 8'h00;
            8'h53: Byte_Out <= 8'hed;
            8'h54: Byte_Out <= 8'h20;
            8'h55: Byte_Out <= 8'hfc;
            8'h56: Byte_Out <= 8'hb1;
            8'h57: Byte_Out <= 8'h5b;
            8'h58: Byte_Out <= 8'h6a;
            8'h59: Byte_Out <= 8'hcb;
            8'h5a: Byte_Out <= 8'hbe;
            8'h5b: Byte_Out <= 8'h39;
            8'h5c: Byte_Out <= 8'h4a;
            8'h5d: Byte_Out <= 8'h4c;
            8'h5e: Byte_Out <= 8'h58;
            8'h5f: Byte_Out <= 8'hcf;
            8'h60: Byte_Out <= 8'hd0;
            8'h61: Byte_Out <= 8'hef;
            8'h62: Byte_Out <= 8'haa;
            8'h63: Byte_Out <= 8'hfb;
            8'h64: Byte_Out <= 8'h43;
            8'h65: Byte_Out <= 8'h4d;
            8'h66: Byte_Out <= 8'h33;
            8'h67: Byte_Out <= 8'h85;
            8'h68: Byte_Out <= 8'h45;
            8'h69: Byte_Out <= 8'hf9;
            8'h6a: Byte_Out <= 8'h02;
            8'h6b: Byte_Out <= 8'h7f;
            8'h6c: Byte_Out <= 8'h50;
            8'h6d: Byte_Out <= 8'h3c;
            8'h6e: Byte_Out <= 8'h9f;
            8'h6f: Byte_Out <= 8'ha8;
            8'h70: Byte_Out <= 8'h51;
            8'h71: Byte_Out <= 8'ha3;
            8'h72: Byte_Out <= 8'h40;
            8'h73: Byte_Out <= 8'h8f;
            8'h74: Byte_Out <= 8'h92;
            8'h75: Byte_Out <= 8'h9d;
            8'h76: Byte_Out <= 8'h38;
            8'h77: Byte_Out <= 8'hf5;
            8'h78: Byte_Out <= 8'hbc;
            8'h79: Byte_Out <= 8'hb6;
            8'h7a: Byte_Out <= 8'hda;
            8'h7b: Byte_Out <= 8'h21;
            8'h7c: Byte_Out <= 8'h10;
            8'h7d: Byte_Out <= 8'hff;
            8'h7e: Byte_Out <= 8'hf3;
            8'h7f: Byte_Out <= 8'hd2;
            8'h80: Byte_Out <= 8'hcd;
            8'h81: Byte_Out <= 8'h0c;
            8'h82: Byte_Out <= 8'h13;
            8'h83: Byte_Out <= 8'hec;
            8'h84: Byte_Out <= 8'h5f;
            8'h85: Byte_Out <= 8'h97;
            8'h86: Byte_Out <= 8'h44;
            8'h87: Byte_Out <= 8'h17;
            8'h88: Byte_Out <= 8'hc4;
            8'h89: Byte_Out <= 8'ha7;
            8'h8a: Byte_Out <= 8'h7e;
            8'h8b: Byte_Out <= 8'h3d;
            8'h8c: Byte_Out <= 8'h64;
            8'h8d: Byte_Out <= 8'h5d;
            8'h8e: Byte_Out <= 8'h19;
            8'h8f: Byte_Out <= 8'h73;
            8'h90: Byte_Out <= 8'h60;
            8'h91: Byte_Out <= 8'h81;
            8'h92: Byte_Out <= 8'h4f;
            8'h93: Byte_Out <= 8'hdc;
            8'h94: Byte_Out <= 8'h22;
            8'h95: Byte_Out <= 8'h2a;
            8'h96: Byte_Out <= 8'h90;
            8'h97: Byte_Out <= 8'h88;
            8'h98: Byte_Out <= 8'h46;
            8'h99: Byte_Out <= 8'hee;
            8'h9a: Byte_Out <= 8'hb8;
            8'h9b: Byte_Out <= 8'h14;
            8'h9c: Byte_Out <= 8'hde;
            8'h9d: Byte_Out <= 8'h5e;
            8'h9e: Byte_Out <= 8'h0b;
            8'h9f: Byte_Out <= 8'hdb;
            8'ha0: Byte_Out <= 8'he0;
            8'ha1: Byte_Out <= 8'h32;
            8'ha2: Byte_Out <= 8'h3a;
            8'ha3: Byte_Out <= 8'h0a;
            8'ha4: Byte_Out <= 8'h49;
            8'ha5: Byte_Out <= 8'h06;
            8'ha6: Byte_Out <= 8'h24;
            8'ha7: Byte_Out <= 8'h5c;
            8'ha8: Byte_Out <= 8'hc2;
            8'ha9: Byte_Out <= 8'hd3;
            8'haa: Byte_Out <= 8'hac;
            8'hab: Byte_Out <= 8'h62;
            8'hac: Byte_Out <= 8'h91;
            8'had: Byte_Out <= 8'h95;
            8'hae: Byte_Out <= 8'he4;
            8'haf: Byte_Out <= 8'h79;
            8'hb0: Byte_Out <= 8'he7;
            8'hb1: Byte_Out <= 8'hc8;
            8'hb2: Byte_Out <= 8'h37;
            8'hb3: Byte_Out <= 8'h6d;
            8'hb4: Byte_Out <= 8'h8d;
            8'hb5: Byte_Out <= 8'hd5;
            8'hb6: Byte_Out <= 8'h4e;
            8'hb7: Byte_Out <= 8'ha9;
            8'hb8: Byte_Out <= 8'h6c;
            8'hb9: Byte_Out <= 8'h56;
            8'hba: Byte_Out <= 8'hf4;
            8'hbb: Byte_Out <= 8'hea;
            8'hbc: Byte_Out <= 8'h65;
            8'hbd: Byte_Out <= 8'h7a;
            8'hbe: Byte_Out <= 8'hae;
            8'hbf: Byte_Out <= 8'h08;
            8'hc0: Byte_Out <= 8'hba;
            8'hc1: Byte_Out <= 8'h78;
            8'hc2: Byte_Out <= 8'h25;
            8'hc3: Byte_Out <= 8'h2e;
            8'hc4: Byte_Out <= 8'h1c;
            8'hc5: Byte_Out <= 8'ha6;
            8'hc6: Byte_Out <= 8'hb4;
            8'hc7: Byte_Out <= 8'hc6;
            8'hc8: Byte_Out <= 8'he8;
            8'hc9: Byte_Out <= 8'hdd;
            8'hca: Byte_Out <= 8'h74;
            8'hcb: Byte_Out <= 8'h1f;
            8'hcc: Byte_Out <= 8'h4b;
            8'hcd: Byte_Out <= 8'hbd;
            8'hce: Byte_Out <= 8'h8b;
            8'hcf: Byte_Out <= 8'h8a;
            8'hd0: Byte_Out <= 8'h70;
            8'hd1: Byte_Out <= 8'h3e;
            8'hd2: Byte_Out <= 8'hb5;
            8'hd3: Byte_Out <= 8'h66;
            8'hd4: Byte_Out <= 8'h48;
            8'hd5: Byte_Out <= 8'h03;
            8'hd6: Byte_Out <= 8'hf6;
            8'hd7: Byte_Out <= 8'h0e;
            8'hd8: Byte_Out <= 8'h61;
            8'hd9: Byte_Out <= 8'h35;
            8'hda: Byte_Out <= 8'h57;
            8'hdb: Byte_Out <= 8'hb9;
            8'hdc: Byte_Out <= 8'h86;
            8'hdd: Byte_Out <= 8'hc1;
            8'hde: Byte_Out <= 8'h1d;
            8'hdf: Byte_Out <= 8'h9e;
            8'he0: Byte_Out <= 8'he1;
            8'he1: Byte_Out <= 8'hf8;
            8'he2: Byte_Out <= 8'h98;
            8'he3: Byte_Out <= 8'h11;
            8'he4: Byte_Out <= 8'h69;
            8'he5: Byte_Out <= 8'hd9;
            8'he6: Byte_Out <= 8'h8e;
            8'he7: Byte_Out <= 8'h94;
            8'he8: Byte_Out <= 8'h9b;
            8'he9: Byte_Out <= 8'h1e;
            8'hea: Byte_Out <= 8'h87;
            8'heb: Byte_Out <= 8'he9;
            8'hec: Byte_Out <= 8'hce;
            8'hed: Byte_Out <= 8'h55;
            8'hee: Byte_Out <= 8'h28;
            8'hef: Byte_Out <= 8'hdf;
            8'hf0: Byte_Out <= 8'h8c;
            8'hf1: Byte_Out <= 8'ha1;
            8'hf2: Byte_Out <= 8'h89;
            8'hf3: Byte_Out <= 8'h0d;
            8'hf4: Byte_Out <= 8'hbf;
            8'hf5: Byte_Out <= 8'he6;
            8'hf6: Byte_Out <= 8'h42;
            8'hf7: Byte_Out <= 8'h68;
            8'hf8: Byte_Out <= 8'h41;
            8'hf9: Byte_Out <= 8'h99;
            8'hfa: Byte_Out <= 8'h2d;
            8'hfb: Byte_Out <= 8'h0f;
            8'hfc: Byte_Out <= 8'hb0;
            8'hfd: Byte_Out <= 8'h54;
            8'hfe: Byte_Out <= 8'hbb;
            8'hff: Byte_Out <= 8'h16;
        endcase
    end
        
endmodule

// 8 Bit width S_Box using Predfined Look up table completely combinational
// On XC7Z010 PL w/o BRAM, should be 40 LUT, no FF
// with BRAM, uses 0.5 of a BRAM
// Table courtesy of tinyAES core
module S_Box_Seq(
    input clk, 
    input [7:0] Byte_In,
    output reg [7:0] Byte_Out
    );

    always @(posedge clk) begin
        case (Byte_In)
        8'h00: Byte_Out <= 8'h63;
        8'h01: Byte_Out <= 8'h7c;
        8'h02: Byte_Out <= 8'h77;
        8'h03: Byte_Out <= 8'h7b;
        8'h04: Byte_Out <= 8'hf2;
        8'h05: Byte_Out <= 8'h6b;
        8'h06: Byte_Out <= 8'h6f;
        8'h07: Byte_Out <= 8'hc5;
        8'h08: Byte_Out <= 8'h30;
        8'h09: Byte_Out <= 8'h01;
        8'h0a: Byte_Out <= 8'h67;
        8'h0b: Byte_Out <= 8'h2b;
        8'h0c: Byte_Out <= 8'hfe;
        8'h0d: Byte_Out <= 8'hd7;
        8'h0e: Byte_Out <= 8'hab;
        8'h0f: Byte_Out <= 8'h76;
        8'h10: Byte_Out <= 8'hca;
        8'h11: Byte_Out <= 8'h82;
        8'h12: Byte_Out <= 8'hc9;
        8'h13: Byte_Out <= 8'h7d;
        8'h14: Byte_Out <= 8'hfa;
        8'h15: Byte_Out <= 8'h59;
        8'h16: Byte_Out <= 8'h47;
        8'h17: Byte_Out <= 8'hf0;
        8'h18: Byte_Out <= 8'had;
        8'h19: Byte_Out <= 8'hd4;
        8'h1a: Byte_Out <= 8'ha2;
        8'h1b: Byte_Out <= 8'haf;
        8'h1c: Byte_Out <= 8'h9c;
        8'h1d: Byte_Out <= 8'ha4;
        8'h1e: Byte_Out <= 8'h72;
        8'h1f: Byte_Out <= 8'hc0;
        8'h20: Byte_Out <= 8'hb7;
        8'h21: Byte_Out <= 8'hfd;
        8'h22: Byte_Out <= 8'h93;
        8'h23: Byte_Out <= 8'h26;
        8'h24: Byte_Out <= 8'h36;
        8'h25: Byte_Out <= 8'h3f;
        8'h26: Byte_Out <= 8'hf7;
        8'h27: Byte_Out <= 8'hcc;
        8'h28: Byte_Out <= 8'h34;
        8'h29: Byte_Out <= 8'ha5;
        8'h2a: Byte_Out <= 8'he5;
        8'h2b: Byte_Out <= 8'hf1;
        8'h2c: Byte_Out <= 8'h71;
        8'h2d: Byte_Out <= 8'hd8;
        8'h2e: Byte_Out <= 8'h31;
        8'h2f: Byte_Out <= 8'h15;
        8'h30: Byte_Out <= 8'h04;
        8'h31: Byte_Out <= 8'hc7;
        8'h32: Byte_Out <= 8'h23;
        8'h33: Byte_Out <= 8'hc3;
        8'h34: Byte_Out <= 8'h18;
        8'h35: Byte_Out <= 8'h96;
        8'h36: Byte_Out <= 8'h05;
        8'h37: Byte_Out <= 8'h9a;
        8'h38: Byte_Out <= 8'h07;
        8'h39: Byte_Out <= 8'h12;
        8'h3a: Byte_Out <= 8'h80;
        8'h3b: Byte_Out <= 8'he2;
        8'h3c: Byte_Out <= 8'heb;
        8'h3d: Byte_Out <= 8'h27;
        8'h3e: Byte_Out <= 8'hb2;
        8'h3f: Byte_Out <= 8'h75;
        8'h40: Byte_Out <= 8'h09;
        8'h41: Byte_Out <= 8'h83;
        8'h42: Byte_Out <= 8'h2c;
        8'h43: Byte_Out <= 8'h1a;
        8'h44: Byte_Out <= 8'h1b;
        8'h45: Byte_Out <= 8'h6e;
        8'h46: Byte_Out <= 8'h5a;
        8'h47: Byte_Out <= 8'ha0;
        8'h48: Byte_Out <= 8'h52;
        8'h49: Byte_Out <= 8'h3b;
        8'h4a: Byte_Out <= 8'hd6;
        8'h4b: Byte_Out <= 8'hb3;
        8'h4c: Byte_Out <= 8'h29;
        8'h4d: Byte_Out <= 8'he3;
        8'h4e: Byte_Out <= 8'h2f;
        8'h4f: Byte_Out <= 8'h84;
        8'h50: Byte_Out <= 8'h53;
        8'h51: Byte_Out <= 8'hd1;
        8'h52: Byte_Out <= 8'h00;
        8'h53: Byte_Out <= 8'hed;
        8'h54: Byte_Out <= 8'h20;
        8'h55: Byte_Out <= 8'hfc;
        8'h56: Byte_Out <= 8'hb1;
        8'h57: Byte_Out <= 8'h5b;
        8'h58: Byte_Out <= 8'h6a;
        8'h59: Byte_Out <= 8'hcb;
        8'h5a: Byte_Out <= 8'hbe;
        8'h5b: Byte_Out <= 8'h39;
        8'h5c: Byte_Out <= 8'h4a;
        8'h5d: Byte_Out <= 8'h4c;
        8'h5e: Byte_Out <= 8'h58;
        8'h5f: Byte_Out <= 8'hcf;
        8'h60: Byte_Out <= 8'hd0;
        8'h61: Byte_Out <= 8'hef;
        8'h62: Byte_Out <= 8'haa;
        8'h63: Byte_Out <= 8'hfb;
        8'h64: Byte_Out <= 8'h43;
        8'h65: Byte_Out <= 8'h4d;
        8'h66: Byte_Out <= 8'h33;
        8'h67: Byte_Out <= 8'h85;
        8'h68: Byte_Out <= 8'h45;
        8'h69: Byte_Out <= 8'hf9;
        8'h6a: Byte_Out <= 8'h02;
        8'h6b: Byte_Out <= 8'h7f;
        8'h6c: Byte_Out <= 8'h50;
        8'h6d: Byte_Out <= 8'h3c;
        8'h6e: Byte_Out <= 8'h9f;
        8'h6f: Byte_Out <= 8'ha8;
        8'h70: Byte_Out <= 8'h51;
        8'h71: Byte_Out <= 8'ha3;
        8'h72: Byte_Out <= 8'h40;
        8'h73: Byte_Out <= 8'h8f;
        8'h74: Byte_Out <= 8'h92;
        8'h75: Byte_Out <= 8'h9d;
        8'h76: Byte_Out <= 8'h38;
        8'h77: Byte_Out <= 8'hf5;
        8'h78: Byte_Out <= 8'hbc;
        8'h79: Byte_Out <= 8'hb6;
        8'h7a: Byte_Out <= 8'hda;
        8'h7b: Byte_Out <= 8'h21;
        8'h7c: Byte_Out <= 8'h10;
        8'h7d: Byte_Out <= 8'hff;
        8'h7e: Byte_Out <= 8'hf3;
        8'h7f: Byte_Out <= 8'hd2;
        8'h80: Byte_Out <= 8'hcd;
        8'h81: Byte_Out <= 8'h0c;
        8'h82: Byte_Out <= 8'h13;
        8'h83: Byte_Out <= 8'hec;
        8'h84: Byte_Out <= 8'h5f;
        8'h85: Byte_Out <= 8'h97;
        8'h86: Byte_Out <= 8'h44;
        8'h87: Byte_Out <= 8'h17;
        8'h88: Byte_Out <= 8'hc4;
        8'h89: Byte_Out <= 8'ha7;
        8'h8a: Byte_Out <= 8'h7e;
        8'h8b: Byte_Out <= 8'h3d;
        8'h8c: Byte_Out <= 8'h64;
        8'h8d: Byte_Out <= 8'h5d;
        8'h8e: Byte_Out <= 8'h19;
        8'h8f: Byte_Out <= 8'h73;
        8'h90: Byte_Out <= 8'h60;
        8'h91: Byte_Out <= 8'h81;
        8'h92: Byte_Out <= 8'h4f;
        8'h93: Byte_Out <= 8'hdc;
        8'h94: Byte_Out <= 8'h22;
        8'h95: Byte_Out <= 8'h2a;
        8'h96: Byte_Out <= 8'h90;
        8'h97: Byte_Out <= 8'h88;
        8'h98: Byte_Out <= 8'h46;
        8'h99: Byte_Out <= 8'hee;
        8'h9a: Byte_Out <= 8'hb8;
        8'h9b: Byte_Out <= 8'h14;
        8'h9c: Byte_Out <= 8'hde;
        8'h9d: Byte_Out <= 8'h5e;
        8'h9e: Byte_Out <= 8'h0b;
        8'h9f: Byte_Out <= 8'hdb;
        8'ha0: Byte_Out <= 8'he0;
        8'ha1: Byte_Out <= 8'h32;
        8'ha2: Byte_Out <= 8'h3a;
        8'ha3: Byte_Out <= 8'h0a;
        8'ha4: Byte_Out <= 8'h49;
        8'ha5: Byte_Out <= 8'h06;
        8'ha6: Byte_Out <= 8'h24;
        8'ha7: Byte_Out <= 8'h5c;
        8'ha8: Byte_Out <= 8'hc2;
        8'ha9: Byte_Out <= 8'hd3;
        8'haa: Byte_Out <= 8'hac;
        8'hab: Byte_Out <= 8'h62;
        8'hac: Byte_Out <= 8'h91;
        8'had: Byte_Out <= 8'h95;
        8'hae: Byte_Out <= 8'he4;
        8'haf: Byte_Out <= 8'h79;
        8'hb0: Byte_Out <= 8'he7;
        8'hb1: Byte_Out <= 8'hc8;
        8'hb2: Byte_Out <= 8'h37;
        8'hb3: Byte_Out <= 8'h6d;
        8'hb4: Byte_Out <= 8'h8d;
        8'hb5: Byte_Out <= 8'hd5;
        8'hb6: Byte_Out <= 8'h4e;
        8'hb7: Byte_Out <= 8'ha9;
        8'hb8: Byte_Out <= 8'h6c;
        8'hb9: Byte_Out <= 8'h56;
        8'hba: Byte_Out <= 8'hf4;
        8'hbb: Byte_Out <= 8'hea;
        8'hbc: Byte_Out <= 8'h65;
        8'hbd: Byte_Out <= 8'h7a;
        8'hbe: Byte_Out <= 8'hae;
        8'hbf: Byte_Out <= 8'h08;
        8'hc0: Byte_Out <= 8'hba;
        8'hc1: Byte_Out <= 8'h78;
        8'hc2: Byte_Out <= 8'h25;
        8'hc3: Byte_Out <= 8'h2e;
        8'hc4: Byte_Out <= 8'h1c;
        8'hc5: Byte_Out <= 8'ha6;
        8'hc6: Byte_Out <= 8'hb4;
        8'hc7: Byte_Out <= 8'hc6;
        8'hc8: Byte_Out <= 8'he8;
        8'hc9: Byte_Out <= 8'hdd;
        8'hca: Byte_Out <= 8'h74;
        8'hcb: Byte_Out <= 8'h1f;
        8'hcc: Byte_Out <= 8'h4b;
        8'hcd: Byte_Out <= 8'hbd;
        8'hce: Byte_Out <= 8'h8b;
        8'hcf: Byte_Out <= 8'h8a;
        8'hd0: Byte_Out <= 8'h70;
        8'hd1: Byte_Out <= 8'h3e;
        8'hd2: Byte_Out <= 8'hb5;
        8'hd3: Byte_Out <= 8'h66;
        8'hd4: Byte_Out <= 8'h48;
        8'hd5: Byte_Out <= 8'h03;
        8'hd6: Byte_Out <= 8'hf6;
        8'hd7: Byte_Out <= 8'h0e;
        8'hd8: Byte_Out <= 8'h61;
        8'hd9: Byte_Out <= 8'h35;
        8'hda: Byte_Out <= 8'h57;
        8'hdb: Byte_Out <= 8'hb9;
        8'hdc: Byte_Out <= 8'h86;
        8'hdd: Byte_Out <= 8'hc1;
        8'hde: Byte_Out <= 8'h1d;
        8'hdf: Byte_Out <= 8'h9e;
        8'he0: Byte_Out <= 8'he1;
        8'he1: Byte_Out <= 8'hf8;
        8'he2: Byte_Out <= 8'h98;
        8'he3: Byte_Out <= 8'h11;
        8'he4: Byte_Out <= 8'h69;
        8'he5: Byte_Out <= 8'hd9;
        8'he6: Byte_Out <= 8'h8e;
        8'he7: Byte_Out <= 8'h94;
        8'he8: Byte_Out <= 8'h9b;
        8'he9: Byte_Out <= 8'h1e;
        8'hea: Byte_Out <= 8'h87;
        8'heb: Byte_Out <= 8'he9;
        8'hec: Byte_Out <= 8'hce;
        8'hed: Byte_Out <= 8'h55;
        8'hee: Byte_Out <= 8'h28;
        8'hef: Byte_Out <= 8'hdf;
        8'hf0: Byte_Out <= 8'h8c;
        8'hf1: Byte_Out <= 8'ha1;
        8'hf2: Byte_Out <= 8'h89;
        8'hf3: Byte_Out <= 8'h0d;
        8'hf4: Byte_Out <= 8'hbf;
        8'hf5: Byte_Out <= 8'he6;
        8'hf6: Byte_Out <= 8'h42;
        8'hf7: Byte_Out <= 8'h68;
        8'hf8: Byte_Out <= 8'h41;
        8'hf9: Byte_Out <= 8'h99;
        8'hfa: Byte_Out <= 8'h2d;
        8'hfb: Byte_Out <= 8'h0f;
        8'hfc: Byte_Out <= 8'hb0;
        8'hfd: Byte_Out <= 8'h54;
        8'hfe: Byte_Out <= 8'hbb;
        8'hff: Byte_Out <= 8'h16;
    endcase
    end
        
endmodule

