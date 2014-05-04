#Lab4a
====

##PicoBlaze
This lab creates a PicoBlaze with VHDL. The PicoBlaze was programmed in Assembly from which a VHDL ROM was generated in order to use with Xilinx. The PicoBlaze uses UART to display which switch is flipped.

#Implementation

This lab was made possible through a successful conversion from two nibbles to and from ASCII character vaules. This allowed them to be properly read and displayed. Additionally, getting the correct rate for clock to baud was critical.

# `pico rom`
This is the generated ROM of the Assembly instructions that compose the PicoBlaze.

# `vga_sync`
This connects v_sync and h_sync. It instantiates both of them.

# `v_sync_gen`
This generates the vertical signals. It cycles throught the 5 states that are in the state diagram. It uses three flip flops for next state logic, count logic and reset logic.

# `h_sync_gen`
This generates the horizontal signals. It cycles throught the 5 states that are in the state diagram. It uses three flip flops for next state logic, count logic and reset logic.

# `character_gen`
This assigns RGB to different values to display different colors. The higher the value, the higher the intensity.
This determines which pixels are colored in based off of the letter with font_rom.

# `font_rom`
This contains the information of which columns and rows are used by which characters.
Basically, all of the specific information of how to generate each character.

# `input_to_pulse`
This debounces the buttons. The button cycles through three different states: idle, press, and release.

# Testing and Debugging
- BE CAREFUL WITH SIGNALS!!! ALWAYS PAY ATTENTION AND MATCH UP THE CORRECT SIGNALS!!


# Conclusion
- This lab was useful in learning something completely different than anything I had done before and how to figure out how to wire things up more so than any other lab before this.
- This lab also taught that sometimes delays are necessary to sync different signals up

