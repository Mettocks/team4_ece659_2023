module Inv_thirteen_rounds(
    input CLK,
    input reset,
    input [127:0] initial_state,
    input [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10, key11, key12, key13,
    output reg [127:0] final_state,
    output reg finished
    );

    wire [127:0] keys [12:0];
    assign keys[0] = key1;
    assign keys[1] = key2;
    assign keys[2] = key3;
    assign keys[3] = key4;
    assign keys[4] = key5;
    assign keys[5] = key6;
    assign keys[6] = key7;
    assign keys[7] = key8;
    assign keys[8] = key9;
    assign keys[9] = key10;
    assign keys[10] = key11;
    assign keys[11] = key12;
    assign keys[12] = key13;

    integer i; // counter var
    reg [127:0] roundState, roundKey;
    wire [127:0] roundStateOut;
    Inv_cipher_round OneRound(.in_state(roundState), .round_key(roundKey), .out_state(roundStateOut));
    
    always @(posedge CLK or posedge reset) begin
        if(reset) begin
            i <= 1;
            finished <= 0;
            roundState <= initial_state;
            roundKey <= keys[0];
        end
        else if ( i < 13 ) begin
            
            i <= i + 1;
            roundState <= roundStateOut;
            roundKey <= keys[i];
        end
        else if (i == 13) begin
            final_state <= roundStateOut;
            finished <= 1;
        end
    end

endmodule


