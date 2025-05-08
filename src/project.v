module tt_um_priority_encoder_decoder_7seg (
    input  wire [7:0] ui_in,      // Dedicated inputs (8-bit input for priority encoder)
    output wire [7:0] uo_out,     // Dedicated outputs (7-bit for segments, 1 unused)
    input  wire [7:0] uio_in,     // IOs: Input path (not used)
    output wire [7:0] uio_out,    // IOs: Output path (not used)
    output wire [7:0] uio_oe,     // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,        // enable - goes high when design is selected
    input  wire       clk,        // clock
    input  wire       rst_n       // active low reset
);

    // Internal signals
    wire [2:0] enc_out;       // 3-bit output from priority encoder
    wire [6:0] seg_int;       // 7-bit segment output (combinational)
    reg  [6:0] seg_reg;       // Registered segment output

    // Assign unused outputs
    assign uio_out = 8'b0;    // Unused bidirectional outputs
    assign uio_oe = 8'b0;     // Disable bidirectional IOs (set as inputs)

    // 8:3 Priority Encoder
    assign enc_out = (ui_in[7] == 1) ? 3'b111 :
                     (ui_in[6] == 1) ? 3'b110 :
                     (ui_in[5] == 1) ? 3'b101 :
                     (ui_in[4] == 1) ? 3'b100 :
                     (ui_in[3] == 1) ? 3'b011 :
                     (ui_in[2] == 1) ? 3'b010 :
                     (ui_in[1] == 1) ? 3'b001 :
                     (ui_in[0] == 1) ? 3'b000 : 3'b000;  // Default to 0 when no input

    // 3:7 Decoder for 7-segment display (active low segments)
    assign seg_int = (enc_out == 3'b000) ? 7'b0000001 : // 0
                     (enc_out == 3'b001) ? 7'b1001111 : // 1
                     (enc_out == 3'b010) ? 7'b0010010 : // 2
                     (enc_out == 3'b011) ? 7'b0000110 : // 3
                     (enc_out == 3'b100) ? 7'b1001100 : // 4
                     (enc_out == 3'b101) ? 7'b0100100 : // 5
                     (enc_out == 3'b110) ? 7'b0100000 : // 6
                     (enc_out == 3'b111) ? 7'b0001111 : // 7
                     7'b1111111;                      // Off (invalid)

    // Register outputs with reset and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            seg_reg <= 7'b1111111;  // All segments off on reset (active low)
        else if (ena)
            seg_reg <= seg_int;
        else
            seg_reg <= 7'b1111111;  // Off when not enabled
    end

    // Assign segment outputs to uo_out[6:0]
    assign uo_out[6:0] = seg_reg;

    // Unused bit tied low
    assign uo_out[7] = 1'b0;

endmodule
