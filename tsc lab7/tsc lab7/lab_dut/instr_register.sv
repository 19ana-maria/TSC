/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter
 *
 * An error can be injected into the design by invoking compilation with
 * the option:  +define+FORCE_LOAD_ERROR
 *
 **********************************************************************/

module instr_register
import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
(/*input  logic          clk,
 input  logic          load_en,
 input  logic          reset_n,
 input  operand_t      operand_a,
 input  operand_t      operand_b,
 input  opcode_t       opcode,
 input  address_t      write_pointer,
 input  address_t      read_pointer,
 output instruction_t  instruction_word*/
 tb_ifc i_tb_ifc
);
  timeunit 1ns/1ns;

  instruction_t  iw_reg [0:31];  // an array of instruction_word structures

  logic signed [63:0] result;


  // write to the register
  always@(posedge i_tb_ifc.clk, negedge i_tb_ifc.reset_n)   // write into register
    if (!i_tb_ifc.reset_n) begin
      foreach (iw_reg[i])
        iw_reg[i] = '{opc:ZERO,default:0};  // reset to all zeros
    end
    
    else if (i_tb_ifc.load_en) begin
      case (i_tb_ifc.opcode)
      PASSA : result = i_tb_ifc.operand_a;
      PASSB : result = i_tb_ifc.operand_b;
      ADD : result = i_tb_ifc.operand_a + i_tb_ifc.operand_b;
      SUB : result = i_tb_ifc.operand_a - i_tb_ifc.operand_b;
      MULT : result = i_tb_ifc.operand_a * i_tb_ifc.operand_b;
      DIV : result = i_tb_ifc.operand_a / i_tb_ifc.operand_b;
      MOD : result = i_tb_ifc.operand_a % i_tb_ifc.operand_b;
      default : result = 0;
        
      endcase
      iw_reg[i_tb_ifc.write_pointer] = '{i_tb_ifc.opcode,i_tb_ifc.operand_a,i_tb_ifc.operand_b, result};
    end

  // read from the register
  assign i_tb_ifc.instruction_word = iw_reg[i_tb_ifc.read_pointer];  // continuously read from register

// compile with +define+FORCE_LOAD_ERROR to inject a functional bug for verification to catch
`ifdef FORCE_LOAD_ERROR
initial begin
  force i_tb_ifc.operand_b = i_tb_ifc.operand_a; // cause wrong value to be loaded into operand_b
end
`endif

endmodule: instr_register