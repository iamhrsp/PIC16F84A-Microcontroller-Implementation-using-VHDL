library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_memory is
  generic(memory_size : integer);
  port(address   : in std_logic_vector(6 downto 0); --rememberToChangeTo6InDecoderAndElsewhere
       data_in   : in std_logic_vector(7 downto 0):= "00000000";
       memstatus_in : in std_logic_vector(2 downto 0):= "000";
       reset     : in std_logic;
       re        : in std_logic;
       we        : in std_logic;
       clk       : in std_logic;
       memstatus_wreg : in std_logic;  --input from decoder about storing result in w register 
       data_out  : out std_logic_vector(7 downto 0):= "00000000";
       memstatus_out: out std_logic_vector(2 downto 0):= "000";

       porta	 : out std_logic_vector(4 downto 0);
       portb 	 : out std_logic_vector(7 downto 0)
     );
end entity project_memory;

architecture rtl of project_memory is

	type memtype is array(0 to 79) of std_logic_vector(7 downto 0);
        signal bank0,bank1 :memtype;

begin

     memory:process(all)

     begin

	if rising_edge(clk) then

          if reset = '1' then
                  bank0 <= (others => "00000000");
                  bank1 <= (others => "00000000");
                  porta <= (others => '0');
                  portb <= (others => '0');
          --READ
          ---------
          elsif(re = '1') then

            	  --PORTA PORTB direct connection
            	  ---------------------------------
            	  porta <= bank0(5)(4 downto 0);
                  portb <= bank0(6)(7 downto 0);

                  --Indirect Addressing Read
                  ---------------------------------                  
                  if(address = "0000000") then       --Read from address 00h
                    
                          if( bank0(4)(7)='0') then  --Bank 0 is Selected Based on 7thBit of FSR register
                               --7 bits of FSR register(04h) is used as address to locate the data in bank0
                              data_out      <= bank0(TO_INTEGER(UNSIGNED(bank0(4)(6 downto 0))));  --Data from bank 0 address is read      
                              memstatus_out <= bank0(3)(2 downto 0);  --STATUS register bits are read 
                          elsif( bank0(4)(7)='1') then  --Bank 1 is Selected
                              data_out      <= bank1(TO_INTEGER(UNSIGNED(bank1(4)(6 downto 0))));  --Data from bank 1 address is read
                              memstatus_out <= bank1(3)(2 downto 0);
                          end if;
                          
                  --Direct Addressing Read--All other addresses except 00h
                  ---------------------------------
                  else
                          if(bank0(3)(5)='0') then  --5th Bit of STATUS register selects the bank. Bank 0 is selected. 
                              data_out      <= bank0(TO_INTEGER(UNSIGNED(address)));  --Data from the bank0 address is read
                              memstatus_out <= bank0(3)(2 downto 0);
                          elsif(bank0(3)(5)='1') then  --Bank 1 is selected
                              data_out      <= bank1(TO_INTEGER(UNSIGNED(address)));  --STATUS register bits are read
                              memstatus_out <= bank1(3)(2 downto 0);
                          end if;
                  end if;
              
	  --WRITE
          --------
          elsif(we = '1') then  --For Writing to Memory
                  
                  if(address = "0000011") then  --Write address is STATUS register
                          bank0(3) <= data_in;  --Write data to STATUS register
                         
                   --Indirect Addressing Write
                  ---------------------------------
                  elsif(address = "0000000") then      --Write address is at 00h
                          if (bank0(3)(5) = '0') then  --Bank 0 is selected
                            	bank0(TO_INTEGER(UNSIGNED(bank0(4)(6 downto 0)))) <= data_in;
                          elsif (bank0(3)(5) = '1') then  --Bank 1 is selected
                            	bank1(TO_INTEGER(UNSIGNED(bank1(4)(6 downto 0)))) <= data_in;
                          end if;
                        --bank0(3) <= memstatus_in;
                            --skipping status update here. Indirect
                            --addressing can also point to STATUS register.

                  --Direct Addressing Write--All other addresses except 00h
                  ---------------------------------
                  else  
                        
                    	  if bank0(3)(5) = '0' then    --Bank 0 is selected			        
                            	bank0(TO_INTEGER(UNSIGNED(address))) <= data_in;  --Write data to bank0 address

                                 --statusBITS updation will be taken care of at the end for both bank0 and bank1
                                
                          elsif bank0(3)(5) = '1' then --Bank 1 is selected
                            	if (address = "0000010") then      --PCL register is same for both banks
                                  	bank0(2) <= data_in;
                                elsif (address = "0000100") then   --FSR register is same for both banks
                                  	bank0(4) <= data_in;
                                elsif (address = "0001010") then   --PCLATH register is same for both banks
                                  	bank0(10) <= data_in;
                                elsif (address = "0001011") then   --INTCON register is same for both banks
                                  	bank0(11) <= data_in;
                                elsif (TO_INTEGER(UNSIGNED(address)) >= 12) then   --from 12 to 79 bank1 register are mapped to bank0
                                	bank0(TO_INTEGER(UNSIGNED(address))) <= data_in;  --data is sent to bank0 due to mapped access

				--if none of these address, then put the data at the address in Bank 1
                                else
                                  	bank1(TO_INTEGER(UNSIGNED(address))) <= data_in;
                                end if;
			  end if;
		
                        	--Update the status bits after write operation
                          bank0(3)(2 downto 0) <= memstatus_in;

                   end if;

          --STATUS when W-REGISTER WRITE
          --------------------------------
          elsif(memstatus_wreg = '1') then
            	   bank0(3)(2 downto 0) <= memstatus_in;
          end if;
        end if;

        --MAPPING THE REGISTERS IN THE BANKS
        -------------------------------------
        bank1(0)   <= bank0(0);
        bank1(2)   <= bank0(2);
        bank1(3)   <= bank0(3);
        bank1(4)   <= bank0(4);
        bank1(10)  <= bank0(10);
        bank1(11)  <= bank0(11);

        for i in 12 to 79 loop
          	bank1(i) <= bank0(i);
        end loop;
    end process memory;
end architecture rtl;    
