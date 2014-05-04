#Lab4a
====

##PicoBlaze
This lab creates a PicoBlaze with VHDL. The PicoBlaze was programmed in Assembly from which a VHDL ROM was generated in order to use with Xilinx. The PicoBlaze uses UART to display which switch is flipped.

#Implementation

This lab was made possible through a successful conversion from two nibbles to and from ASCII character vaules. This allowed them to be properly read and displayed. Additionally, getting the correct rate for clock to baud was critical.

# `pico rom`
This is the generated ROM of the Assembly instructions that compose the PicoBlaze.

# `clk_to_baud`
This allows the FPGA to interact with UART.

# `ascii_to_nibble`
Converts an ASCII character to a nibble. The nibble stores the character that the ASCII code represents.

# `uart_rx6` `uart_tx6`
The UART code to be able to use UART.

# `atlys_remote_terminal_pb`
This is the top level of the project. This instantiates everything else and wires everything up using all of the signals. This also  interacts with the ports on the FPGA.

# Testing and Debugging
- Most of the bugs came from getting used to UART and everything else, such as double chars.
- Sensitivity lists were a bit of a problem


# Conclusion
- This lab was actually pretty intereseting despite not actually accomplishing anything useful. It was really cool to be able to create a little processor through code and to build it on the FPGA. I say a lot more potential that the FPGA can be used with.

