library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-----------------------
--PACKAGE DECLARATION
-----------------------
package ex04_alu_functions is
	type operation is (ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, INCF, IORWF, MOVF, MOVWF, NOP, RLF, RRF, SUBWF, SWAPF, XORWF, BCF, BSF, ADDLW, ANDLW, IORLW, MOVLW, SUBLW, XORLW);

        subtype word9 is std_logic_vector(8 downto 0);
        subtype word8 is std_logic_vector(7 downto 0);
        subtype word5 is std_logic_vector(4 downto 0);
        subtype word4 is std_logic_vector(3 downto 0);
        subtype word3 is std_logic_vector(2 downto 0);
        subtype word1 is std_logic;
        --These subtypes will be used in procedure vhd file. Writing it like
        --this declutters the code in the procedure vhd file as it already
        --contains much. I could have written these declarations there as well.
                -- I had initially written these declataions after the function
                -- declarations but then realised to move it above them since
                -- functions do use 'wordN' datatype and I asuume it might
                -- create some problems.
        --Some "wordNs are used in this vhd file and some are used in the
        --procedure vhd file.

        function str2op (op: in string(1 to 5)) return operation;
        --Here while writing I observed some things, 1. return has to be
        --obviously of enumeration type 'operation'. 2. the variable name, i
        --chose it to be same as my alu input 'op'. 3. data type of this i had
        -- chosen std_logic_vector but maaasss had suggested string(1 to 5)

        function zeroFlag2 (out_result : in word9) return word1 ;
        --While writing this declaration, I was not sure what to put in return,
        --turns out it has to be the datatype. 

        function nibbleFlag1 (out_result : in word1) return word1;
        function msbFlag0    (out_result : in word1) return word1;
        
        
  
end package ex04_alu_functions;

----------------------------------
--PACKAGE BODY
----------------------------------
package body ex04_alu_functions is
  
  -------------------------------------------------------------------------------------
  --Function which converts Strings in out input file to OPCODE according to datasheet
  ------------------------------------------------------------------------------------
  function str2op(op : in string(1 to 5)) return operation is
    begin
      if    op = "ADDWF" then return ADDWF;
      elsif op = "ANDWF" then return ANDWF;
      elsif op = "CLRF "  then return CLRF;
      elsif op = "CLRW "  then return CLRW;
      elsif op = "COMF "  then return COMF;
      elsif op = "DECF "  then return DECF;
      elsif op = "INCF "  then return INCF;
      elsif op = "IORWF" then return IORWF;
      elsif op = "MOVF "  then return MOVF;
      elsif op = "MOVLW" then return MOVLW;
      elsif op = "MOVWF" then return MOVWF;
      elsif op = "RLF  "   then return RLF;
      elsif op = "RRF  "   then return RRF;
      elsif op = "SUBWF" then return SUBWF;     
      elsif op = "SWAPF" then return SWAPF;
      elsif op = "XORWF" then return XORWF;
      elsif op = "XORLW" then return XORLW;
      elsif op = "BCF  "   then return BCF;
      elsif op = "BSF  "   then return BSF;
      elsif op = "NOP  "   then return NOP;
                              
      elsif op = "SUBLW" then return SUBLW;                        
      elsif op = "IORLW" then return IORLW;                        
      elsif op = "ADDLW" then return ADDLW;
      elsif op = "ANDLW" then return ANDLW;
    end if;
  end function str2op;
                              
  -------------------------------------------------------
  --Function which tells whether result is zero or not
  -------------------------------------------------------
  function zeroFlag2(out_result : in word9) return word1 is
    begin
      if out_result = "000000000" then
        return '0';
      else
        return '1';
      end if;
  end function zeroFlag2;
      
  -----------------------------------------------------------------
  --Function which tells whether carry out has occured from 4th bit
  -----------------------------------------------------------------
  function nibbleFlag1(out_result : in word1) return word1 is
    begin
      if out_result = '0' then
        return '0';
      else
        return '1';
      end if;
  end function nibbleFlag1;
      --There is another way to write it though. Observe that output is same as
      --input. Thus no need to write the if statement. Only a return will do
      --the job.
      		--Also observe that for the MSB carry no need to write another
                --function since the logic is same. Thus same function can be
                --called to check for MSB carry as well. I will write the next
                --function using this alternate and simple logic below.

  ----------------------------------------------------------------------------
  --Function which tells where carry out has occured from 8th bit in the result
  ----------------------------------------------------------------------------
  function msbFlag0 (out_result : in word1) return word1 is
    begin
      return out_result;
  end function msbFlag0;

end package body ex04_alu_functions;


  
