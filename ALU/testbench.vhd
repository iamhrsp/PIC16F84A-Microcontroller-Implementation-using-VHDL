library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.ex04_alu_functions.all;
use work.ex04_alu_procedures.all;

entity tb_ex04 is
  end entity tb_ex04;

architecture behavioural of tb_ex04 is

     signal a,b      :  word8;
     signal opc      :  operation;
                        --opcode has to be of the enumeration type "operation"
                        --and not string which you had intitially written.
     signal si,so,bs :  word3;
     signal rslt     :  word8;

begin

     dut : entity work.ex04_alu(behavioural) port map (W          => a,
                              f          => b,
                              op         => opc,
                              bit_select => bs,
                              status_in  => si,
                              status     => so,
                              result     => rslt );

    process is

      	     file in_file : text open read_mode is "../vhdl/ex04_input_file.txt";

             variable in_line   : line;
             variable opc_value : string(1 to 5);
             variable comma     : character;
             variable int_value : integer;

             variable out_line  : line;

             file out_file : text open write_mode is "../vhdl/ex04_output_file.txt";
  	begin
             while not endfile(in_file) loop
               readline(in_file,in_line);
               read(in_line,opc_value);
               opc <= str2op(opc_value);
             		--I had forgotten to use the function here

               read(in_line,comma);
               read(in_line,int_value);
               a <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_value,8));
          		--I had also forgotten to put bit value 8 above

               read(in_line,comma);
               read(in_line,int_value);
               b <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_value,8));

               read(in_line,comma);
               read(in_line,int_value);
               si <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_value,3));

               read(in_line,comma);
               read(in_line,int_value);
               bs <= STD_LOGIC_VECTOR(TO_UNSIGNED(int_value,3));

               wait for 10 ns;

               write(out_line,TO_INTEGER(UNSIGNED(rslt)));
               write(out_line,comma);
               write(out_line,so);
               		--Interested in directly producing three status out bits 
               writeline(out_file,out_line);
             end loop;

             wait;
     end process;
end architecture behavioural;             
