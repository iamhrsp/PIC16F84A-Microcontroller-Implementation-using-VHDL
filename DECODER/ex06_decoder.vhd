library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

library work;
use work.ex06_alu_functions.all;
use work.ex06_alu_procedures.all;

entity ex06_decoder is
  port(instruction	         : in std_logic_vector(13 downto 0);
       clk	        	 : in std_logic;
       reset	  	         : in std_logic;
       alu_literal_address	 : out std_logic_vector(7 downto 0):= "00000000";  --Address of f operand in memory
       alu_bit_select		 : out std_logic_vector(2 downto 0):= "000";  --bit select input to alu
       alu_opcode		 : out operation; --this is an enumeration datatype described in packages.vhd and functions.vhd work files
       alu_literal	         : out std_logic_vector(7 downto 0):= "00000000"; --direct literal/operand from instruction to alu for control oriented operation
       program_counter           : out integer:=0;
       
       alu_enable	         : out std_logic;  --enables or disables alu
       we_memory		 : out std_logic;  --write enables the memory
       re_memory	         : out std_logic;  --read enables the memory
       sl_alu_mux	         : out std_logic;  --select line of mux to alu. Used for selecting the operand to alu
       we_wregister	         : out std_logic;  --write enable W operand register
       status_wreg               : out std_logic;   --used to update status out when result stored in W register
       current_state_out 	 : out state
       );
end entity ex06_decoder;

architecture behavioural of ex06_decoder is

  	signal next_state : state := iFetch;
           
begin

  process(all)
    
	variable counter : integer := 0;

  begin
      
      if reset = '1' then
        next_state <= iFetch;  --start with this state when reset is 1 ie all cleared
        
        we_wregister         <= '0';  --turn off w register
        alu_enable 	     <= '0';  --turn off alu
        we_memory            <= '0';  --set memory write to off
        re_memory            <= '0';  --set memory read to off
        counter 	     :=  0 ;
        program_counter      <=  counter ;
        status_wreg          <= '0';

      elsif rising_edge(clk) then
        case next_state is
          
          when iFetch =>
           
                    we_wregister       <= '0';
                    alu_enable         <= '0';
                    we_memory          <= '0';
                    re_memory	       <= '0';
                    status_wreg        <= '0';
                    alu_opcode         <= instruction2opcode(instruction(13 downto 7));  --fetches the opcode
                   
                    if (instruction(13 downto 12) = "00") then  
              --BYTE ORIENTED instruction
                          alu_literal_address	 <= '0' & instruction(6 downto 0);  --gets address of f operand. Added 0, since addresses in memory are 8bits
                   --OBSERVE HERE THAT ADDRESS IS OBTAINED FROM INSTRUCTION. in PREVIOUS EXERCISE, ADDRESS WHICH WAS GIVEN to  MEMORY WAS OBTAINED USING A TESTBENCH 
                          sl_alu_mux             <= '0';  --selects line0 of mux. Output of mux is connected to "f" of alu.

                          --assert statement is a requirement mentioned in exercise 6
                          assert( ('0' & instruction(6 downto 0)) /= "00000011" ) report "Data is stored in status register (03h) of memory";
                          
                          --since CLRW and CLRF already have 00 literal in their procedure body, they dont need Mread stage.
                          if alu_opcode = CLRW or alu_opcode = CLRF or alu_opcode = NOP then
                            next_state <= Execute;
                          else
                            next_state <= Mread;
                          end if;  

                    elsif (instruction(13 downto 12) = "01") then  
              --BIT ORIENTED instruction
                          alu_literal_address   <= '0' & instruction(6 downto 0);
                          sl_alu_mux            <= '0';

                          assert( ('0' & instruction(6 downto 0)) /= "00000011" ) report "Data is stored in status register (03h) of memory";
                          
                          alu_bit_select        <= instruction(9 downto 7); --information for bit select operations
                          next_state	        <= Mread;

                    elsif (instruction(13 downto 12) = "11") then  
              --LITERAL ORIENTED instruction
                          alu_literal	        <= instruction(7 downto 0);
                          sl_alu_mux	        <= '1';  --selects line1 of mux
                          next_state	        <= Execute;  --literal operations do not need Mread state. operand is contained in Instruction word
                     end if;
                    
          when Mread =>

            	    we_wregister       <= '0';
                    alu_enable         <= '0';
                    we_memory          <= '0';
                    re_memory	       <= '1';  --memory is enabled for read operation
                    status_wreg        <= '0';      
                    next_state	       <= Execute;

          when Execute =>
                                      	            
            	    we_wregister       <= '0';
                    alu_enable         <= '1';  --alu is enabled
                    we_memory          <= '0';
                    re_memory	       <= '0';
                    status_wreg        <= '0';    
                    next_state	       <= Mwrite;

          when Mwrite =>

            	    next_state <= iFetch;
          	    alu_enable <= '0';
                    re_memory  <= '0';

                    if instruction(13 downto 12) = "00" then
                      	  if instruction(7) = '1' then  --d =1 means result is stored in memory
                            	we_memory 	 <= '1';  --memory write enable is turned on
                                we_wregister	 <= '0';  --w register write mode is turned off
                                status_wreg      <= '0';
                                counter 	 := counter + 1;
                                program_counter  <= counter;
                                
                          elsif instruction(7) = '0' then  --d=0 means result is stored in w register
                                we_memory	 <= '0';
                            	we_wregister	 <= '1';  --w register write mode is turned on
                                --since result is stored in w register, we need to make changes to memory.vhd code which takes care of status values in this case.
                                status_wreg      <= '1';  --update status out when result stored in w register
                                counter 	 := counter + 1;
                                program_counter  <= counter;
                          end if;

                     elsif instruction(13 downto 12) = "01" then  --bit oriented operations are stored in memory
                       	  we_memory 	   <= '1';  --memory write enable is turned on
                          we_wregister	   <= '0';
                          status_wreg      <= '0';
                          counter 	   := counter + 1;
                          program_counter  <= counter;

                     elsif instruction(13 downto 12) = "11" then  --literal oriented are stored in w register
                          we_wregister	   <= '1';  --w register write mode is turned on
                          status_wreg      <= '1';
                          we_memory	   <= '0';
                          counter 	   := counter + 1;
                          program_counter  <= counter;
                     end if;
        end case;                
      end if;                                       
  end process;                          	
                      	  
  cs :process(all) is
    begin
      if (reset ='1' and rising_edge(clk)) then
        current_state_out <= iFetch;
      elsif(rising_edge(clk)) then
        current_state_out <= next_state;
      end if;
  end process cs;

end architecture behavioural;

         
            
          
    
       
