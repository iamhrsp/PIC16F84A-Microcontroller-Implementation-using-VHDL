 
Memory implementation for microcontroller 
===========================================

**Book:** Peter J. Ashenden, *``The designer's guide to VHDL''*, 3rd edition

**Goal:** Learn the basics about memory implementations. 

Acquainted with  the following chapters: 5.2, 21 (particularly 21.5 and 21.6).

Things learnt:
*  Edge sensitive processes
*  Synchronous logic 
*  Memory implementations
*  Design for synthesis

Pre-exercise task:
------------------

Design a generic  memory block for the  data memory
to be used together with the ALU. You may use
generics for parametrization of the width and address space of the memory.
Feel free to add functionality you find necessary, if you like (such as write enable, read enable, reset, etc).

Exercise task:
--------------

Write a test bench for the ALU and memory.

PROGRAM FILE: You may use the test containing the whole
instruction set of ALU you wrote for the 4th exercise.  

DATA MEMORY: Modify your setup so that one of the ALU operands is read from the memory, 
and the  result is always written to the memory. You may assume that
the W register input is constant, or defined by your input file. You also do not
write to W register.   
**Note:** This differs from the PIC operation, but it simplifies this
exercise.

STATUS REGISTER: It is located at address ``03h''. 
*  Should be read/write addressable normally with memory address.
*  Should have dedicated input and output connected to corresponding
        ports of the ALU.
*  If an operation writes to the  memory address ``03h'', that address
        has two sources of data: the dedicated status register input, and the memory
        data input. In this case, the latter should have precedence.

Other signals can be read from file, generated within the testbench, or
they can even be constants. The purpose of the exercise is to develop memory block and debug
it.

