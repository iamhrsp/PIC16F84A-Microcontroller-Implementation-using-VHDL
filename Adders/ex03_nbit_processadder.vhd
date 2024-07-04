-- Here I implemented another version of n bit full adder without a carry input
-- A basic addition operation on the bits, followed by extraction of sum and carry out bit.
-- the type conversion to integers and back to std_logic_vector operations have been avoided.
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--------------------------------------------------
--ENTITY DECLARATION
-------------------------------------------------
entity ex03_nbit_processadder is
  generic (n :positive);               --note the inclusion of such a generic
                                        --behaviour. We will later generic map
                                        --this variable to fit to out desired bits.
  port(A,B : in  std_logic_vector (n-1 downto 0);
       CO  : out std_logic;
       S   : out std_logic_vector(n-1 downto 0));
end ex03_nbit_processadder;

--as per the task requirement, input carry is not available

---------------------------------------------------
--ARCHITECTURE DECLARATION
--------------------------------------------------
architecture behavioural of ex03_nbit_processadder is
  	signal sum   : std_logic_vector (n downto 0); --I initially used variable but later found
                                                      --that signal can also be used for doing the arithmentic
                                                      --later in the begin
        
begin
     sum <=('0' & A) + ('0' & B);           --Putting 0 like this appends it towards left. Similarly putting
                                            --at the right appends it at the right
                                            
     S   <= sum(n-1 downto 0);
     CO  <= sum(n);

end behavioural;
