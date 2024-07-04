library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

library work;
use work.project_functions.all;
use work.project_procedures.all;


entity PIC16F84A is
  port(instruction_pic : in std_logic_vector(13 downto 0);
       clk	      : in std_logic;
       reset	      : in std_logic;
       porta_pic      : out std_logic_vector(4 downto 0);
       portb_pic      : out std_logic_vector(7 downto 0);
       pc_pic 	      : out std_logic_vector(10 downto 0);
       );
end entity PIC16F84A;

architecture rtl of PIC16F84A is

		signal sig_alu_enable : word1;
                signal sig_W, sig_f, sig_result : word8;
                signal sig_opcode : operation;
                signal sig_bit_select, sig_status_in, sig_status : word3;

                signal sig_address : word7;
                signal sig_stus_up_when_wreg : word1;
                signal sig_memory_in, sig_portb : word8;
                signal sig_porta : std_logic_vector(4 downto 0);

                signal sig_instruction :std_logic_vector(13 downto 0);
                signal sig_alu_literal : word8;
                signal sig_pc : std_logic_vector(10 downto 0);
                signal sig_we_memory, sig_re_memory, sig_select_line, sig_wenable_wreg : word1;
                signal sig_current_state : state;
                
  
begin

     ALU : entity work.project_alu(behavioural)
       		port map(alu_enable 	=> sig_alu_enable,
                  	 W 		=> sig_W,
                         f 		=> sig_f,
                         op 		=> sig_opcode,
                         bit_select	=> sig_bit_select,
                         status_in	=> sig_status_in,
                         result 	=> sig_result,
                         status 	=> sig_status
                         );

     Memory : entity work.project_memory(rtl)
       		port map(address 	=> sig_address,
                         data_in 	=> sig_result,    -----
                         memstatus_in 	=> sig_status,    -----
                         reset 		=> sig_reset,	  -----
                         re 		=> sig_re_memory, -----
                         we 		=> sig_we_memory, -----
                         clk 		=> sig_clk,	  -----
                         memstatus_wreg => sig_stus_up_when_wreg,
                         data_out 	=> sig_memory_in,
                         memstatus_out  => sig_status_in, -----
                         porta 		=> sig_porta,
                         portb 		=> sig_portb
                         );

     Decoder : entity project_decoder(rtl)
       		port map(instruction 	     => sig_instruction,
                         clk 	             => sig_clk,   -----
                         reset               => sig_reset,   -----
                         alu_literal_address => sig_address,   -----
                         alu_bit_select      => sig_bit_select,   -----
                         alu_opcode 	     => sig_opcode,   -----
                         alu_literal 	     => sig_alu_literal,
                         program_counter     => sig_pc,
                         alu_enable 	     => sig_alu_enable,   -----
                         we_memory 	     => sig_we_memory,
                         re_memory 	     => sig_re_memory,
                         sl_alu_mux 	     => sig_select_line,
                         we_wregister 	     => sig_wenable_wreg, 
                         status_wreg 	     => sig_stus_up_when_wreg,  -----
                         current_state_out   => sig_current_state
                         );

     Mux : entity project_mux(rtl)
       		port map(memory_in 	=> sig_memory_in,  -----
                         literal_in	=> sig_alu_literal,  -----
                         select_line 	=> sig_select_line,  -----
                         f_operand 	=> sig_f,  -----
                         );

     Wregister: entity work.project_wregister(rtl)
       		port map(data_in 	=> sig_result,  -----
                         clk 	        => sig_clk,  -----
                         we_wregister 	=> sig_wenable_wreg,  -----
                         reset 	        => sig_reset,  -----
                         data_out 	=> sig_W  -----
                         );

     instruction_pic	<= sig_instruction;
     clk		<= sig_clk;
     reset 	        <= sig_reset;
     pc_pic 	        <= sig_pc;
     porta_pic	        <= sig_porta;
     portb_pic	        <= sig_portb;
end architecture rtl;
