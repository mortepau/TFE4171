/*
 * Turning all checks on with check5
 */
`ifdef check5
`define check1 
`define check2 
`define check3 
`define check4
`endif 

module ex2_1_property 
  (
   input 	      clk, rst, validi,
   input [31:0]       data_in,
   input logic 	      valido, 
   input logic [31:0] data_out
   );

/*------------------------------------
 *
 *        CHECK # 1. Check that when 'rst' is asserted (==1) that data_out == 0
 *
 *------------------------------------ */

`ifdef check1

property reset_asserted;
	@(posedge clk) rst |-> !data_out;
endproperty

reset_check: assert property(reset_asserted)
  $display($stime,,,"\t\tRESET CHECK PASS:: rst_=%b data_out=%0d \n",
	   rst, data_out);
else $display($stime,,,"\t\tRESET CHECK FAIL:: rst_=%b data_out=%0d \n",
	      rst, data_out);
`endif

/* ------------------------------------
 * Check valido assertion to hold 
 *
 *       CHECK # 2. Check that valido is asserted when validi=1 for three
 *                  consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check2

property valido_asserted;
	@(posedge clk) disable iff(rst)
	  validi [*3] |=> valido;
endproperty

valido_check: assert property(valido_asserted)
  $display($stime,,,"\t\tVALIDO CHECK PASS:: validi=%b valido=%b \n",
	validi, valido);
else $display($stime,,,"\t\tVALIDO CHECK FAIL:: validi=%b valido=%b \n",
	validi, valido);

`endif

/* ------------------------------------
 * Check valido not asserted wrong 
 *
 *       CHECK # 3. Check that valido is not asserted when validi=1 for only two, one
 *                  or zero consecutive clk cycles
 * 
 * ------------------------------------ */

`ifdef check3

property valido_not_asserted;
	@(posedge clk) disable iff (rst)
	  ($rose(validi) || validi && $past(rst)) ##0 validi  [*0:2] ##1 $fell(validi) |-> !valido;  
endproperty

valido_not_check: assert property(valido_not_asserted)
  //$display($stime,,,"\t\tVALIDO NOT CHECK PASS:: validi=%b valido=%b \n", validi, valido);
else $display($stime,,,"\t\tVALIDO NOT CHECK FAIL:: validi=%b valido=%b \n",
	validi, valido);

`endif

/* ------------------------------------
 * Check data_out value 
 *
 *       CHECK # 4. Check that data_out when valido=1 is equal to a*b+c where a is data_in
 *       two cycles back, b is data_in one cycle back, and c is the present data_in
 * 
 * ------------------------------------ */

`ifdef check4

property data_out_asserted;
	@(posedge clk) disable iff(rst)
	  valido |-> data_out == ($past(data_in,3) * $past(data_in,2) + $past(data_in));
endproperty
data_out_check: assert property(data_out_asserted)
  $display($stime,,,"\t\tDATA OUT CHECK PASS:: data_out=%0d $past(data_in)=%0d $past(data_in,2)=%0d $past(data_in,3)=%0d \n",
	data_out, $past(data_in), $past(data_in,2), $past(data_in,3));
else $display($stime,,,"\t\tDATA OUT CHECK PASS:: data_out=%0d $past(data_in)=%0d $past(data_in,2)=%0d $past(data_in,3)=%0d \n",
	data_out, $past(data_in), $past(data_in,2), $past(data_in,3));

`endif

endmodule
