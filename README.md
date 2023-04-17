# MIPS-Single-Cycle
This MIPS Single-Cycle project is designed to implement a simple MIPS processor using a single-cycle architecture. The processor will be able to execute basic arithmetic and logic instructions. This project is implemented in VHDL and can be synthesized using any FPGA board or simulator.

## Requirements
Vivado: 2016. 4 (for generating a bitstream) and Basys 3 Digilent board (optional)

## Usage
### Requirements
The project requires the following modules to be implemented in VHDL:
- Register File: This module stores the values of the registers used by the processor.
- ALU (Arithmetic and Logic Unit): This module performs the arithmetic and logic operations required by the processor.
- Control Unit: This module generates control signals for the different components of the processor.
- Data Memory: This module stores the data that is accessed by the processor.

### Implementation
The MIPS processor single-cycle architecture consists of a single cycle that executes all instructions. The architecture has the following components:
- Instruction Memory: This module stores the instructions to be executed by the processor.
- Register File: This module stores the values of the registers used by the processor.
- ALU (Arithmetic and Logic Unit): This module performs the arithmetic and logic operations required by the processor.
- Control Unit: This module generates control signals for the different components of the processor.
- Data Memory: This module stores the data that is accessed by the processor.

Schema
<div allign="center">
    <img src="https://user-images.githubusercontent.com/93877610/232557767-4497b6b1-b544-4baa-ae68-74951e76704c.jpg" width="800" height="500">
  
### Testing
The project can be tested using testbenches designed to provide inputs to the processor and check the outputs. The testbenches can be used to test different types of instructions and edge cases to ensure the correct behavior of the processor.

I chose to test it on Basys 3 Digilent board and fot that I implemented a program in which I will try to go through the elements of an array from memory. It will compute the double of the first 10 numbers and store it back in memory at the same address. I will also calculate the sum of the double numbers and store it after the first 9 numbers, in memory.

<div allign="center">
    <img src="https://user-images.githubusercontent.com/93877610/232553840-944ff960-15f0-46dc-8254-7d2378f0d18c.jpg" width="200" height="300">

To be noted that the program that was uploaded on my microprocessor is written in binary code, after being translated from ASSEMBLY. 
</div>
