-- @lang=VHDL @ts=2

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.arbitration.all; 

entity top is

  port (
    clk        : in  std_logic;
    reset      : in  std_logic;

		master_req : in arb_vector; -- external requests for the master agents
    waitstate  : in std_logic);   -- external condition for slave waitstate

end entity top;


architecture rtl of top is

	signal bus_req   : arb_vector; 
	signal bus_grant : arb_vector; 
	signal bus_ack   : std_logic; 

begin -- architecture rtl

	arbiter : entity work.busarbiter(rtl) port map(clk, reset, bus_req, bus_grant, bus_ack); 

	slave   : entity work.busslave(rtl) port map(clk, reset, waitstate, bus_grant, bus_ack); 

	master0 : entity work.busmaster(rtl) port map(clk, reset, master_req(0), bus_req(0), bus_grant(0), bus_ack); 
	master1 : entity work.busmaster(rtl) port map(clk, reset, master_req(1), bus_req(1), bus_grant(1), bus_ack); 
	master2 : entity work.busmaster(rtl) port map(clk, reset, master_req(2), bus_req(2), bus_grant(2), bus_ack); 
end architecture rtl;
