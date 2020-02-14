module test_top();

   logic clk, rst, validi;
   logic [7:0] data_in;
   wire 	valido;
   wire [7:0]  data_out;
   
   top dut 
     (
      clk, rst, validi,
      data_in,
      valido,
      data_out
      );
   
   bind top top_property top_bind 
     (
      clk, rst, validi,
      data_in,
      valido,
      data_out
      );

    //Make your covergroup here
    covergroup alu_cg(input logic[2:0] op, logic[7:0] a, logic[7:0] b) @(posedge clk);
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
      alu_cg cg_inst1 = new(dut.op_alu1, dut.fsm_out, dut.data_in);
      alu_cg cg_inst2 = new(dut.op_alu2, dut.alu2_in, dut.data_in);
    initial begin
      #400;
      $display("Coverage (cg_inst1) = %0.2f %%", cg_inst1.get_inst_coverage());
      $display("Coverage (cg_inst2) = %0.2f %%", cg_inst2.get_inst_coverage());
    end
  
   initial begin
      clk=1'b0;
      set_stim;
      @(posedge clk); $finish(2);
   end

   always @(posedge clk) 
     $display($stime,,,"rst=%b clk=%b validi=%b DIN=%0d valido=%b DOUT=%0d",
	      rst, clk, validi, data_in, valido, data_out);
   
   always #5 clk=!clk;

   task set_stim;
      rst=1'b0; validi=0'b1; data_in=8'b1;
      @(negedge clk) rst=1;
      @(negedge clk) rst=0;
      
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b1; data_in+=8'b1;
      @(negedge clk); validi=1'b0; data_in+=8'b1;
 
      @(negedge clk);
   endtask

endmodule
