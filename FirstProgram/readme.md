Multiplexer, Writing a testbench and simulating
==================================================

**Book:** Peter J. Ashenden, *``The designer's guide to VHDL''*, 3rd edition

The following chapter of the book have been studied: 3.1-3.5. Particularly
the sections: 3.4, 5.3, 13.1, 16.1, 16.2. Things learnt:
*  Components
*  File-IO
*  For-loops
*  Using the previously written test bench: bit, bit_vector, boolean, integer.
*  How to separate the design under test from the test bench, file-IO, loops.

Pre-exercise tasks:
-------------------
Sketch a test bench which reads the values of the input signals
of the multiplexer from a file. Instantaneous values of `` A ``, `` B `` and `` S `` are given
on a single 17-bit line in an ASCII file. Test bench should write the resulting values of `` Q ``
to a given output file. Values are written to output file in
10ns periods as long as there is values in the input file.  

Exercise task:
--------------
Write and simulate the VHDL code for the pre-exercise task.
Write an entity and architecture for the multiplexer. Inside the architecture, write the
multiplexer process described in the previous exercise. 
Replace the process in the test bench by using an instance of the multiplexer entity. Simulate.

**Goal:** Knowledge of for-loops. Learning to use file-IO as a tool in the
test benches. Ability to use instances of entities in the test bench and generally
in the design to separate the hierarchies from each other. 



