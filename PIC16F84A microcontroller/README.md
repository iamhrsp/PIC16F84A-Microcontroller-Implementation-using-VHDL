# PIC16F84A Microcontroller project
Design and implementation of PIC16F84A microcontroller as shown by the pipeline architecture in **pipeline_architecture.jpg file**.

* Program counter and Stack has been added to the microcontroller which was designed so far. Finally, all the components were gathered in a top-level entity written inside the **PIC16F84A.vhd file**.

* A simple assembly language program has been written (**my_first_asml.asm**) whose HEX file is generated using Piklab (**my_first_asml.hex**).

* This HEX file is used as a source of Instructions for the microcontroller.

* The Instructions from the HEX file are decoded and read using functions defined in **read_intel_hex_pack** package in the **hexfile_reader.vhd** file.

* A graphical layout of the compunents and the data flow within these components is shown in **colour_coded_internal_connections.jpg** file.

* The final simulation result is shown in the **simulation_output.jpg** file

