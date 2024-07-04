library ieee;
use ieee.std_logic_1164.all;

entity ex03_1bitadder is
  port ( A,B,CI : in  std_logic;
         S,CO   : out std_logic
       );
end ex03_1bitadder;

architecture behavioural of ex03_1bitadder is
  begin
       S  <=  A xor B xor CI;
       CO <= (A and B) or (B and CI) or (CI and A); 
end behavioural;
