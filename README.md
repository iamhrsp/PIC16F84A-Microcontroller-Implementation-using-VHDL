# PIC16F84A Microcontroller Implementation using VHDL

* This repository contains the VHDL coding projects from the Digital Microelectronics-II course which I took at Aalto University.

* Books followed : The student's guide to VHDL by Peter J Ashenden, A VHDL Primer by Jayaram Bhasker.

* Simulators used : Questa Sim 10.6
  
This project demonstrates modelling and implementation of the PIC16F84A microcontroller using VHDL, organized into various modules such as ALU, Memory, Decoder, and the final integration of the PIC microcontroller. This repository contains the VHDL code for various modules to implement this microcontroller from scratch, providing a deep understanding of its internal architecture and functioning. It also contains a study diary which I wrote throughout the duration of the course. The dairy has simple dairy entries which enables the reader to keep track of the developments and changes I made while wriring the VHDL code.

## Project Structure

The repository is organized into the following directories, each representing a crucial component of the microcontroller:

- **Multiplexer**: Getting started with writing simple VHDL code along with testbench.
- **Adders**: Implementing simple process adder, ripple carry adder and a process adder using VHDL, writing testbench and simulating to check its functionality.
- **ALU**: Arithmetic Logic Unit, responsible for executing arithmetic and logical operations. The datasheet of PIC16F84A is followed while implementinug the instruction set. A total of 18 instructions are implemented. 
- **Memory**: Implementation of the data memory. The instructions are provided by an input file.
- **Decoder**: Instruction decoder to interpret and execute instructions. The input is a 14-bit instruction word.
- **PIC**: Integration of all components to form the complete PIC16F84A microcontroller. The input is provided by a HEX file which is decoder for instructions.
