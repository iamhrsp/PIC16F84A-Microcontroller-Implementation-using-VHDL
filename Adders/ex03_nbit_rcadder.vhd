library ieee;
use ieee.std_logic_1164.all;

entity ex03_nbit_rcaadder is
  generic(bit_size : positive);
  port ( A, B : in std_logic_vector (bit_size-1 downto 0);
       --no Carry input here as per question
         CO   : out std_logic;
         S    : out std_logic_vector (bit_size-1 downto 0)
       );
end ex03_nbit_rcaadder;

architecture behavioural of ex03_nbit_rcaadder is
	signal ocarry : std_logic_vector (bit_size-1 downto 0); 
begin
        
    	main_loop:for i in 0 to bit_size-1 generate
          first_bit : if (i = 0) generate
	  	first_adder : entity work.ex03_1bitadder(behavioural) port map( A  => A(i),
                                                                       	        B  => B(i),
                                                                                CI => '0',
                                                                                CO => ocarry(i),
                                                                                S  => S(i) 
                                                                              );
	  end generate first_bit;

          other_bits : if (i > 0) generate
          	rest_adders : entity work.ex03_1bitadder(behavioural) port map ( A  => A(i),
                                                                                 B  => B(i),
                                                                                 CI => ocarry(i-1),
                                                                                 CO => ocarry(i),
                                                                                 S  => S(i)
                                                                               );
          end generate other_bits;
         end generate main_loop;             

        CO <= ocarry(bit_size-1);
end behavioural;
