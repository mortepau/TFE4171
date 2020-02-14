
module top(
  input clk, rst, validi,
  input [7:0] data_in,
  output valido,
  output [7:0] data_out
  );

  logic [7:0] alu1_out, alu2_in, alu2_out, fsm_out;
  logic [2:0] op_alu1 = 3'b111, op_alu2 = 3'b000;
  
  alu alu1 (
    .Clk(clk),
    .A(fsm_out),
    .B(data_in),
    .Op(op_alu1),
    .R(alu1_out)
  );
  
  alu alu2 (
    .Clk(clk),
    .A(alu2_in),
    .B(data_in),
    .Op(op_alu2),
    .R(alu2_out)
  );

  ex2_1 fsm (
    .clk(clk),
    .rst(rst),
    .validi(validi),
    .valido(valido),
    .data_in(data_in),
    .data_out(fsm_out)
  ); 
  
  assign alu2_in = alu1_out; 
  assign data_out = (valido) ? data_out : alu2_out;
  
endmodule : top
