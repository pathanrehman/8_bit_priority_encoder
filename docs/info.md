<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

The project implements an 8:3 priority encoder connected to a 3:7 decoder to drive a 7-segment display. The priority encoder takes an 8-bit input (IN0 to IN7) and generates a 3-bit output code based on the highest priority active input, where IN7 has the highest priority and IN0 the lowest. The 3-bit code is then decoded by the 3:7 decoder to produce a 7-bit output (SEG_A to SEG_G) that drives a common-anode 7-segment display to show digits 0 through 7, corresponding to the highest priority active input. If no inputs are active, the display is turned off (all segments high for common-anode)

## How to test

1. Connect the 8 input pins (IN0 to IN7) to switches or a test signal source.
2. Connect the 7 output pins (SEG_A to SEG_G) to a common-anode 7-segment display.
3. Apply a high signal (logic 1) to one or more input pins, starting with IN0 to IN7.
4. Observe the 7-segment display output:
   - IN0 high (others low) displays '0'
   - IN1 high (others low) displays '1'
   - IN2 high (others low) displays '2'
   - IN3 high (others low) displays '3'
   - IN4 high (others low) displays '4'
   - IN5 high (others low) displays '5'
   - IN6 high (others low) displays '6'
   - IN7 high (others low) displays '7'
   - If multiple inputs are high, the display shows the digit corresponding to the highest priority input (e.g., IN7 and IN3 high will display '7').
   - If no inputs are high, the display should be off (all segments off for common-anode).
5. Verify the priority encoding by setting multiple inputs high and confirming the display shows the highest priority digit.

## External hardware

- Common-anode 7-segment display
- 8 switches or signal sources for inputs (optional for testing)
- Current-limiting resistors for the 7-segment display segments (typically 220-330 ohms, depending on the display and supply voltage)
