library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

-----------------------
--PACKAGE DECLARATION
-----------------------
package project_alu_functions is
	type operation is (ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, INCF, IORWF, MOVF, MOVWF, NOP, RLF, RRF, SUBWF, SWAPF, XORWF, BCF, BSF, ADDLW, ANDLW, IORLW, MOVLW, SUBLW, XORLW, CALL,GOTO,RETLW,RETRN);

        subtype word9 is std_logic_vector(8 downto 0);
        subtype word8 is std_logic_vector(7 downto 0);
        subtype word7 is std_logic_vector(6 downto 0);
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
        
        type operationType is (BYTEtype, BITtype, CTRLtype, NOP);
        function instructionType(instruction : std_logic_vector(13 downto 12)) return operationType;

        function instruction2opcode(instruction : std_logic_vector(13 downto 0)) return operation;

        type state is (iFetch, Mread, Execute, Mwrite);
          
end package project_alu_functions;

----------------------------------
--PACKAGE BODY
----------------------------------
package body project_alu_functions is
  
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

--i dont think this function is needed after ex5
      elsif op = "CALL" then return CALL;
      elsif op = "GOTO" then return GOTO;
      elsif op = "RETLW" then return RETLW;
      elsif op = "RETRN" then return RETRN;
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
  --Function which tells if carry out has occured from 8th bit in the result
  ----------------------------------------------------------------------------
  function msbFlag0 (out_result : in word1) return word1 is
    begin
      return out_result;
  end function msbFlag0;

  ----------------------------------------------------------------------------
  --Function which tells whether the operation is BIT, BYTE or LITERAL/CONTROL OPERATION
  ----------------------------------------------------------------------------
  function instructionType(instruction : std_logic_vector(13 downto 12)) return operationType is
    begin
      if instruction(13 downto 12) = "00" then
        return BYTEtype;
      elsif instruction(13 downto 12) = "01" then
        return BITtype;
      elsif instruction(13 downto 12) = "11" then
        return CTRLtype;
      else
        return NOP;
      end if;
  end function instructionType;

  -----------------------------------------------------
  --Function which converts instruction to opcode
  -----------------------------------------------------
  function instruction2opcode(instruction : std_logic_vector(13 downto 0)) return operation is
    begin
      --BYTE TYPE OPERATIONS
      if instruction(13 downto 8) = "000111" then
        return ADDWF;
      elsif instruction(13 downto 8) = "000101" then
        return ANDWF;
      elsif instruction(13 downto 7) = "0000011" then
        return CLRF;
      elsif instruction(13 downto 7) = "0000010" then
        return CLRW;
      elsif instruction(13 downto 8) = "001001" then
        return COMF;
      elsif instruction(13 downto 8) = "000011" then
        return DECF;
      elsif instruction(13 downto 8) = "001010" then
        return INCF;
      elsif instruction(13 downto 8) = "000100" then
        return IORWF;
      elsif instruction(13 downto 8) = "001000" then
        return MOVF;
      elsif instruction(13 downto 7) = "0000001" then
        return MOVWF;
      elsif instruction(13 downto 8) = "001101" then
        return RLF;
      elsif instruction(13 downto 8) = "001100" then
        return RRF;
      elsif instruction(13 downto 8) = "000010" then
        return SUBWF;
      elsif instruction(13 downto 8) = "001110" then
        return SWAPF;
      elsif instruction(13 downto 8) = "000110" then
        return XORWF;

      --BIT TYPE OPERATIONS
      elsif instruction(13 downto 10) = "0100" then
        return BCF;
      elsif instruction(13 downto 10) = "0101" then
        return BSF;

      --CTRL and LITERAL TYPE OPERATIONS        
      elsif (instruction(13 downto 8) = "111110") or (instruction(13 downto 8) = "111111") then
        return ADDLW;
      -----------------------------------------------------------------------------------
      elsif (instruction(13 downto 11) = "100") then
        return CALL;
      elsif (instruction(13 downto 11) = "101") then
        return GOTO;
      elsif (instruction(13 downto 8) = "1101") then
        --or (instruction(13 downto 8) = "110101") or (instruction(13 downto 8) = "110110") or (instruction(13 downto 8) = "110111") then
        return RETLW;
      elsif (instruction(13 downto 0) = "00000000001000" then
        return RETRN;
      -----------------------------------------------------------------------------------
      elsif instruction(13 downto 8) = "111001" then
        return ANDLW;
      elsif instruction(13 downto 8) = "111000" then
        return IORLW;
      elsif (instruction(13 downto 8) = "110000") or (instruction(13 downto 8) = "110001") or (instruction(13 downto 8) = "110010") or (instruction(13 downto 8) = "110011") then
        return MOVLW;
      elsif (instruction(13 downto 8) = "111100") or (instruction(13 downto 8) = "111101") then
        return SUBLW;
      elsif instruction(13 downto 8) = "111010" then
        return XORLW;

      else
        return NOP;
    end if;
  end function instruction2opcode;
                          
                           
end package body project_alu_functions;


  
