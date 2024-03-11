-- Project to create a simple 2 to 1 Multiplexer. This project only has a testbench file, where the functionality of MUX is defined and as well as stimulus to the MUX is given.

--**** library and package declaration**** --
library ieee;
use ieee.std_logic_1164.all;

----------------------------------------------------------------

--**** entity declaration **** --
entity tb_ex01 is
  end tb_ex01;
  
-------------------------------------------------------------------
  
--**** architecture declation **** --
architecture behavioural of tb_ex01 is
  
     -----------------------
  
     -- this is the mux component with in, out interfaces
--     component mux_ex01           
--       port (in1,in2 :in std_logic_vector (7 downto 0);
--             sel     :in std_logic;
--             result  :out std_logic_vector (7 downto 0)
--             );
--     end component;
     
     -----------------------
     
     -- these are the in out signals to the component
     signal signal_a,signal_b    :std_logic_vector(7 downto 0);
     signal signal_q             :std_logic;
     signal signal_result        :std_logic_vector(7 downto 0);                  
     -----------------------
begin

     -----------------------I had written this piece of code before settling in for the actual code. The below version uses a component instantiation and if then else sequential statement.------------------------------------------
   -- statement region of architechture begins
                                                                                               -- first we instantiate the mux component
                                                                                               -- used the named association
                                                                                               -- observe that the same component name is used for instantiation
                                                                                                 -----------------------
                                                                                            --  dut : mux_ex01 port map( in1 => signal_a,
                                                                                            --                           in2 => signal_b,
                                                                                            --                           sel => signal_q,
                                                                                            --                           result => signal_result
                                                                                            --                         );
                                                                                              
                                                                                                 -----------------------
                                                                                              
                                                                                               -- first process in the architecture defines the functionality of mux
                                                                                             -- mux_function: process(signal_a,signal_b,signal_q)
                                                                                             --           begin
                                                                                             --             if    signal_q = '0' then 
                                                                                             --                       signal_result <= signal_a;
                                                                                             --             else 
                                                                                             --                      signal_result <= signal_b;
                                                                                             --             end if;
                                                                                             --             
                                                                                             --           end process;
with signal_q select
       signal_result <= signal_a when '0',
                        signal_b when '1',
                        X"00" when others;

  
   -- second process is used to give values to input of mux.
   -- observe that here we do not have a sensitivity list since we are giving
   -- inputs here
  mux_stimulus: process
            begin
              signal_a <= "10101010" ; signal_b <= "00001111" ; signal_q <= '0';
              wait for 10 ns;

              signal_a <= "10010010" ; signal_b <= "00100100" ; signal_q <= '1';
              wait for 10 ns;
              wait;
            end process;
      ------------------------
end behavioural; 
              
  
