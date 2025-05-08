module priority_encoder_decoder_7seg (
    input [7:0] in,           // 8-bit input for priority encoder
    output [6:0] seg          // 7-segment display output
);

    // Intermediate wires
    wire [2:0] enc_out;       // 3-bit output from priority encoder

    // 8:3 Priority Encoder
    assign enc_out = (in[7] == 1) ? 3'b111 :
                     (in[6] == 1) ? 3'b110 :
                     (in[5] == 1) ? 3'b101 :
                     (in[4] == 1) ? 3'b100 :
                     (in[3] == 1) ? 3'b011 :
                     (in[2] == 1) ? 3'b010 :
                     (in[1] == 1) ? 3'b001 :
                     (in[0] == 1) ? 3'b000 : 3'bxxx;

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

endmodule
