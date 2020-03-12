-- @lang=VHDL @ts=2

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.arbitration.all; 

entity busslave is

  port (
    clk       : in  std_logic;
    reset     : in  std_logic;

    waitstate : in std_logic;     

    bus_grant     : in  arb_vector; 
    bus_ack       : out  std_logic);

end entity busslave;


architecture rtl of busslave is
	type state_t is (ACK, IDLE, BUSY1, BUSY2);  
	signal state_s: state_t; 

begin -- architecture rtl

	ctrl: process (clk, reset) is 	-- control FSM
	begin 
		if reset = '1' then
			state_s <= IDLE; 
			bus_ack <= '0'; 
		elsif clk'event and clk = '1' then -- rising clock edge
			case state_s is
			when ACK =>
				state_s <= IDLE; 
				bus_ack <= '0'; 
			when IDLE =>
				if bus_grant != NO_GRANT then
					state_s <= BUSY1;
				end if;
			when BUSY1 =>
				if waitstate = '1' then
					state_s <= BUSY2;
				else
					state_s <= ACK; 
					bus_ack <= '1'; 
				end if; 
			when BUSY2 =>
				state_s <= ACK; 
				bus_ack <= '1'; 
			end case;
		end if;
	end process ctrl;

end architecture rtl;
