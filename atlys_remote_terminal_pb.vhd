----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:12:20 03/13/2014 
-- Design Name: 
-- Module Name:    atlys_remote_terminal_pb - Behavioral 
-- Project Name: 
-- Target Devices: +
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_remote_terminal_pb is
	port(
				clk : in std_logic;
				reset : in std_logic;
				serial_in : in std_logic;
				serial_out : out std_logic;
				switch : in std_logic_vector(7 downto 0);
				led : out std_logic_vector(7 downto 0)
				);
end atlys_remote_terminal_pb;

architecture Behavioral of atlys_remote_terminal_pb is
 
 component kcpsm6
    generic( hwbuild : std_logic_vector(7 downto 0) := X"00";
             interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port ( address : out std_logic_vector(11 downto 0);
              instruction : in std_logic_vector(17 downto 0);
              bram_enable : out std_logic;
              in_port : in std_logic_vector(7 downto 0);
              out_port : out std_logic_vector(7 downto 0);
              port_id : out std_logic_vector(7 downto 0);
              write_strobe : out std_logic;
              k_write_strobe : out std_logic;
              read_strobe : out std_logic;
              interrupt : in std_logic;
              interrupt_ack : out std_logic;
              sleep : in std_logic;
              reset : in std_logic;
              clk : in std_logic);
  end component;
	component pico_rom
	generic( C_FAMILY : string := "S6";
	C_RAM_SIZE_KWORDS : integer := 1;
	C_JTAG_LOADER_ENABLE : integer := 0);
	Port ( address : in std_logic_vector(11 downto 0);
	instruction : out std_logic_vector(17 downto 0);
	enable : in std_logic;
	rdl : out std_logic;
	clk : in std_logic);
	end component;
	
	COMPONENT clk_to_baud
		PORT( clk : IN STD_LOGIC;
			reset : IN STD_LOGIC;
			baud_16x_en : OUT STD_LOGIC
			);
	END COMPONENT;
		
	COMPONENT uart_rx6
	PORT(
		serial_in : IN std_logic;
		en_16_x_baud : IN std_logic;
		buffer_read : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_Logic;
		data_out : OUT std_logic_vector(7 downto 0);
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic);
	END COMPONENT;
	
	COMPONENT uart_tx6
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		en_16_x_baud : IN std_logic;
		buffer_write : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_Logic;
		serial_out : OUT std_logic;
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic);
	END COMPONENT;
	

	signal pico_out, pico_in : std_logic_vector(7 downto 0);
	signal en_16_sig, buff_write, buff_read, half_full_sig, full_sig, buffer_reset_sig, buf_data: std_logic;
	signal address : std_logic_vector(11 downto 0);
	signal instruction : std_logic_vector(17 downto 0);
	signal bram_enable : std_logic;
	signal in_port : std_logic_vector(7 downto 0);
	signal out_port : std_logic_vector(7 downto 0);
	Signal port_id : std_logic_vector(7 downto 0);
	Signal write_strobe : std_logic;
	Signal k_write_strobe : std_logic;
	Signal read_strobe : std_logic;
	Signal interrupt : std_logic;
	Signal interrupt_ack : std_logic;
	Signal kcpsm6_sleep : std_logic;
	Signal kcpsm6_reset : std_logic;
	Signal switch1, switch2, switch_nibble1, switch_nibble2 : std_logic_vector(7 downto 0);
	Signal led_number, led_letter : unsigned(7 downto 0);
	Signal led_output : std_logic_vector(7 downto 0);
	Signal led1, led2 : std_logic_vector(3 downto 0);
	
begin

	processor: kcpsm6
    generic map ( hwbuild => X"00",
                  interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map( address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
	program_rom: pico_rom
		generic map( C_FAMILY => "S6",
			C_RAM_SIZE_KWORDS => 1,
			C_JTAG_LOADER_ENABLE => 1)
		port map( address => address,
			instruction => instruction,
			enable => bram_enable,
			rdl => kcpsm6_reset,
			clk => clk);

	Inst_clk_to_baud: clk_to_baud PORT MAP(
		clk => clk,
		reset => reset,
		baud_16x_en => en_16_sig
		);
		
	Inst_uart_rx6: uart_rx6 PORT MAP(
		serial_in => serial_in,
		en_16_x_baud => en_16_sig,
		data_out => pico_in,
		buffer_read => buff_read,
		buffer_data_present => buf_data,
		buffer_half_full => open,
		buffer_full => open,
		buffer_reset => reset,
		clk => clk );
		
	Inst_uart_tx6: uart_tx6 PORT MAP(
		data_in => out_port,
		en_16_x_baud => en_16_sig,
		serial_out => serial_out,
		buffer_write => buff_write,
		buffer_data_present => open,
		buffer_half_full => open,
		buffer_full => open,
		buffer_reset => reset,
		clk => clk );
		
	buff_read <=  '1' when ( port_id = x"AF" and read_strobe = '1') else
						'1' when (port_id = x"AE" and read_strobe = '1') else
						'1' when (port_id = x"AD" and read_strobe = '1') else
						'1' when (port_id = x"01" and read_strobe ='1') else
						'0';
	
	buff_write <= '1' when (port_id = x"02" and write_strobe = '1') else
						'1' when (port_id = x"03" and write_strobe = '1') else
						'1' when (port_id = x"04" and write_strobe = '1') else
						'0';

	kcpsm6_sleep <= '0';
	interrupt <= interrupt_ack;
	
	
	switch_nibble1 <= "0000" & switch(7 downto 4);
	switch_nibble2 <= "0000" & switch(3 downto 0);
	switch1 <= std_logic_vector(unsigned(switch_nibble1) + X"30") when switch_nibble1 <= "00001001" else
		std_logic_vector(unsigned(switch_nibble1) + X"57");
	switch2 <= std_logic_vector(unsigned(switch_nibble2) + X"30") when switch_nibble2 <= "00001001" else
		std_logic_vector(unsigned(switch_nibble2) + X"57");	
		
		
		led_number <= unsigned(out_port) - X"30";
		led_letter <= unsigned(out_port) - X"57";

		led_output <= std_logic_vector(led_number) when led_number >= X"0"
			and led_number <= X"9" else
			std_logic_vector(led_number) when led_letter >= X"A"
			and led_letter <= X"F" else
			"11111111";

	process(clk, port_id)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				led1 <= "0000";
			else
				if(port_id = x"03") then
					led1 <= led_output(3 downto 0);
				end if;
			end if;
		end if;
	end process;

	process(clk, port_id)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				led2 <= "0000";
			else
				if(port_id = x"04") then
					led2 <= led_output(3 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	led <= led1 & led2;

	process(clk)
	begin
		if(rising_edge(clk)) then
			case port_id is
				when x"AF" => in_port <= pico_in;
				when x"AE" => in_port <= switch1;
				when x"AD" => in_port <= switch2;
				when x"01" => in_port <= "0000000" & buf_data;
				when others => in_port <= "00000000";
			end case;
		end if;
	end process;

end Behavioral;

