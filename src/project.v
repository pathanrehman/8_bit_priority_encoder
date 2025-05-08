module tt_um_priority_encoder_decoder_7seg (
    input  wire [7:0] ui,         // Dedicated inputs (8-bit input for priority encoder)
    output wire [7:0] uo,         // Dedicated outputs (7-bit for segments, 1 unused)
    input  wire [7:0] uio_in,     // IOs: Input path (not used)
    output wire [7:0] uio_out,    // IOs: Output path (not used)
    output wire [7:0] uio_oe,     // IOs: Enable path (output enable, not used)
    input  wire       ena,        // Enable (not used)
    input  wire       clk,        // Clock (not used)
    input  wire       rst_n       // Reset (not used)
);

    // Internal signals
    wire [2:0] enc_out;       // 3-bit output from priority encoder
    wire [6:0] seg;           // 7-bit segment output

    // Assign unused outputs
    assign uo[7] = 1'b0;      // Unused output pin
    assign uio_out = 8'b0;    // Unused bidirectional outputs
    assign uio_oe = 8'b0;     // Disable bidirectional IOs (set as inputs)

    // 8:3 Priority Encoder
    assign enc_out = (ui[7] == 1) ? 3'b111 :
                     (ui[6] == 1) ? 3'b110 :
                     (ui[5] == 1) ? 3'b101 :
                     (ui[4] == 1) ? 3'b100 :
                     (ui[3] == 1) ? 3'b011 :
                     (ui[2] == 1) ? 3'b010 :
                     (ui[1] == 1) ? 3'b001 :
                     (ui[0] == 1) ? 3'b000 : 3'bxxx;

    // 3:7 Decoder for 7-segment display (active low segments)
    assign seg = (enc_out == 3'b000) ? 7'b0000001 : // 0
                 (enc_out == 3'b001) ? 7'b1001111 : // 1
                 (enc_out == 3'b010) ? 7'b0010010 : // 2
                 (enc_out == 3'b011) ? 7'b0000110 : // 3
                 (enc_out == 3'b100) ? 7'b1001100 : // 4
                 (enc_out == 3'b101) ? 7'b0100100 : // 5
                 (enc_out == 3'b110) ? 7'b0100000 : // 6
                 (enc_out == 3'b111) ? 7'b0001111 : // 7
                 7'b1111111;                      // Off (invalid)

    // Assign segment outputs to uo[6:0]
    assign uo[6:0] = seg;

endmodule
