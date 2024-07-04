library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_mux is

  port(memory_in   : in std_logic_vector(7 downto 0);
       literal_in : in std_logic_vector(7 downto 0);      
       select_line : in std_logic;
       f_operand   : out std_logic_vector(7 downto 0)
       );

end entity project_mux;

architecture rtl of project_mux is

begin

     process(all) is

     begin

     	  if select_line = '0' then
              f_operand <= memory_in;  --f operand of alu collects value from memory
           else
              f_operand <= literal_in;  --f operand of alu directly gets the literal, embedded in the instruction
	  end if;

      end process;
           
end architecture rtl;              
