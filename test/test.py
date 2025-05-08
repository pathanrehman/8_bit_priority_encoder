# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set clock (10 us period)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    # Apply test input
    dut.ui_in.value = 20  # binary 00010100, highest set bit is bit 4

    await ClockCycles(dut.clk, 1)

    # Expected output for input 4 (bit 4 set) is 7'b1001100 (active low)
    expected_seg = 0b1001100
    # uo_out[7] is always 0, so full 8-bit expected output:
    expected_uo_out = expected_seg

    # Check output matches expected 7-seg pattern on bits [6:0]
    actual_uo_out = dut.uo_out.value.integer & 0x7F  # mask bits 6:0

    assert actual_uo_out == expected_uo_out, \
        f"Output mismatch: got {actual_uo_out:07b}, expected {expected_uo_out:07b}"

