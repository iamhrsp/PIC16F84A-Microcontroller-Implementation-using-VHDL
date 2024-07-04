library ieee;
library std;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_ex03 is
  end tb_ex03;

---------------------------
--ARCHITECTURE DECLARATION
---------------------------  
architecture behavioural of tb_ex03 is
 	------------------------------------------
  	--SIGNAL DECLARATIONS FOR INPUT AND OUTPUT
	 ------------------------------------------
        --INPUT SIGNALS
        signal a,b     : std_logic_vector (7 downto 0);
        --OUTPUT SIGNALS
        --notice that here are two signals for two DUTs. I initially had missed
        --writing the sencond signal. It is required to check where both DUTs
        --are showing the correct result or not
        signal s1,s2   : std_logic_vector (7 downto 0);
        signal co1,co2 : std_logic;

        constant  N: integer:= 8;
  
begin
	-----------------------------
         --RIPPLE CARRY ADDER COMPONENT
        ------------------------------
   DUT1: entity work.ex03_nbit_rcaadder(behavioural)
    generic map (bit_size => N)
    port map(A  => a,
             B  => b,
             S  => s1,		-- As such I also missed porting the
                                -- sum and carry to appropirate DUTs' sum and
                                -- carry out
             CO => co1
                                                               
            );
   
      --this is what I was trying to understand that if i want to make a
      --generic adder ie for n bits, how to then communicate it to the test
      --bench and declare the desired number of bits, in this case it is 8
    
-- while wriring the port map, I raised a question to myself what to port map our entity
-- with in this testbech. I found out that I can declare some appropirate
-- signals in the architecture declaration part and use them to port map our
-- DDUTs.
	
     
      
    
	--------------------------------
        --PROCESS ADDER COMPONENT
        --------------------------------
  
    DUT2 : entity work.ex03_nbit_processadder(behavioural)
       generic map (n => N)
      port map(A  => a,
               B  => b,
               S  => s2,
               CO => co2
                                                                    
              );
     
     


    adder_io :process
    		--This adds a heading row to the output file
		constant header         :string := "SUM1,Carry Out1,SUM2,Carry Out2";
                  
		file     in_file        : text open read_mode is "../vhdl/ex03_input_file.csv";
                variable in_line        : line;
                variable in_a           : integer;
                variable comma         : character;
                variable in_b           : integer;
               
                variable sum            : integer;
               -- variable ocomma         : character;
                variable cout           : integer;
                variable out_line       : line;
                file     out_file       : text open write_mode is "../vhdl/ex03_output_file.csv";
    begin

         write (out_line, header); 
         writeline(out_file, out_line);
         writeline(out_file, out_line);  -- empty line

         while not endfile (in_file) loop

                 readline(in_file, in_line);
                 read    (in_line, in_a);
                 a <= STD_LOGIC_VECTOR(to_unsigned(in_a,8));

                 read    (in_line, comma);	       --instead of defining two
                                                       --sepearte variables for
                                                       --comma, only one can be
                                                       --declared since comma
                                                       --is same in both operations 

                 read    (in_line, in_b);
                 b <= STD_LOGIC_VECTOR(to_unsigned(in_b,8)); --from now on, i will follow
                                                             --the convention that whenever 
                                                             --there are type conversion,I 
                                                             -- will use CAPITALS  
                                                                
                 wait for 10 ns;

                 --sum  <= to_integer(s);  -- using such an approach, more
                                         -- variable will have to be declared
                                         -- for two sums and two carrys.
                                         -- Instead there is another direct way
                                         -- to get the results
                 --cout <= to_integer(co);
                 

                 write    (out_line, TO_INTEGER(UNSIGNED(s1))); --Also outputs
                                                               --displayed for
                                                               --two sums and
                                                               --carrys which i
                                                               --also missed initially.
                 write    (out_line, comma);
                 write    (out_line, co1);
                  write    (out_line, comma);
                 write    (out_line, TO_INTEGER(UNSIGNED(s2)));
                 write    (out_line, comma);
                 write    (out_line, co2);
                 writeline(out_file, out_line);
                 
         end loop;

         wait;

    end process;
end behavioural;

      
    
