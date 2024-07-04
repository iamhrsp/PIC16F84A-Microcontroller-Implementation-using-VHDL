library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.ex05_alu_functions.all;
use work.ex05_alu_procedures.all;

entity tb_ex05 is
  end entity tb_ex05;

architecture behavioural of tb_ex05 is

  	------------------------------------------------------
	--testbench SIGNALS FOR ALU
  	------------------------------------------------------
  	signal W_tb, f_tb, result_tb               : std_logic_vector(7 downto 0):= "00000000";
        signal op_tb                               : operation;
        signal bit_select_tb,status_in_tb,status_tb: std_logic_vector(2 downto 0) := "000";

        ------------------------------------------------------
        --testbench SIGNALS FOR MEMORY
        ------------------------------------------------------
        signal address_tb                        : std_logic_vector(7 downto 0):= "00000000";
        --signal status_in_tb,status_out           : std_logic_vector(2 downto 0);
  	signal reset_tb             	   	 : std_logic := '1';
        signal clk_tb				 : std_logic := '0';
        signal re_tb				 : std_logic := '0';
        signal we_tb	                         : std_logic := '0';
begin

	alu_dut : entity work.ex05_alu(behavioural)
          port map(W          => W_tb,
                   f          => f_tb,
                   op         => op_tb,
                   bit_select => bit_select_tb,
                   status_in  => status_in_tb,
                   status     => status_tb,
                   result     => result_tb
                );
        
        memory_dut : entity work.ex05_memory(behavioural)
           generic map(memory_size => 50)
           port map(clk     => clk_tb,
                    address => address_tb,
                    re      => re_tb,
                    we      => we_tb,
                    reset   => reset_tb,
                    data_in       => result_tb,   --DATA FROM ALU RESULT(output) GOES TO MEMORY DATAIN(input)     
                    memstatus_in  => status_tb,   --STATUS OUT FROM ALU GOES TO MEM STATUS IN  
                    data_out      => f_tb,        --DATA out FROM MEMORY GOES to F OPERAND in ALU
                    memstatus_out => status_in_tb --STATUS OUT FROM MEMORY GOES to INPUT STATUS of ALU
                   );

        readwrite : process is

          	--------------------------------------------------
          	--DEFINING SOME VARIABLES FOR READ WRITE OPERATION
          	--------------------------------------------------
          	variable inline  : line;
                variable code    : string(1 to 5);
                variable comma   : character;
                variable Woperand,foperand,bs_file : integer;

                variable outline : line;

                file infile  : text open read_mode  is "../vhdl/ex05_input_file.txt";
                file outfile : text open write_mode is "../vhdl/ex05_output_file.txt";

        begin

            	reset_tb <= '0' after 2 ns;

                clk_tb <= not clk_tb after 1 ns;
                wait for 5 ns;
                clk_tb <= not clk_tb;
                
                re_tb <= '1' after 2 ns;
                wait for 5 ns;

                while not endfile(infile) loop

                  ---------------------------------------
                  --READING FROM FILE
                  ---------------------------------------

                  	readline(infile, inline);
                        read(inline,code);
                        op_tb         <= str2op(code);
                        read(inline,comma);
                        read(inline,Woperand);
                        W_tb          <= STD_LOGIC_VECTOR(TO_UNSIGNED(Woperand,8));
                       -- read(inline,comma);
                       -- read(inline,si_file);
                       -- status_in_tb <= STD_LOGIC_VECTOR(TO_UNSIGNED(si_file,3));
                        read(inline,comma);
                        read(inline,bs_file);
                        bit_select_tb  <= STD_LOGIC_VECTOR(TO_UNSIGNED(bs_file,3));

                        re_tb <= '0' after 2 ns;  --STOP READING AFTER 2ns

                        clk_tb <= not clk_tb;     --CLK GOES FROM 0 to 1 INSTANTANEOUSLY
                        wait for 5 ns;            --CLK SETTLES TO 1 and RE BECOMES 0
                        clk_tb <= not clk_tb;     --CLK GOES TO 0
                        
                        address_tb <= address_tb + "00000001";
                                --MEMORY IS READ FROM THE PREVIOUS ADDRESS. NEW
                                --ADDRESS POINTS TO A NEXT LOCATION.
                                --WRITE OPRATION IS PERMORMED AT THIS NEW
                                --LOCATION. THE READ OPERATION IN THE NEXT
                                --LOOP INTERATION IS READ FROM THIS NEW
                                --ADDRESS LOCATION. 
                        we_tb <= '1' after 2 ns;  
                        wait for 5 ns;           --WE goes to 0, clk is already0

                        clk_tb <= not clk_tb;    --write operation. rising edge of clk
                        we_tb <= '0' after 2 ns; 
                        wait for 5 ns;           --we goes 0 (initial state)

                        clk_tb <= not clk_tb;    --clock goes zero
                        re_tb <= '1' after 2 ns;
                        wait for 5 ns;           --re goes 1(initial state before loop)

                  -------------------------------------------------
                  --WRITING TO FILE
                  -------------------------------------------------
                        write(outline,TO_INTEGER(UNSIGNED(result_tb)));
                        write(outline,comma);
                        write(outline,TO_INTEGER(UNSIGNED(status_tb)));
                        writeline(outfile,outline);
                        
                end loop;
                
        wait;
        end process readwrite;

end architecture behavioural;
                        

                        
                        
                        

              		
	
