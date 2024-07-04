library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

library work;
use work.ex06_alu_functions.all;
use work.ex06_alu_procedures.all;

entity tb_ex06 is
  end entity tb_ex06;

architecture structural of tb_ex06 is
-----------------------------------
--ALU COMPONENT
-----------------------------------
          component ex06_alu
            port(W      	: in std_logic_vector (7 downto 0);
                 f      	: in std_logic_vector (7 downto 0);
                 op             : in operation;
                 bit_select     : in std_logic_vector (2 downto 0);
                 status_in	: in std_logic_vector (2 downto 0);
                 result	        : out std_logic_vector (7 downto 0);
                 status	        : out std_logic_vector (2 downto 0);

                 alu_enable     : in std_logic
                 );
          end component ex06_alu;

-----------------------------------
--MEMORY COMPONENT
-----------------------------------

          component ex06_memory
            generic (memory_size : integer);
            port(data_in 	: in std_logic_vector (7 downto 0);
                 address 	: in std_logic_vector (7 downto 0);
                 memstatus_in   : in std_logic_vector (2 downto 0);
                 re 	        : in std_logic;
                 we 	        : in std_logic;
                 clk 	        : in std_logic;
                 reset 	        : in std_logic;
                 data_out 	: out std_logic_vector (7 downto 0);
                 memstatus_out 	: out std_logic_vector (2 downto 0);

                 memstatus_wreg : in std_logic
                 --status flag which tells to load the status register fmem(3)
                 --this flag is raised when "we" of memory is 0, which means that there
                 --is no active code which could load the status register. Hence this
                 --flag is specifically for the case when result from alu is stored in
                 --w register instead of memory.
                 );
          end component ex06_memory;

-----------------------------------
--DECODER COMPONENT
-----------------------------------

          component ex06_decoder
            port(instruction 	: in std_logic_vector (13 downto 0);
                 clk 	        : in std_logic;
                 reset 	        : in std_logic;

                 alu_enable 	: out std_logic;
                 alu_opcode 	: out operation;
                 alu_bit_select : out std_logic_vector (2 downto 0);        

                 re_memory		: out std_logic;
                 we_memory 		: out std_logic;
                 status_wreg	        : out std_logic;
                 alu_literal_address	: out std_logic_vector (7 downto 0);         
       
                 sl_alu_mux 	        : out std_logic;
                 alu_literal 	        : out std_logic_vector (7 downto 0);

                 we_wregister 	        : out std_logic;

                 program_counter	: out integer;

                 current_state_out	: out state
                 );
          end component ex06_decoder;

-----------------------------------
--MUX COMPONENT
-----------------------------------
          
          component ex06_mux
            port(memory_in 	: in std_logic_vector (7 downto 0);
                 literal_in	: in std_logic_vector (7 downto 0);
                -- clk	        : in std_logic;
                 select_line 	: in std_logic;
                 f_operand 	: out std_logic_vector (7 downto 0)
                 );
          end component ex06_mux;

-----------------------------------
--REGISTER COMPONENT
-----------------------------------

          component ex06_wregister
            port(data_in 	: in std_logic_vector (7 downto 0);
                 we_wregister 	: in std_logic;
                 reset 	        : in std_logic;
                 clk 	        : in std_logic;
                 data_out 	: out std_logic_vector (7 downto 0)
                 );
          end component ex06_wregister;

  -------------------------------------
  --SIGNAL DECLARATIONS
  -------------------------------------
          signal W_tb 	         : std_logic_vector (7 downto 0) := "00000000";
          signal f_tb            : std_logic_vector (7 downto 0) := "00000000";
          signal opcode_tb	 : operation;
          signal status_in_tb	 : std_logic_vector (2 downto 0) := "000";
          signal bit_select_tb	 : std_logic_vector (2 downto 0) := "000";
          signal alu_enable_tb   : std_logic := '0';
          signal status_tb	 : std_logic_vector (2 downto 0) := "000";
          signal result_tb 	 : std_logic_vector (7 downto 0) := "00000000";

          signal re_tb 	         : std_logic := '0';
          signal we_tb 	         : std_logic := '0';
          signal status_wreg_tb	 : std_logic := '0';
          --signal data_in_tb 	 : std_logic_vector (7 downto 0) := "00000000";
          --carried by result_tb. isnt it!!!
          signal data_out_tb	 : std_logic_vector (7 downto 0) := "00000000";
          signal address_tb 	 : std_logic_vector (7 downto 0) := "00000000";

          signal instruction_tb  : std_logic_vector (13 downto 0);
          signal select_line_tb  : std_logic;
          signal alu_literal_tb  : std_logic_vector (7 downto 0) := "00000000";
          signal we_wregister_tb : std_logic := '0';

          signal clk_tb	         : std_logic := '0';
          signal reset_tb 	 : std_logic := '1';

          signal program_counter_tb	 : integer;
          signal current_state_tb        : state; --used for looping an instruction in testbench
    
begin

     DUT1 : ex06_alu
       port map(W	        => W_tb,
                f	 	=> f_tb,
                op	 	=> opcode_tb,
                bit_select	=> bit_select_tb,
                alu_enable 	=> alu_enable_tb,
                status_in	=> status_in_tb,
                status	        => status_tb,
                result	        => result_tb
                );

     DUT2 : ex06_memory
       generic map(memory_size => 50)
       port map(data_in 	=> result_tb,
                address	        => address_tb,
                memstatus_in	=> status_tb,
                re	        => re_tb,
                we	        => we_tb,
                memstatus_wreg => status_wreg_tb,
                data_out	=> data_out_tb,
                memstatus_out  => status_in_tb,
                clk 	        => clk_tb,
                reset 	        => reset_tb
                );

     DUT3 : ex06_decoder
       port map(instruction		=> instruction_tb,
                alu_enable	        => alu_enable_tb,
                alu_bit_select 	        => bit_select_tb,
                alu_opcode	        => opcode_tb,
                alu_literal_address	=> address_tb,
                re_memory	        => re_tb,
                we_memory	        => we_tb,
                status_wreg	        => status_wreg_tb,
                sl_alu_mux	        => select_line_tb,
                alu_literal	        => alu_literal_tb,
                we_wregister 	        => we_wregister_tb,
                program_counter 	=> program_counter_tb,
                current_state_out 	=> current_state_tb,
                clk 	                => clk_tb,
                reset 	                => reset_tb
                );

     DUT4 : ex06_mux
       port map(memory_in 	=> data_out_tb,
                literal_in 	=> alu_literal_tb,
                select_line 	=> select_line_tb,
                --clk	        => clk_tb,
                f_operand       => f_tb
                );
     
     DUT5 : ex06_wregister
       port map(data_in 	=> result_tb,
                we_wregister	=> we_wregister_tb,
                data_out 	=> W_tb,
                clk 	        => clk_tb,
                reset 	        => reset_tb
                );

     process is

       		file in_file        : text open read_mode is "../vhdl/ex06_input_file.txt";
       		variable in_line    : line;
                variable instr_word :std_logic_vector(13 downto 0);

          begin

                
            	 reset_tb	 <= '0' after 7 ns;  --reset goes to zero after rising edge of clock comes
            	wait for 5 ns;
                clk_tb 	         <= not clk_tb;
                wait for 5 ns;   
                clk_tb 	         <= not clk_tb;
                wait for 5 ns;

                while not endfile(in_file) loop
                  readline(in_file, in_line);
                  read(in_line, instr_word);
                  instruction_tb <= instr_word;

                  clk_tb <= not clk_tb;
                  wait for 5 ns;
                  clk_tb <= not clk_tb;
                  wait for 5 ns;
                  --this above clock pulse should implement the iFetch state

                	while (current_state_tb /= Mwrite) loop
                          clk_tb <= not clk_tb;
                          wait for 5 ns;
                          clk_tb <= not clk_tb;
                          wait for 5 ns;
                        end loop;
                  
                end loop;
              wait;
           end process;
end architecture structural; 
                
     

  

