library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ex04_alu_functions.all;
use work.ex04_alu_procedures.all;

entity ex04_alu is
  port(W,f        : in std_logic_vector(7 downto 0);
       op         : in operation;      --defined as an enumeration type in func vhd file
       bit_select : in std_logic_vector(2 downto 0); --for BSF and BCF operations
       status_in  : in std_logic_vector(2 downto 0); --status in
       result : out std_logic_vector(7 downto 0);
       status : out std_logic_vector(2 downto 0)     --status out
       );
end entity ex04_alu;

architecture behavioural of ex04_alu is
  begin
    alu_function: process(W, f, op, bit_select) is
      begin
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
        when NOP         => NOP(W,f,status_in, status,result);
     end case;
  end process alu_function;
end architecture behavioural;
