library ieee;
library std;
use ieee.std_logic_1164.all;
use std.textio.all;

entity tb_ex02 is
  end tb_ex02;

architecture behavioural of tb_ex02 is
    
       signal signal_a,signal_b : std_logic_vector (7 downto 0);
       signal signal_s          : std_logic;
       signal signal_q          : std_logic_vector (7 downto 0);

begin
     dut :entity work.ex02_multiplexer(behavioural) port map ( a => signal_a,
                                                         b => signal_b,
                                                         s => signal_s,
                                                         q => signal_q
                                                       );
                 mux_file_io : process
                          

       --Remember to add correct path for your input and output file 
                          
                            file in_mux_file : text open read_mode is "..vhdl/ex02_input_file.txt";                                            
                            file out_mux_file: text open write_mode is "../vhdl/ex02_output_file.txt";                            

                              variable in_bit_line : line;
                              variable in_mux      : std_logic_vector (7 downto 0);
                              variable sel_mux     : std_logic;

                              variable out_mux     : std_logic_vector (7 downto 0);
                              variable out_bit_line: line;                             
                   begin
                         while not endfile (in_mux_file) loop
                           
                               readline(in_mux_file,in_bit_line);

                               read(in_bit_line, in_mux);
                               signal_a <= in_mux;

                               read(in_bit_line, in_mux);
                               signal_b <= in_mux;

                               read(in_bit_line, sel_mux);
                               signal_s <= sel_mux;
                               

                               wait for 10 ns;

                               write(out_bit_line, signal_q);
                               writeline(out_mux_file, out_bit_line);
                                                              
                         end loop;
                         wait;
                   end process mux_file_io ;
end behavioural;
                 
                 

                 
                 
