`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Inputs (reg because driven in testbench)
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  // Outputs (wire because driven by DUT)
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Instantiate the DUT
  tt_um_priority_encoder_decoder_7seg dut (
    .ui_in  (ui_in),
    .uo_out (uo_out),
    .uio_in (uio_in),
    .uio_out(uio_out),
    .uio_oe (uio_oe),
    .ena    (ena),
    .clk    (clk),
    .rst_n  (rst_n)
  );

  // Clock generation: 10ns period (100 MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    rst_n = 0;
    ena = 0;
    ui_in = 8'b0;
    uio_in = 8'b0;

    // Dump waveform for viewing
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);

    // Hold reset for 20 ns
    #20;
    rst_n = 1;  // Release reset

    // Enable the DUT
    ena = 1;

    // Apply test vectors to ui_in one bit at a time (priority encoder test)
    // Each input bit high individually from LSB to MSB
    repeat (8) begin
      ui_in = 8'b00000001;
      #10 ui_in = ui_in << 1;
      #40;
    end

    // Test multiple bits set (highest priority bit should be encoded)
    ui_in = 8'b10101010; // bits 7,5,3,1 set
    #40;

    ui_in = 8'b00000000; // no bits set
    #40;

    // Disable DUT and check output goes off
    ena = 0;
    ui_in = 8'b11111111;
    #40;

    // Re-enable DUT
    ena = 1;
    #40;

    // Finish simulation
    $finish;
  end

endmodule

`default_nettype wire
