library IEEE; use IEEE.STD_Logic_1164.all;
entity LogicProject is
port();
end;
architecture Project of LogicProject is
begin

end;

--Decoder
entity decoder is
port(instruction: in STD_LOGIC_VECTOR (15 downto 0); clk : in std_logic; enable : in std_logic; sr_in : in std_logic; sr_out : out std_logic;
EXE, UPD: in STD_LOGIC;
enADD, enXOR, enMOVREGTOREG, enMOVDATA, enINC, enDEC, enROL, enROR, enNEG, enOUT, muxReg2, muxReg1: out STD_LOGIC);
end;
architecture enabler of decoder is
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
muxReg2 <= not instruction(5) and instruction(4) and instruction(3); --1 for BL, 0 for AL
muxReg1 <= not instruction(2) and instruction(1) and instruction(0); --1 for BL, 0 for AL
end;

--Adder
library IEEE; use IEEE.STD_Logic_1164.all;
entity adder is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		b	: in std_logic_vector (7 downto 0);
		cin	: in std_logic;
		sum	: out std_logic_vector (7 downto 0);
		cout	: out std_logic
		
	);

end entity;

architecture sum of adder is
signal c1,c2,c3,c4,c5,c6,c7: std_logic;
begin

	sum(0) <= a(0) xor b(0) xor cin;
	c1 <= (a(0) and b(0)) or (a(0) and cin) or (b(0) and cin);
	
	sum(1) <= a(1) xor b(1) xor c1;
	c2 <= (a(1) and b(1)) or (a(1) and c1) or (b(1) and c1);
	
	sum(2) <= a(2) xor b(2) xor c2;
	c3 <= (a(2) and b(2)) or (a(2) and c2) or (b(2) and c2);
	
	sum(3) <= a(3) xor b(3) xor c3;
	c4 <= (a(3) and b(3)) or (a(3) and c3) or (b(3) and c3);
	
	sum(4) <= a(4) xor b(4) xor c4;
	c5 <= (a(4) and b(4)) or (a(4) and c4) or (b(4) and c4);
	
	sum(5) <= a(5) xor b(5) xor c5;
	c6 <= (a(5) and b(5)) or (a(5) and c5) or (b(5) and c5);
	
	sum(6) <= a(6) xor b(6) xor c6;
	c7 <= (a(6) and b(6)) or (a(6) and c6) or (b(6) and c6);
	
	sum(7) <= a(7) xor b(7) xor c7;
	cout <= (a(7) and b(7)) or (a(7) and c7) or (b(7) and c7);
	
end sum;

--8 Bit register
library IEEE; use IEEE.STD_Logic_1164.all;
entity reg8bit is

	port 
	(	
		UPD		: in std_logic;
		rin      : in std_logic_vector (7 downto 0);
		rout		: out std_logic_vector (7 downto 0);
		routnot	: out std_logic_vector (7 downto 0)
	);

end entity;
architecture r8 of reg8bit is
	
	signal rt: std_logic_vector (7 downto 0);

begin

	process (UPD)
	begin
		
		if (UPD = '1') then

				rout <= rin;
				routnot <= not rin;

		end if;
	end process;

	
end r8;

--rotators
library IEEE; use IEEE.STD_Logic_1164.all;
entity rotator is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		b	: out std_logic_vector (7 downto 0)
	);

end entity;

architecture leftRotator of rotator is
begin
	
	b(7) <= a(6);
	b(6) <= a(5);
	b(5) <= a(4);
	b(4) <= a(3);
	b(3) <= a(2);
	b(2) <= a(1);
	b(1) <= a(0);
	b(0) <= a(7);
	
end leftRotator;

architecture rightRotator of rotator is
begin

	b(0) <= a(1);
	b(1) <= a(2);
	b(2) <= a(3);
	b(3) <= a(4);
	b(4) <= a(5);
	b(5) <= a(6);
	b(6) <= a(7);
	b(7) <= a(0);
	
end rightRotator;


--XOR Component
library IEEE; use IEEE.STD_Logic_1164.all;
entity xorcomp is
	port 
	(	EXE		: in std_LOGIC;
		UPD		: in std_logic;
		a      : in std_logic_vector (7 downto 0);
		b      : in std_logic_vector (7 downto 0);
		c		 : out std_logic_vector(7 downto 0));
end entity;
architecture xcomp of xorcomp is
begin
	c(0) <= a(0) xor b(0);
	c(1) <= a(1) xor b(1);
	c(2) <= a(2) xor b(2);
	c(3) <= a(3) xor b(3);
	c(4) <= a(4) xor b(4);
	c(5) <= a(5) xor b(5);
	c(6) <= a(6) xor b(6);
	c(7) <= a(7) xor b(7);
end;

--Increment
library IEEE; use IEEE.STD_Logic_1164.all;
entity increment is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		cin	: in std_logic;
		inc	: out std_logic_vector (7 downto 0);
		cout	: out std_logic
		
	);

end entity;

architecture inc of increment is
signal c1, c2, c3, c4, c5, c6, c7 : std_logic; signal b	: std_logic_vector (7 downto 0);
begin
	b <= "0000001";
	inc(0) <= a(0) xor b(0) xor cin;
	c1 <= (a(0) and b(0)) or (a(0) and cin) or (b(0) and cin);
	
	inc(1) <= a(1) xor b(1) xor c1;
	c2 <= (a(1) and b(1)) or (a(1) and c1) or (b(1) and c1);
	
	inc(2) <= a(2) xor b(2) xor c2;
	c3 <= (a(2) and b(2)) or (a(2) and c2) or (b(2) and c2);
	
	inc(3) <= a(3) xor b(3) xor c3;
	c4 <= (a(3) and b(3)) or (a(3) and c3) or (b(3) and c3);
	
	inc(4) <= a(4) xor b(4) xor c4;
	c5 <= (a(4) and b(4)) or (a(4) and c4) or (b(4) and c4);
	
	inc(5) <= a(5) xor b(5) xor c5;
	c6 <= (a(5) and b(5)) or (a(5) and c5) or (b(5) and c5);
	
	inc(6) <= a(6) xor b(6) xor c6;
	c7 <= (a(6) and b(6)) or (a(6) and c6) or (b(6) and c6);
	
	inc(7) <= a(7) xor b(7) xor c7;
	cout <= (a(7) and b(7)) or (a(7) and c7) or (b(7) and c7);
	
end inc;

--Negate
library IEEE; use IEEE.STD_Logic_1164.all;
entity negate is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		cin	: in std_logic;
		neg	: out std_logic_vector (7 downto 0);
		cout	: out std_logic
		
	);

end entity;

architecture neg of negate is
signal c1, c2, c3, c4, c5, c6, c7 : std_logic; signal temp	: std_logic_vector (7 downto 0);
begin
	temp <= not a;
end neg;







			
