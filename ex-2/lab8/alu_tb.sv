timeunit 10ns; 
`include "alu_packet.sv"
//`include "alu_assertions.sv"

module alu_tb();
	reg clk = 0;
	bit [0:7] a = 8'h0;
	bit [0:7] b = 8'h0;
	bit [0:2] op = 3'h0;
	wire [0:7] r;

parameter NUMBERS = 10000;

//make your vector here
alu_data test_data[0:NUMBERS-1];

//Make your loop here
initial begin : data_gen
  #20;
  for (int i = 0; i < NUMBERS; i++) begin
    test_data[i] = new();
    test_data[i].randomize();
    test_data[i].get(a,b,op);
    #20;
  end
end : data_gen

//Displaying signals on the screen
always @(posedge clk) 
  $display($stime,,,"alu_tb:: clk=%b a=%b b=%b op=%b r=%b",clk,a,b,op,r);

//Clock generation
always #10 clk=~clk;

//Declaration of the VHDL alu
alu dut (clk,a,b,op,r);

//Make your opcode enumeration here
enum bit[0:2] {ADD, SUB, MULT, NOT, NAND, NOR, AND, OR} opcode;

//Make your covergroup here
covergroup alu_cg @(posedge clk);
  cg_op : coverpoint op;
  cg_a : coverpoint a {
    bins zero = {0};
    bins small_ = {[1:50]};
    bins hunds[] = {100, 200};
    bins large_ = {[200:$]};
    bins others = default;
  }
  cg_axb : cross a,b;
endgroup

//Initialize your covergroup here
initial begin
  alu_cg cg_inst = new();
  #1000
  $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
end

//Sample covergroup here
// Automatically done by adding @(posedge clk) to the covergroup 

endmodule:alu_tb
