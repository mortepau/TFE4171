-- @lang=VHDL @ts=2

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.arbitration.all; 

entity busmaster is

  port (
    clk       : in  std_logic;
    reset     : in  std_logic;

    master_req : in std_logic;     

    bus_req       : out std_logic;  
    bus_grant     : in  std_logic; 
    bus_ack       : in  std_logic);

end entity busmaster;


architecture rtl of busmaster is
	type state_t is (IDLE, REQUESTING, GRANTED);  
	signal state_s: state_t; 

begin -- architecture rtl

	ctrl: process (clk, reset) is 	-- control FSM
	begin 
		if reset = '1' then
			state_s <= IDLE; 
			bus_req <= '0'; 
		elsif clk'event and clk = '1' then -- rising clock edge
			case state_s is
			when IDLE =>
				if master_req = '1' then
					state_s <= REQUESTING;
					bus_req <= '1'; 
				end if;
			when REQUESTING =>
				if bus_grant = '1' then
					state_s <= GRANTED;
					bus_req <= '0'; 
				end if; 
			when GRANTED =>
				if bus_ack = '1' then
					state_s <= IDLE; 
				end if;
			end case;
		end if;
	end process ctrl;

end architecture rtl;
