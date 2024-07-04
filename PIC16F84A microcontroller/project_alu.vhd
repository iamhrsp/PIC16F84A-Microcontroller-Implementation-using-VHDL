library ieee;
use ieee.std_logic_1164.all;

library work;
use work.project_alu_functions.all;
use work.project_alu_procedures.all;

entity project_alu is
  port(alu_enable : in std_logic;
       W,f        : in std_logic_vector(7 downto 0);
       op         : in operation;      --defined as an enumeration type in func vhd file
       bit_select : in std_logic_vector(2 downto 0); --for BSF and BCF operations
       status_in  : in std_logic_vector(2 downto 0); --status in
       result : out std_logic_vector(7 downto 0);
       status : out std_logic_vector(2 downto 0)     --status out
       );
end entity project_alu;

architecture behavioural of project_alu is
  begin
    alu_function: process(W, f, op, bit_select,alu_enable) is
      begin
        if alu_enable = '1' then  --this condition is used in Execute state of
                                  -- finite state machine.
          case (op) is
            when ADDWF | ADDLW => ADDLW(W,f,status_in,status,result);
            when ANDWF | ANDLW => ANDLW(W,f,status_in, status,result);
            when CLRF	 => CLRF(W,f,status_in, status,result);
            when CLRW	 => CLRW(W,f,status_in, status,result);
            when COMF	 => COMF(W,f,status_in, status,result);
            when DECF        => DECF(W,f,status_in, status,result);
            when INCF        => INCF(W,f,status_in, status,result);
            when IORWF|IORLW => IORWF(W,f,status_in, status,result);
            when MOVF        => MOVF(W,f,status_in, status,result);
            when MOVLW       => MOVLW(W,f,status_in, status,result);
            when MOVWF       => MOVWF(W,f,status_in, status,result);
            when RLF         => RLF(W,f,status_in, status,result);
            when RRF         => RLF(W,f,status_in, status,result);
            when SUBWF|SUBLW => SUBWF(W,f,status_in, status,result);
            when SWAPF       => SWAPF(W,f,status_in, status,result);
            when XORWF|XORLW => XORWF(W,f,status_in, status,result);
            when BCF         => BCF(W,f,status_in,bit_select, status,result);
            when BSF         => BSF(W,f,status_in,bit_select, status,result);

            when RETLW	     => RETLW(W,f,status_in, status,result); 
            when RETRN       => NOP(W,f,status_in, status,result);
            when CALL        => NOP(W,f,status_in, status,result);
            when GOTO        => NOP(W,f,status_in, status,result);
            when NOP         => NOP(W,f,status_in, status,result);
--i dont think i need to write these cuz their funcionality will be described
--in decoder as a process(meaning they will run parallely). But i think for
--case sructure to operate correctly I need to include them and as well as
--others. If I am cautious about giving inputs then it is fine oherwise for
--reckless inputs one needs in write the others case as well.
--So I shall try writing others for these four extra operations and return them
--as NOP
            --when CALL	     => op <= CALL;
            when others	     => NOP(W,f,status_in, status,result);
         end case;
       end if;
   end process alu_function;
end architecture behavioural;
