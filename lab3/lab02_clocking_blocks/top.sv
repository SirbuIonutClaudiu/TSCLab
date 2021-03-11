/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 *
 * SystemVerilog Training Workshop.
 * Copyright 2006, 2013 by Sutherland HDL, Inc.
 * Tualatin, Oregon, USA.  All rights reserved.
 * www.sutherland-hdl.com
 **********************************************************************/

module top;
  timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

 // instantiate the testbench interface
  tb_ifc io (.clk(test_clk));

  // connect interface to testbench
  instr_register_test test (.io(io));

  // connect interface to design using discrete ports
  instr_register dut (
    .clk(clk),
    .load_en(io.load_en),
    .reset_n(io.reset_n),
    .operand_a(io.operand_a),
    .operand_b(io.operand_b),
    .opcode(io.opcode),
    .write_pointer(io.write_pointer),
    .read_pointer(io.read_pointer),
    .instruction_word(io.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk;
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    //
    // THIS TEST CLOCK WILL BE REPLACED BY A CLOCKING BLOCK IN THE
    // INTERFACE BETWEEN THE TESTBENCH AND THE DUT
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
