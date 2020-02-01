/* Properties (assertions) for bus_protocol.v
*/
                                                                                                   
module bus_protocol_property (input bit clk, dValid, dAck, reset,
                              input logic [7:0] data
);

        /*--------------------------------------------------
        CHECK # 1. Check that once dValid goes high that it is consecutively 
          asserted (high) for minimum 2 and maximum 4 clocks.
	  Check also that once dValid is asserted (high) for 2 to 4 clocks that
	  it does de-assert (low) the very next clock.
          --------------------------------------------------*/
`ifdef check1
        property checkValid;
	 @(posedge clk) disable iff (reset) 
	  $rose(dValid) |=> dValid [*2] ##[1:3] $fell(dValid); 
        endproperty
        assert property (checkValid) else $display($stime,,,"checkValid FAIL");
`endif

        /*--------------------------------------------------
        CHECK # 2. Check that data is not unknown and remains stable after dValid goes high
                   and until dAck goes high.
          --------------------------------------------------*/
`ifdef check2
        property checkdataValid;
         @(posedge clk) disable iff (reset) 
	  $rose(dValid) |=> (!$isunknown(data) && $stable(data) throughout !dAck ##[1:$] $rose(dAck)); 
        endproperty
        assert property (checkdataValid) else $display($stime,,,"checkdataValid FAIL");
`endif

        /*--------------------------------------------------
        CHECK # 3.
        'dack' going high signifies that target have accepted data and that master must
        de-assert 'dValid' the clock after 'dack' goes high.

        Note that since data must be valid for minimum 2 cycles, that 'dack' cannot go High
        for at least 1 clock after the transfer starts (i.e. after the rising edge of 'dValid')
        and that it must not remain low for more than 3 clocks (because data must trasnfer in
        max 4 clocks).
          --------------------------------------------------*/
`ifdef check3
	property checkdAck;
	 @(posedge clk) disable iff (reset)
	  $rose(dValid) |=> (dValid && !dAck) [*1:3] ##1 $rose(dAck) ##1 $fell(dValid);
	endproperty
	assert property (checkdAck) else $display($stime,,,"checkdAck FAIL");
`endif                                                                                       

endmodule
