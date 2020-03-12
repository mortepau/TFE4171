-- @lang=VHDL @ts=2

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.arbitration.all; 

entity busarbiter is

  port (
    clk       : in  std_logic;
    reset     : in  std_logic;
    bus_req       : in  arb_vector; 
    bus_grant     : out arb_vector; 
    bus_ack       : in  std_logic);

end entity busarbiter;

architecture rtl of busarbiter is
	type state_t is (READY, BUSY); 
	signal state_s: state_t; 
  signal prio_req: arb_vector; 

begin -- architecture rtl

  prio: process (bus_req) is 			-- compute priority
		variable found: boolean; 
		variable prio_req_v: arb_vector; 
		begin
			found := false;
			for m in 0 to N_MASTERS-1 loop
				if not found and bus_req(m) = '1' then
					prio_req_v(m) := '1';
					found := true;
				else 
					prio_req_v(m) := '0'; 
				end if;
			end loop;
			prio_req <= prio_req_v; 
		end process prio;

	ctrl: process (clk, reset) is 	-- control FSM
	begin 
		if reset = '1' then
			state_s <= READY; 
			bus_grant <= NO_GRANT; 
		elsif clk'event and clk = '1' then -- rising clock edge

			case state_s is

			when READY => 
				if bus_req = NO_REQUEST then
					state_s <= READY;
				else
					state_s <= BUSY;
				end if; 
				bus_grant <= prio_req;

			when BUSY =>
				if bus_ack = '1' then
					if bus_req = NO_REQUEST then
						state_s <= READY;
					else
						state_s <= BUSY;
					end if; 
					bus_grant <= prio_req;
				end if;

			end case;

		end if;
	end process ctrl;

end architecture rtl;
