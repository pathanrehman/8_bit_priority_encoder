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
    dut.ui_in.value = 20  # 00010100
await ClockCycles(dut.clk, 3)  # wait longer for output to stabilize

actual_uo_out = dut.uo_out.value.integer & 0x7F
expected_uo_out = 0b1001100  # encoding for digit 4

dut._log.info(f"ui_in={dut.ui_in.value.integer:08b}, uo_out={actual_uo_out:07b}")

assert actual_uo_out == expected_uo_out, \
    f"Output mismatch: got {actual_uo_out:07b}, expected {expected_uo_out:07b}"


