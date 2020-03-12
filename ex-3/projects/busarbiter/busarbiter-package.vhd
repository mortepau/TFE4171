-- @lang=VHDL @ts=2

library IEEE;
use IEEE.std_logic_1164.all;

package arbitration is
  constant N_MASTERS : natural := 3; 
  subtype arb_vector is std_logic_vector(N_MASTERS-1 downto 0); 
  constant NO_REQUEST : arb_vector := (others => '0'); 
  constant NO_GRANT : arb_vector := (others => '0');   
end package arbitration;

