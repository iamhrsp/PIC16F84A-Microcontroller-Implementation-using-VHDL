library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

library work;
use work.project_alu_functions.all;
use work.project_alu_procedures.all;

entity project_decoder is
  port(instruction	         : in std_logic_vector(13 downto 0);
       clk	        	 : in std_logic;
       reset	  	         : in std_logic;
       alu_literal_address	 : out std_logic_vector(6 downto 0):= "0000000";  --Address of f operand in memory
       alu_bit_select		 : out std_logic_vector(2 downto 0):= "000";  --bit select input to alu
       alu_opcode		 : out operation; --this is an enumeration datatype described in packages.vhd and functions.vhd work files
       alu_literal	         : out std_logic_vector(7 downto 0):= "00000000"; --direct literal/operand from instruction to alu for control oriented operation
       program_counter           : out std_logic_vector(10 downto 0);
       
       alu_enable	         : out std_logic;  --enables or disables alu
       we_memory		 : out std_logic;  --write enables the memory
       re_memory	         : out std_logic;  --read enables the memory
       sl_alu_mux	         : out std_logic;  --select line of mux to alu. Used for selecting the operand to alu
       we_wregister	         : out std_logic;  --write enable W operand register
       status_wreg               : out std_logic;   --used to update status out when result stored in W register
       current_state_out 	 : out state
       );
end entity project_decoder;

architecture rtl of project_decoder is

  	signal next_state : state := iFetch;
  	signal counter    : std_logic_vector(10 downto 0); --Remember to modify the Mwrite operation. No counter increments there. It will dealt with in counter process

        component project_stack is
          port(clk	: in std_logic;
               reset 	: in std_logic;
               push	: in std_logic;
               pop	: in std_logic;
               data_in 	: in std_logic_vector(10 downto 0);
               data_out : out std_logic_vector(10 downto 0);
               );

          --lets see if any signal are to be used or not. YESSS
          signal push_sig  std_logic;
          signal pop_sig   std_logic;
          signal stack_in  std_logic_vector(10 downto 0);
          signal stack_out std_logic_vector(10 downto 0);
begin

  	ps: project_stack port map(clk	        =>	 clk, --stack component clock to decoder entity clock
                                   reset	=>	 reset,
                                   push	        => 	 push_sig,
                                   pop 	        =>	 pop_sig,
                                   data_in 	=> 	 stack_in,
                                   data_out 	=> 	 stack_out
                                   );
  countr : process(clk,reset)

  begin

          if rising_edge(clk) then
             if reset = '1' then
               counter <= (others => '0');
             elsif (next_state = Mwrite)
                 if (instruction(13 downto 11) = "100") or (instruction(13 downto 11) = "101") then  --call or goto instruction
                    counter   <=  instruction(10 downto 0);                  
                 elsif (instruction(13 downto 10) = "1101") or (instruction(13 downto 0) = "00000000001000")  --RETLW or RETURN instruction
                    counter   <=  stack_out;
                 else
                    counter   <=  counter + 1;
                 end if;
             else
                counter <= counter;
             end if;
           end if;
   end process countr;

   stk : process(clk,reset)

   begin

     if rising_edge(clk) then
        if reset = '1' then
            push <= '0';
            pop  <= '0';
        elsif (next_state = Execute) then
            if(instruction(13 downto 10) = "100") then
                push      <=  '1';
                pop 	  <=  '0';
                counter   <=  counter + 1;
                stack_in  <=  counter;
            elsif(instruction(13 downto 0) = "00000000001000") then
                push      <=  '0';
                pop 	  <=  '1';
            else
                push	  <=  '0';
                pop 	  <=  '0';
            end if;
         else
            push  <=  '0';
            pop   <=  '0';
         end if;
      end if;
   end process stk; 
                 

  fsm: process(all)
    
	variable counter : integer := 0;

  begin
      
      if reset = '1' then
        next_state <= iFetch;  --start with this state when reset is 1 ie all cleared
        
        we_wregister         <= '0';  --turn off w register
        alu_enable 	     <= '0';  --turn off alu
        we_memory            <= '0';  --set memory write to off
        re_memory            <= '0';  --set memory read to off
        program_counter      <=  (others => '0') ;
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
                          alu_literal_address	 <=  instruction(6 downto 0);  --gets address of f operand. Added 0, since addresses in memory are 8bits
                   --OBSERVE HERE THAT ADDRESS IS OBTAINED FROM INSTRUCTION. in PREVIOUS EXERCISE, ADDRESS WHICH WAS GIVEN to  MEMORY WAS OBTAINED USING A TESTBENCH 
                          sl_alu_mux             <= '0';  --selects line0 of mux. Output of mux is connected to "f" of alu.

                          --assert statement is a requirement mentioned in exercise 6
                          assert( ( instruction(6 downto 0)) /= "0000011" ) report "Data is stored in status register (03h) of memory";
                          
                          --since CLRW and CLRF already have 00 literal in their procedure body, they dont need Mread stage.
                          if alu_opcode = CLRW or alu_opcode = CLRF or alu_opcode = NOP then
                            next_state <= Execute;
                          else
                            next_state <= Mread;
                          end if;  

                    elsif (instruction(13 downto 12) = "01") then  
              --BIT ORIENTED instruction
                          alu_literal_address   <=  instruction(6 downto 0);
                          sl_alu_mux            <= '0';

                          assert( ( instruction(6 downto 0)) /= "0000011" ) report "Data is stored in status register (03h) of memory";
                          
                          alu_bit_select        <= instruction(9 downto 7); --information for bit select operations
                          next_state	        <= Mread;

                    elsif (instruction(13 downto 12) = "11") then  
              --LITERAL ORIENTED instruction
                          alu_literal	        <= instruction(7 downto 0);
                          sl_alu_mux	        <= '1';  --selects line1 of mux
                          next_state	        <= Execute;  --literal operations do not need Mread state. operand is contained in Instruction word

                    elsif (instruction(13 downto 11) = "101") or (instruction(13 downto 11) = "100") or (instruction(13 downto 10) = "1101") or (instruction(13 downto 0) = "00000000001000") then
                          next_state <=Execute;
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
                                --counter 	 := counter + 1;
                                --program_counter  <= counter;
                                
                          elsif instruction(7) = '0' then  --d=0 means result is stored in w register
                                we_memory	 <= '0';
                            	we_wregister	 <= '1';  --w register write mode is turned on
                                --since result is stored in w register, we need to make changes to memory.vhd code which takes care of status values in this case.
                                status_wreg      <= '1';  --update status out when result stored in w register
                                --counter 	 := counter + 1;
                                --program_counter  <= counter;
                          end if;

                     elsif instruction(13 downto 12) = "01" then  --bit oriented operations are stored in memory
                       	  we_memory 	   <= '1';  --memory write enable is turned on
                          we_wregister	   <= '0';
                          status_wreg      <= '0';
                         -- counter 	   := counter + 1;
                         -- program_counter  <= counter;

                     elsif instruction(13 downto 12) = "11" then  --literal oriented are stored in w register
                          we_wregister	   <= '1';  --w register write mode is turned on
                          status_wreg      <= '1';
                          we_memory	   <= '0';
                         -- counter 	   := counter + 1;
                         -- program_counter  <= counter;
                     end if;
        end case;                
      end if;

      program_counter  <=  counter;
  end process fsm;                          	
                      	  
  cs :process(clk,reset) is
    begin
      if rising_edge(clk) then
        if reset = '1' then
          current_state_out  <=  iFetch;
        else
          current_state_out  <=  next_state;
        end if;
      end if;
  end process cs;

end architecture rtl;

         
            
          
    
       
