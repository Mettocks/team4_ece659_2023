`timescale 1ns / 1ps



module Dec_Readfile_test_tb();
    reg clock;
    reg test_start, key_start;
    reg [127:0] test_cipher;
    reg [255:0] test_key;
    wire [127:0] test_plain;
    wire test_ctrl;
    wire test_keyfin;

        wire [127:0] k1, k2, k3, k4, k5, k6, k7,
                   k8, k9, k10, k11, k12, k13;
    //reg [7:0] j; // For loop var

    Key_Expansion KEYEXP(
                        key_start,
                        clock,
                        test_key,
                        k1, k2, k3, k4, k5, k6, k7, k8, k9, k10, k11, k12, k13,
                        test_keyfin
                        );

    wire [127:0] k0a, k0b;
    assign k0a = test_key[255:128];
    assign k0b = test_key[127:0];
    Decryption_Core DUT (.CLK(clock),
                         .start(test_start),
                         .Plaintext(test_plain),
                         .in_key0 (k0a),
                         .in_key1 (k0b),
                         .in_key2 (k1),
                         .in_key3 (k2),
                         .in_key4 (k3),
                         .in_key5 (k4),
                         .in_key6 (k5),
                         .in_key7 (k6),
                         .in_key8 (k7),
                         .in_key9 (k8),
                         .in_key10(k9),
                         .in_key11(k10),
                         .in_key12(k11),
                         .in_key13(k12),
                         .in_key14(k13),
                         .Ciphertext(test_cipher),
                         .finished(test_ctrl)
                         );

    initial begin
        clock = 1'b0;
    end
    always #1 clock=~clock;

    integer KAT_file; // file handler

    reg [255:0] record_key;
    reg [127:0] record_iv;
    reg [127:0] record_in;
    reg [127:0] record_out;

    initial begin
    KAT_file = $fopen("KAT_256_03.rsp", "r");
    //KAT_file = $fopen("../../../vlsi_project_aes_test_20221.srcs/sim_1/new/test_file.txt", "r");
    if(KAT_file == 0) begin
        $display("Bad File Descriptor for KAT file\n");
        $stop;
    end

    while(! $feof(KAT_file)) begin
        @(negedge clock) // wait for next negetaive edge before pulling in next input
        $fscanf(KAT_file, "%h\n", record_key);
        $fscanf(KAT_file, "%h\n", record_iv);
        $fscanf(KAT_file, "%h\n", record_in);
        $fscanf(KAT_file, "%h\n", record_out); 
        #0.5 
        $display("Key: %h\n,IV: %h\n Cipher: %h\n, Expected Plaintext: %h\n---------------\n",
                record_key, record_iv, record_out, record_in);
        //$stop;
        
        // Actual TB goes here.
        
        // Key expansion
        test_key = record_key; // put read key in proper place
        key_start = 1; // raise key_start
        @(negedge clock) key_start = 0; // lower key_start at next negedge
        @(test_keyfin) $display("Finished Key Expansion"); // wait for key_fin to raise
        #1 //$stop; // waiting a moment for waveform to display new values


        //Push test vector in
        test_cipher = record_out^ record_iv; 
        // push read plaintext in
        // If you want to XOR the plaintext with an iv, do it here (e.g. for CBC mode testing) do it on the above line
        
        test_start = 1; // raise test_start
        @(negedge clock) test_start = 0;
        @(test_ctrl) $display("Finished Decryption: %h",test_plain); // wait for encryption to raised finished bit
        if(test_plain==record_in) begin $display("Plaintext matched\n\n"); end
         //$stop; // waiting a moment for waveform to display
         @(negedge clock);

    end

    $stop;
    $finish;


    end


endmodule