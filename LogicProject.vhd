library IEEE; use IEEE.STD_Logic_1164.all;
entity LogicProject is
generic
(
NUM_STAGES : natural := 256
);
port(instruction: in STD_LOGIC_VECTOR (15 downto 0); clk : in std_logic; enable : in std_logic; sr_in : in std_logic; sr_out : out std_logic);
EXE, UPD: in STD_LOGIC;
enADD, enXOR, enMOVREGTOREG, enMOVDATA, enINC, enDEC, enROL, enROR, enNEG, enOUT: out STD_LOGIC);
end;
architecture decoder of LogicProject is
begin
enADD <= not instruction(15) and not instruction(14) and not instruction(13) and not instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enXOR <= not instruction(15) and not instruction(14) and instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enMOVREGTOREG <= instruction(15) and not instruction(14) and not instruction(13) and not instruction(12) and instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enMOVDATA <= instruction(15) and not instruction(14) and instruction(13) and instruction(12) and not instruction(11);
enINC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
enDEC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and instruction(3);
enROL <= instruction(15) and instruction(14) and not instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
enROR <= instruction(15) and instruction(14) and not instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and instruction(3);
enNEG <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and not instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and instruction(4) and instruction(3);
enOUT <= instruction(15) and instruction(14) and instruction(13) and not instruction(12) and not instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
end;
--beginning of register 1
architecture rtl of basic_shift_register is

	-- Build an array type for the shift register
	type sr_length is array ((NUM_STAGES-1) downto 0) of std_logic;

	-- Declare the shift register signal
	signal sr: sr_length;

begin

	process (clk)
	begin
		if (rising_edge(clk)) then

			if (enable = '1') then

				-- Shift data by one stage; data from last stage is lost
				sr((NUM_STAGES-1) downto 1) <= sr((NUM_STAGES-2) downto 0);

				-- Load new data into the first stage
				sr(0) <= sr_in;

			end if;
		end if;
	end process;

	-- Capture the data from the last stage, before it is lost
	sr_out <= sr(NUM_STAGES-1);

end rtl;

