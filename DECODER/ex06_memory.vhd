library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex06_memory is
  generic(memory_size : integer);
  port(address   : in std_logic_vector(7 downto 0);
       data_in   : in std_logic_vector(7 downto 0):= "00000000";
       memstatus_in : in std_logic_vector(2 downto 0):= "000";
       reset     : in std_logic;
       re        : in std_logic;
       we        : in std_logic;
       clk       : in std_logic;
       memstatus_wreg : in std_logic;  --input from decoder about storing result in w register 
       data_out  : out std_logic_vector(7 downto 0):= "00000000";
       memstatus_out: out std_logic_vector(2 downto 0):= "000"
     );
end entity ex06_memory;

architecture behavioural of ex06_memory is

	type memtype is array(0 to memory_size-1) of std_logic_vector(7 downto 0);
        signal fmem :memtype;

begin

     memory:process(all)
       begin

	if rising_edge(clk) then

          if reset = '1' then
            fmem <= (others => "00000000");
          elsif(re = '1') then
            data_out   <= fmem(TO_INTEGER(UNSIGNED(address)));
            memstatus_out <= fmem(3)(2 downto 0);
          elsif(we = '1') then
          	if (address = "00000011") then
                  
            		fmem(TO_INTEGER(UNSIGNED(address))) <= data_in;
                else
            		fmem(TO_INTEGER(UNSIGNED(address))) <= data_in;
                        fmem(3)(2 downto 0)                 <= memstatus_in;
                end if;
           elsif(memstatus_wreg = '1') then  --When result is stored in w register
             fmem(3)(2 downto 0) <= memstatus_in;  --Status out from alu, which is basically connected to memstatus_in,
                                                  --goes into fmem(3). This
                                                  --extra condition is required
                                                  --to take care of the status
                                                  --out information, when the
                                                  --result is stored in w register.
          end if;
        end if;
     end process memory;
end architecture behavioural;
                                                               
            
            
