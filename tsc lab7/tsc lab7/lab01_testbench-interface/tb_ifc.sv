/***********************************************************************
 * A SystemVerilog testbench for an instruction register; This file
 * contains the interface to connect the testbench to the design
 **********************************************************************/
interface tb_ifc (input logic clk, input logic test_clk);
  timeunit 1ns/1ns;
  
  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

// ADD CODE TO DECLARE THE INTERFACE SIGNALS
  logic          load_en;
  logic          reset_n;
  operand_t      operand_a;
  operand_t      operand_b;
  opcode_t       opcode;
  address_t      write_pointer;
  address_t      read_pointer;
  instruction_t  instruction_word;


  
  modport TEST (input test_clk, instruction_word,
                output load_en, operand_a, operand_b, opcode, write_pointer, read_pointer, reset_n);

  modport DUT (input load_en, operand_a, operand_b, opcode, write_pointer, read_pointer, clk, reset_n,
                output instruction_word);
  

endinterface: tb_ifc