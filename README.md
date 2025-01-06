# PIC16F84A Microcontroller Implementation using VHDL

* This repository contains the VHDL coding projects from the Digital Microelectronics-II course which I took at Aalto University.

* Books followed : The student's guide to VHDL by Peter J Ashenden, A VHDL Primer by Jayaram Bhasker.

* Simulators used : Questa Sim 10.6
  
This project demonstrates modelling and implementation of the PIC16F84A microcontroller using VHDL, organized into various modules such as ALU, Memory, Decoder, and the final integration of the PIC microcontroller. This repository contains the VHDL code for various modules to implement this microcontroller from scratch, providing a deep understanding of its internal architecture and functioning. It also contains a study diary which was written throughout the duration of the course. The dairy has simple dairy entries which enables the reader to keep track of the developments and changes which were made while wriring the VHDL code.

## Architecture of PIC microcontroller
![The highlighted region shows the part of the microcontroller implemented in this project](PIC16F84A-microcontroller/pic)

## Project Structure

The repository is organized into directories, each representing a key component of the microcontroller. These directories contain further details about what has been implemented. This structure also reflects the order followed during the microcontroller's design and development:

- **Multiplexer**: Getting started with writing simple VHDL code along with testbench.
- **Adders**: Implementing simple process adder and ripple carry adder using VHDL, writing testbenches and simulating to check their functionality.
- **ALU**: Arithmetic Logic Unit, responsible for executing arithmetic and logical operations. The datasheet of PIC16F84A is followed while implementinug the instruction set. A total of 18 instructions are implemented. 
- **Memory**: Implementation of the data memory. The instructions are provided by an input file.
- **Decoder**: Instruction decoder to interpret and execute instructions. The input is a 14-bit instruction word.
- **PIC**: Integration of all components to form the complete PIC16F84A microcontroller. The input is provided by a HEX file which is decoder for instructions.
