library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library work;
use work.ex04_alu_functions.all;


----------------------------------
--PACKAGE DECLARATION
----------------------------------
package ex04_alu_procedures is
  --1--
  procedure ADDLW(signal W,f       : in  word8;
                  signal status_in : in  word3;                  
                  signal status    : out word3;
                  signal result    : out word8
                  );
  --2--
  procedure ANDLW(signal W,f      : in word8;
                  signal status_in: in word3;
                  signal status   : out word3;
                  signal result   : out word8
                  );
  --3--
  procedure CLRF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --4--
   procedure CLRW(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --5--
   procedure COMF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --6--
   procedure DECF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --7--
   procedure INCF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --8--
    procedure IORWF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --9--
    procedure MOVF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --10--
    procedure MOVLW(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --11.--
    procedure MOVWF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --12--
    procedure RLF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --13--
    procedure SUBWF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
   --14--
    procedure SWAPF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );

  --15--
    procedure XORWF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );
  --16--
    procedure BCF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                  signal bit_select : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );

  --17--
    procedure BSF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                  signal bit_select : in word3;
                 signal status    : out word3;
                 signal result    : out word8
                 );

   --18--
    procedure NOP(signal W,f 	  : in word8;
                 signal status_in : in word3;                  
                 signal status    : out word3;
                 signal result    : out word8
                 );

end package ex04_alu_procedures;
-----------------------------------
--PACKAGE BODY
-----------------------------------
package body ex04_alu_procedures is
  --1. ADDLW
    procedure ADDLW(signal W,f     : in  word8;
                  signal status_in : in  word3;                  
                  signal status    : out word3;
                  signal result    : out word8) is
      variable temp9 : word9;
      variable temp5 : word5;

      begin
        temp9 := STD_LOGIC_VECTOR((UNSIGNED('0' & W)) + (UNSIGNED('0' & f)));
        temp5 := STD_LOGIC_VECTOR((UNSIGNED('0' & W(3 downto 0))) +
                                   (UNSIGNED('0' & f(3 downto 0))));
        status(2) <= zeroFlag2(temp9);
        status(1) <= nibbleFlag1(temp5(temp5'left));
        status(0) <= msbFlag0(temp9(temp9'left));

        result <= temp9(7 downto 0);
     end procedure ADDLW;
        --Check if you change downto with wordN values
        --Check if removing status_in from parameter list affects the result
        --Check if changing the name of out_result to input changes anything.
      
  --2. ANDLW    
    procedure ANDLW(signal W,f      : in word8;
                  signal status_in: in word3;
                  signal status   : out word3;
                  signal result   : out word8) is

      	variable temp8: word8;
      begin
        temp8     := W and f;
        status(2) <= zeroFlag2('0' & temp8);
                     --Observe how the 9th bit in the zero flag function is
                     --taken care of here.
        status(1) <= status_in(1);
        status(0) <= status_in(0);
		     --Finally I understood the role of including status_in
                     --register. The input status register is used to update
                     --the output status register.
        result    <= temp8;
     end procedure ANDLW;

  --3. CLRF
     procedure CLRF(signal W,f 	  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is
         
       begin
         result	   <= "00000000";
         status(2) <= '1'; --zeroFlag(f);
         		--Here there is no need to call the function, since the
                        --result is known to be 0, hardwired 1 can be put into
                        --the status(2)
         status(1) <= status_in(1);
         status(0) <= status_in(0);
         result    <= f;
                      --There was a suggestion to put direct 00h in result
                      --instead of updating f register. Need to check that in
                      --testbench whether it will give the correct result or not
     end procedure CLRF;
        
   --4.-- CLRW
       procedure CLRW(signal W,f  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is
         begin
           -- W         <= "00000000";
           --cannot drive signal W of mode IN
           result    <= x"00";
           status(2) <= '1';
           status(1) <= status_in(1);
           status(0) <= status_in(0);
       end procedure CLRW;

   --5.-- COMF
       procedure COMF(signal W,f  : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

            variable temp8 : word8; 
         begin
           temp8     := not(f);
           result    <= temp8;
           status(2) <= zeroFlag2('0' & temp8);
           status(1) <= status_in(1);
           status(0) <= status_in(0);
         end procedure COMF;

    --6.-- DECF
      procedure DECF(signal W,f   : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp8 : word8;
        begin
          temp8     := f - "00000001";
          result    <= temp8;
          status(2) <= zeroFlag2('0' & temp8);
          status(1) <= status_in(1);
          status(0) <= status_in(0);
      end procedure DECF;

    --7.-- INCF
      procedure INCF(signal W,f   : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

        variable temp8 : word8;
      begin
        temp8     := f + "00000001";
        result    <= temp8;
        status(2) <= zeroFlag2('0' & temp8);
        status(1) <= status_in(1);
        status(0) <= status_in(0);
      end procedure INCF;

     --8.--IORWF
        procedure IORWF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

          variable temp8: word8;

        begin
          temp8  := W or f;
          result <= temp8;
          status(2) <= zeroFlag2('0' & temp8);
          status(1) <= status_in(1);
          status(0) <= status_in(0);
        end procedure IORWF;

      --9.--MOVF
         procedure MOVF(signal W,f: in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp8 : word8;

         begin
           temp8     := f;
           result    <= temp8;
           status(2) <= zeroFlag2('0' & temp8);
           status(1) <= status_in(1);
           status(0) <= status_in(0);

         end procedure MOVF;

      --10--MOVLW
         procedure MOVLW(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp8: word8;

         begin
           temp8 := f;      
           result <= temp8;

           status <= status_in;
                     --Have to verify whether this type of copying works or not.

         end procedure MOVLW;

      --11--MOVWF
         procedure MOVWF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp8 : word8;

         begin
           temp8 := W;      
           result <= temp8;

           status <= status_in;
         end procedure MOVWF;

      --12.-- RLF
         procedure RLF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           begin
             status(0) <= f(7);
             result    <= f(6 downto 0) & status_in(0);
             status(2) <= status_in(2);
             status(1) <= status_in(1);
         end procedure RLF;

      --13.--RRF
         procedure RRF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is
           begin
             status(0) <= f(0);
             result    <= status_in(0) & f(7 downto 1);
             status(2) <= status_in(2);
             status(1) <= status_in(1);
         end procedure RRF;

      --14.--SUBWF or SUBLW
         procedure SUBWF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp9: word9;
           variable temp5: word5;
         begin
           if f<=W then
             status(0) <= '1';
           else
             status(0) <= '0';
           end if;
           
           temp9 := STD_LOGIC_VECTOR('0' & UNSIGNED(f) - ('0' & UNSIGNED(W)));
           temp5 := STD_LOGIC_VECTOR('0' & f(3 downto 0) - ('0' & W(3 downto 0)));
           status(1) <= nibbleFlag1(temp5(temp5'left));
           status(0) <= msbFlag0(temp9(temp9'left));

           result <= temp9(7 downto 0);
        end procedure SUBWF;

     --15.--SWAPF
         procedure SWAPF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

          -- variable temp4 : word4;
         begin
          -- temp4 <= f(3 downto 0);
          -- f(3 downto 0) <= f(7 downto 4);
          -- f(7 downto 4) <= temp4;
          -- result <= f;
           --much easier
           result <= f(3 downto 0) & f(7 downto 4);
           status(2) <= status_in(2);
           status(1) <= status_in(1);
           status(0) <= status_in(0);
         end procedure SWAPF;

     --16.--XORWF or XORLW
         procedure XORWF(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

           variable temp8 : word8;

           begin
             temp8 := W xor f;
             status(2) <= zeroFlag2('0' & temp8);
             status(1) <= status_in(1);
             status(0) <= status_in(0);

             result <= temp8;
          end procedure XORWF;

       --16.--BCF
         procedure BCF(signal W,f : in word8;
                 signal status_in : in word3;
                  signal bit_select : in word3; --SPECIFIES WHICH BIT TO SELECT
                 signal status    : out word3;
                 signal result    : out word8) is

           variable pos   : word8;
           variable temp8 : word8;

         begin
           pos := "00000001";
           temp8 := f and not(STD_LOGIC_VECTOR(   (SHIFT_LEFT(UNSIGNED(pos), TO_INTEGER( UNSIGNED(bit_select) ) )   ) ) ) ;
           status(2) <= status_in(2);
           status(1) <= status_in(1);
           status(0) <= status_in(0);
           result <= temp8;
        end procedure BCF;

      --17.--BSF
         procedure BSF(signal W,f : in word8;
                 signal status_in : in word3;
                  signal bit_select : in word3; --SPECIFIES WHICH BIT TO SELECT
                 signal status    : out word3;
                 signal result    : out word8) is

           variable pos : word8;
           variable temp8 : word8;

         begin
           pos := "00000001";
           temp8 := f or (STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED(pos), TO_INTEGER(UNSIGNED(bit_select))) ));
           status(2) <= status_in(2);
           status(1) <= status_in(1);
           status(0) <= status_in(0);
           result <= temp8;
        end procedure BSF;

      --18.--NOP
         procedure NOP(signal W,f : in word8;
                 signal status_in : in word3;
                 signal status    : out word3;
                 signal result    : out word8) is

             variable temp8 : word8;
             variable temp3 : word3;

           begin
             temp8 := result;
             result <= temp8;
             temp3 := status;
             status <= temp3;
         end procedure NOP;   
  
end package body ex04_alu_procedures;
