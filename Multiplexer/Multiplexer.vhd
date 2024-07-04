library ieee;
use ieee.std_logic_1164.all;

entity ex02_multiplexer is
  port(a,b: in std_logic_vector (7 downto 0);
       s  : in std_logic;
       q  : out std_logic_vector (7 downto 0)
      );
end ex02_multiplexer;

architecture behavioural of ex02_multiplexer is
  begin

   mux_function: process(a,b,s)
      begin
        if s = '0' then
          q <= a;
        else
          q <= b;
        end if;
    end process;
          
end behavioural;

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
 
