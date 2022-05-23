# IAR flavoured Freedom Metal Machine Compatibility Library

This library is based on the 
[SiFive Freedom Metal library](https://github.com/sifive/freedom-metal), but 
has been modified to be work with the IAR toolchain.

__The IAR flavoured Freedom Metal library 
is provided as-is, and there is no guarantee of its status and that it will be 
maintained.__

Documentation for the original Freedom Metal library
[can be found here](https://sifive.github.io/freedom-metal-docs/).

## Setup
In order to get the required design files for this project, it is necessary to 
first setup and build the device specific header files using the IAR friendly 
version of the 
[Freedom Device Tree Tools library](https://github.com/IARSystems/iar-freedom-devicetree-tools). 
Follow the instructions in this library to generate the header files and get
them moved to their correct place in the IAR Freedom Metal library.

## Run project from EWRISCV
To use the IAR Freedom Metal library in your project you need to do the 
following steps (after the device header files have been generated):

1. Add the _freedom-metal_ folder as an additional include path (Project ->
Options -> Static Analysis -> C/C++ Compiler -> Preprocessor)

2. Define the following symbols (Project -> Options -> Static Analysis -> 
C/C++ Compiler -> Preprocessor):

    \_\_asm__=asm

    \_\_inline__=inline
    
    \_\_volatile__=volatile

3. Override the linker entry symbol to __metal_enter (Project -> Options -> 
Static Analysis -> Linker -> Library)

4. Add all the files in the _freedom-metal/src_ folder (including drivers) to 
the project

(Note that step 3 above is not necessary if you are only building an sdk 
library)

