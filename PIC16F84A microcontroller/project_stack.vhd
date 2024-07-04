library ieee;
use ieee.std_logic_1164;

entity project_stack is
  port(clk 	: in std_logic;
       reset	: in std_logic;
       push 	: in std_logic;
       pop 	: in std_logic;
       data_in 	: out std_logic_vector(10 downto 0);
       data_out : out std_logic_vector(10 downto 0)
       );
end entity project_stack;

architecture rtl of project_stack is

        signal index: integer range 0 to 7 := 0;
        type stack_array is array (0 to 7) of std_logic_vector(10 downto 0);
        signal stack : stack_array; 

begin

     process(clk, reset)

     begin

       	  if reset = '1' then
               stack <= (others =>(others => '0'));
               index <= '0';
	  elsif rising_edge(clk) then
               if push = '1' then
                  if (index = 7) then
                      index <= 0;
                      stack(index) <= data_in;
                     -- index := index + 1;
                  else
                      index := index + 1;
                      stack(index) <= data_in;                     
                  end if;
                elsif pop = '1' then
                  if (index = 0) then
                      data_out <= stack(index);
                      index <= 7;
                  else
                      data_out <= stack(index);
                      index <= index - 1;
                  end if;
                end if;
            end if;
         
     data_out <= stack(index); --data on TOS

end architecture rtl;
