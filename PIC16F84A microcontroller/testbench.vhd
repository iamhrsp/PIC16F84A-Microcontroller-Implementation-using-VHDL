library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_unsigned.all;

library work;
use work.read_intel_hex_pack.all;
use work.project_alu_functions.all;
use work.project_alu_procedures.all;

entity tb_project_ori is
  end entity tb_project_ori;

architecture structural of tb_project_ori is
-----------------------------------
--PIC COMPONENT
-----------------------------------
          component pic is
            port(signal instruction_pic : in std_logic_vector(13 downto 0);
                 signal clk 	         : in std_logic;
                 signal reset 	         : in std_logic;
                 signal porta_pic 	 : out std_logic_vector(4 downto 0);
                 signal portb_pic 	 : out std_logic_vector(7 downto 0);
                 signal pc_pic 	 : out std_logic_vector(10 downto 0)                
                 );
          end component pic;


  -------------------------------------
  --SIGNAL DECLARATIONS
  -------------------------------------
          signal instruction_tb : std_logic_vector(13 downto 0);
          signal clk_tb         : std_logic;
          signal reset_tb	: std_logic;
          signal porta_tb	: std_logic_vector(4 downto 0);
          signal portb_tb	: std_logic_vector(7 downto 0);
          signal pc_tb	        : std_logic_vector(10 downto 0):="00000000000" ;
    
begin

     DUT : pic
       port map(instruction_pic => instruction_tb,
                clk	        => clk_tb,
                reset 	        => reset_tb,
                porta_pic 	=> porta_tb,
                portb_pic 	=> portb_tb,
                pc_pic 	        => pc_tb                
                );    

      process is
		
       		variable program_memory : program_array := (others => (others => '0'));       		

          begin

          	read_ihex_file("../piklab/my_first_asml.hex", program_memory);
                
	--	data <= program_memory
                reset_tb <= '1';
                clk_tb   <= '1';
                wait for 5 ns;
                reset_tb <= '0';
                clk_tb   <= '0';
                wait for 5 ns;   --At this point clk is waiting to go to rising edge with reset = 0

                for I in 0 to 150 loop   --to make the simulation run for a finite time
                                
                	instruction_tb <= program_memory(TO_INTEGER(UNSIGNED(pc_tb)));
                        --Program counter updates after every Mwrite state.
                        --Based on program counter, pick instructions from
                        --program memory and give to instruction_tb signal

                        clk_tb <= not clk_tb;
                	wait for 5 ns;
                	clk_tb <= not clk_tb;
                        wait for 5 ns;

                end loop;             
                wait;
                       
           end process;
end architecture structural; 
                
     

  

