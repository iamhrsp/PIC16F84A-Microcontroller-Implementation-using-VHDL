library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex06_wregister is
  port(data_in      : in std_logic_vector(7 downto 0);
       clk          : in std_logic;
       we_wregister : in std_logic;
       reset        : in std_logic;

       data_out     : out std_logic_vector(7 downto 0)
       );
end entity ex06_wregister;

architecture behavioural of ex06_wregister is

begin

     process(all) is

     begin
       
   	  if (reset = '1') then
             data_out <= (others => '0');
     	  elsif (rising_edge(clk) and we_wregister = '1') then
       	      data_out <= data_in;
          end if;

     end process;

end architecture behavioural;
