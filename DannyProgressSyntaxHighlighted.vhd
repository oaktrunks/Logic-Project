--Decoder
library IEEE; use IEEE.STD_Logic_1164.all;
entity decoder is
port(instruction: in STD_LOGIC_VECTOR (15 downto 0);
--EXE 
UPD: in STD_LOGIC;
enADD, enXOR, enMOVREGTOREG, enMOVIMMDATA, enMOVAL, enMOVBL, enINC, enDEC, enROL, enROR, enNEG, enOUT, muxReg2, muxReg1: out STD_LOGIC;
immdata : out std_LOGIC_VECTOR (7 downto 0));
end;
architecture enabler of decoder is
begin
process(UPD) begin
if instruction(15 downto 8) ="10110000" then enMOVAL <= UPD; enMOVBL <= not UPD; immdata <= instruction(7 downto 0);
elsif instruction(15 downto 8) ="10110011" then enMOVAL <= not UPD; enMOVBL <= UPD; immdata <= instruction(7 downto 0);
else enMOVAL <= '0'; enMOVBL <= '0';
end if;
end process;
enADD <= not instruction(15) and not instruction(14) and not instruction(13) and not instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enXOR <= not instruction(15) and not instruction(14) and instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enMOVREGTOREG <= instruction(15) and not instruction(14) and not instruction(13) and not instruction(12) and instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6);
enMOVIMMDATA <= instruction(15) and not instruction(14) and instruction(13) and instruction(12) and not instruction(11);
enINC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
enDEC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and instruction(3);
enROL <= instruction(15) and instruction(14) and not instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
enROR <= instruction(15) and instruction(14) and not instruction(13) and instruction(12) and not instruction(11) and not instruction(10) and not instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and instruction(3);
enNEG <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and not instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and instruction(4) and instruction(3);
enOUT <= instruction(15) and instruction(14) and instruction(13) and not instruction(12) and not instruction(11) and instruction(10) and instruction(9) and not instruction(8) and instruction(7) and instruction(6) and not instruction(5) and not instruction(4) and not instruction(3);
muxReg2 <= not instruction(5) and instruction(4) and instruction(3); --1 for BL, 0 for AL
muxReg1 <= not instruction(2) and instruction(1) and instruction(0); --1 for BL, 0 for AL
end;

--giant multiplexer going into reg3
library IEEE; use IEEE.STD_Logic_1164.all;
entity giantMux is
	port 
	(	exe		: in std_logic; --execute clock
		enADD		: in std_logic;
		enXOR		: in std_logic;
	 	enMOVIMMDATA	: in std_logic; -- do we need this one?
	 	enMOVREGTOREG	: in std_logic;
		enINC		: in std_logic;
	 	enDEC		: in std_logic;
		enROL		: in std_logic; --maybe just one signal for enable ROT?
	 	enROR		: in std_logic;
		enNEG		: in std_logic;
	 	enOUT		: in std_logic; --do we need this one?
	 
		vecadd      	: in std_logic_vector (7 downto 0);
		vecxor      	: in std_logic_vector (7 downto 0);
		vecmovimmdata      : in std_logic_vector (7 downto 0);
		vecmovRegtoReg     : in std_logic_vector (7 downto 0);
		vecinc      	: in std_logic_vector (7 downto 0);
		vecdec      	: in std_logic_vector (7 downto 0);
		vecrot      	: in std_logic_vector (7 downto 0); --merged ROL and ROT into one entity
		--ror      	: in std_logic_vector (7 downto 0);
		vecneg      	: in std_logic_vector (7 downto 0);
		vecout      	: in std_logic_vector (7 downto 0);
	 
		c		: out std_logic_vector(7 downto 0));
end entity;
architecture giant of giantMux is
begin
	process(exe)
	begin
	if 	enADD = '1' then c <= vecadd;
	elsif enXOR = '1' then c <= vecxor;
	elsif enMOVIMMDATA = '1' then c <= vecmovimmdata;
	elsif enMOVREGTOREG = '1' then c <= vecmovRegtoReg;
	elsif enINC = '1' then c <= vecinc;
	elsif enDEC = '1' then c <= vecdec;
	elsif enROL = '1' then c <= vecrot;
	elsif enROR = '1' then c <= vecrot;
	elsif enNEG = '1'then c <= vecneg;
	elsif enOUT = '1' then c <= vecout;
	end if;
	end process;
end;

--Adder
library IEEE; use IEEE.STD_Logic_1164.all;
entity adder is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		b	: in std_logic_vector (7 downto 0);
		--cin	: in std_logic;
		sum	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
	);

end entity;

architecture sum of adder is
signal c1,c2,c3,c4,c5,c6,c7: std_logic;
begin

	sum(0) <= a(0) xor b(0); 
	c1 <= (a(0) and b(0)) or (a(0)) or (b(0));
	
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
	--cout <= (a(7) and b(7)) or (a(7) and c7) or (b(7) and c7);
	
end sum;

--8 Bit register
library IEEE; use IEEE.STD_Logic_1164.all;
entity reg8bit is

	port 
	(	
		UPD		: in std_logic;
		rin      : in std_logic_vector (7 downto 0);
		rout		: out std_logic_vector (7 downto 0)
		--routnot	: out std_logic_vector (7 downto 0)
	);

end entity;
architecture r8 of reg8bit is
	
	signal rt: std_logic_vector (7 downto 0);

begin

	process (UPD)
	begin
		
		if (UPD = '1') then

				rout <= rin;
				--routnot <= not rin;

		end if;
	end process;

	
end r8;

--rotators
library IEEE; use IEEE.STD_Logic_1164.all;
entity rotator is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		b	: out std_logic_vector (7 downto 0);
		enROR 	: in std_logic;
		enROL 	: in std_logic
	);

end entity;

architecture rot of rotator is
begin
	process(a)
	begin
	if enROR = '1' then --rotate right
		b(7) <= a(6);
		b(6) <= a(5);
		b(5) <= a(4);
		b(4) <= a(3);
		b(3) <= a(2);
		b(2) <= a(1);
		b(1) <= a(0);
		b(0) <= a(7);
	elsif enROL = '1' then --rotate left
		b(0) <= a(1);
		b(1) <= a(2);
		b(2) <= a(3);
		b(3) <= a(4);
		b(4) <= a(5);
		b(5) <= a(6);
		b(6) <= a(7);
		b(7) <= a(0);
	end if;
	end process;
	
end rot;


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
		--cin	: in std_logic;
		inc	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
	);

end entity;

architecture inc of increment is
signal c1, c2, c3, c4, c5, c6, c7 : std_logic; signal b	: std_logic_vector (7 downto 0);
begin
	b <= "00000001";
	inc(0) <= a(0) xor b(0);
	c1 <= (a(0) and b(0)) or (a(0)) or (b(0));
	
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
	--cout <= (a(7) and b(7)) or (a(7) and c7) or (b(7) and c7);
	
end inc;

--Output
library IEEE;
use IEEE.STD_Logic_1164.all;

entity display_hex is
port (Z : in STD_LOGIC_VECTOR (7 downto 0);
		--X : in STD_Logic_VECTOR (3 downto 0	);
	   --Y : in STD_Logic_VECTOR (3 downto 0	);
		a : out STD_Logic_VECTOR(6 downto 0);
		b : out STD_Logic_VECTOR (6 downto 0));
end entity;

architecture struct of display_hex is
signal X, Y : std_LOGIC_VECTOR (3 downto 0);
begin
	X <= Z(7 downto 4); Y <= Z(3 downto 0);
	process (Z) begin
	
			if X = "0000" then a <= "1000000";
			elsif X = "0001" then   a <= "1111001";
			elsif X = "0010" then   a <= "0100100";
			elsif X = "0011" then   a <= "0110000";
			elsif X = "0100" then   a <= "0011001";
			elsif X = "0101" then   a <= "0010010";
			elsif X = "0110" then   a <= "0000010";
			elsif X = "0111" then   a <= "1111000";
			elsif X = "1000" then   a <= "0000000";
			elsif X = "1001" then   a <= "0010000";
			elsif X = "1010" then   a <= "0001000";
			elsif X = "1011" then   a <= "0000011";
			elsif X = "1100" then   a <= "1000110";
			elsif X = "1101" then   a <= "0100001";
			elsif X = "1110" then   a <= "0000110";
			elsif X = "1111" then   a <= "0001110";
		   end if;
		
			if Y = "0000" then b <= "1000000";
			elsif Y = "0001" then   b <= "1111001";
			elsif Y = "0010" then   b <= "0100100";
			elsif Y = "0011" then   b <= "0110000";
			elsif Y = "0100" then   b <= "0011001";
			elsif Y = "0101" then   b <= "0010010";
			elsif Y = "0110" then   b <= "0000010";
			elsif Y = "0111" then   b <= "1111000";
			elsif Y = "1000" then   b <= "0000000";
			elsif Y = "1001" then   b <= "0010000";
			elsif Y = "1010" then   b <= "0001000";
			elsif Y = "1011" then   b <= "0000011";
			elsif Y = "1100" then   b <= "1000110";
			elsif Y = "1101" then   b <= "0100001";
			elsif Y = "1110" then   b <= "0000110";
			elsif Y = "1111" then   b <= "0001110";
		   end if;
	end process;
end;

--Negate
library IEEE; use IEEE.STD_Logic_1164.all;
entity negate is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		--cin	: in std_logic;
		neg	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
	);

end entity;

architecture neg of negate is
signal c1, c2, c3, c4, c5, c6, c7 : std_logic; signal temp, b	: std_logic_vector (7 downto 0);
begin
	temp <= not a;
	b <= "00000001";
	neg(0) <= temp(0) xor b(0);
	c1 <= (temp(0) and b(0)) or (temp(0)) or (b(0));
	
	neg(1) <= temp(1) xor b(1) xor c1;
	c2 <= (temp(1) and b(1)) or (temp(1) and c1) or (b(1) and c1);
	
	neg(2) <= temp(2) xor b(2) xor c2;
	c3 <= (temp(2) and b(2)) or (temp(2) and c2) or (b(2) and c2);
	
	neg(3) <= temp(3) xor b(3) xor c3;
	c4 <= (temp(3) and b(3)) or (temp(3) and c3) or (b(3) and c3);
	
	neg(4) <= temp(4) xor b(4) xor c4;
	c5 <= (temp(4) and b(4)) or (temp(4) and c4) or (b(4) and c4);
	
	neg(5) <= temp(5) xor b(5) xor c5;
	c6 <= (temp(5) and b(5)) or (temp(5) and c5) or (b(5) and c5);
	
	neg(6) <= temp(6) xor b(6) xor c6;
	c7 <= (temp(6) and b(6)) or (temp(6) and c6) or (b(6) and c6);
	
	neg(7) <= temp(7) xor b(7) xor c7;
	--cout <= (temp(7) and b(7)) or (temp(7) and c7) or (b(7) and c7);
end neg;

--decrement
library IEEE; use IEEE.STD_Logic_1164.all;
entity decrement is

	port 
	(
		a	: in std_logic_vector (7 downto 0);
		b	: out std_logic_vector (7 downto 0)
	);

end entity;

architecture dec of decrement is
begin
	process(a) begin
	b <= a;
	if    a(0) = '1' then b(0) <= '0';
	elsif a(1) = '1' then b(1) <= '0' ; b(0) <= '1';
	elsif a(2) = '1' then b(2) <= '0' ; b(1) <= '1' ; b(0) <= '1';
	elsif a(3) = '1' then b(3) <= '0' ; b(2) <= '1' ; b(1) <= '1' ; b(0) <= '1';
	elsif a(4) = '1' then b(4) <= '0'; b(3) <= '1' ; b(2) <= '1' ; b(1) <= '1' ; b(0) <= '1';
	elsif a(5) = '1' then b(5) <= '0'; b(4) <= '1'; b(3) <= '1' ; b(2) <= '1' ; b(1) <= '1' ; b(0) <= '1';
	elsif a(6) = '1' then b(6) <= '0'; b(5) <= '1'; b(4) <= '1'; b(3) <= '1' ; b(2) <= '1' ; b(1) <= '1' ; b(0) <= '1';
	elsif a(7) = '1' then b(7) <= '0'; b(6) <= '1'; b(5) <= '1'; b(4) <= '1'; b(3) <= '1' ; b(2) <= '1' ; b(1) <= '1' ; b(0) <= '1';
	end if;
	end process;
	
end dec;

--multiplexer 2 , has registers as input and IMMDATA as input
library IEEE; use IEEE.STD_Logic_1164.all;
entity multiplexer2 is
	port 
	(	
		al      	: in std_logic_vector (7 downto 0);
		bl      	: in std_logic_vector (7 downto 0);
		immd	: in std_logic_vector(7 downto 0);
		d	: out std_logic_vector(7 downto 0);
		enBL	: in std_logic; --1 for bl, 0 for al. comes from muxReg1 and muxReg2 from decoder
		enMOVIMMDATA: in std_logic
	);
end entity;
architecture mux2 of multiplexer2 is
begin
	process(al, bl, immd) begin --is this based on the right stuff?
	if enBL = '1' then d <= bl; --output BL
	elsif enBL = '0' then  d <= al; --output AL
	elsif enMOVIMMDATA = '1' then d<= immd; --output immdata
	end if;
	end process;
end mux2;
	
--multiplexer 1
library IEEE; use IEEE.STD_Logic_1164.all;
entity multiplexer1 is
	port 
	(	
		a      	: in std_logic_vector (7 downto 0);
		b      	: in std_logic_vector (7 downto 0);
		c	: out std_logic_vector(7 downto 0);
		enBL	: in std_logic --1 for bl, 0 for al. comes from muxReg1 and muxReg2 from decoder
	);
end entity;
architecture mux1 of multiplexer1 is
begin
	process(a) begin
	if enBL = '1' then c <= b; --output BL
	else c <= a; --output AL
	end if;
	end process;
end mux1;

library IEEE; use IEEE.STD_Logic_1164.all;
entity LogicProject is
port(
	inpt: in STD_LOGIC_VECTOR (15 downto 0);
	upd: in std_LOGIC;
	exe: in std_LOGIC;
	--output: out STD_LOGIC_VECTOR (15 downto 0) commented this out in favor of outputA and outputB to control lights
	outputA: out STD_logic_vector(6 downto 0); --left light
	outputB: out STD_logic_vector(6 downto 0) --left light
);
end;
architecture Project of LogicProject is

	component decoder is
		port(instruction: in STD_LOGIC_VECTOR (15 downto 0);
		--EXE, 
		UPD: in STD_LOGIC;
		enADD, enXOR, enMOVREGTOREG, enMOVIMMDATA, enMOVAL, enMOVBL, enINC, enDEC, enROL, enROR, enNEG, enOUT, muxReg2, muxReg1: out STD_LOGIC;
		immdata : out std_LOGIC_VECTOR (7 downto 0));
	end component;
	component adder
		port 
		(
		a	: in std_logic_vector (7 downto 0);
		b	: in std_logic_vector (7 downto 0);
		--cin	: in std_logic;
		sum	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
		);

		end component;
	component reg8bit
		port 
		(	
		UPD		: in std_logic;
		rin      : in std_logic_vector (7 downto 0);
		rout		: out std_logic_vector (7 downto 0)
		--routnot	: out std_logic_vector (7 downto 0)
		);

		end component;
	component rotator
		port 
		(
		a	: in std_logic_vector (7 downto 0);
		b	: out std_logic_vector (7 downto 0);
		enROR 	: in std_logic;
		enROL 	: in std_logic
		);

		end component;
	component xorcomp
		port 
		(	EXE		: in std_LOGIC;
		UPD		: in std_logic;
		a      : in std_logic_vector (7 downto 0);
		b      : in std_logic_vector (7 downto 0);
		c		 : out std_logic_vector(7 downto 0));
		end component;
	component increment
		port 
		(
		a	: in std_logic_vector (7 downto 0);
		--cin	: in std_logic;
		inc	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
		);

		end component;
	component display_hex
		port (Z : in STD_LOGIC_VECTOR (7 downto 0);
		--X : in STD_Logic_VECTOR (3 downto 0	);
	   --Y : in STD_Logic_VECTOR (3 downto 0	);
		a : out STD_Logic_VECTOR(6 downto 0);
		b : out STD_Logic_VECTOR (6 downto 0));
		end component;
	component negate
		port 
		(
		a	: in std_logic_vector (7 downto 0);
		--cin	: in std_logic;
		neg	: out std_logic_vector (7 downto 0)
		--cout	: out std_logic
		
		);

		end component;
	component decrement
		port 
		(
		a	: in std_logic_vector (7 downto 0);
		b	: out std_logic_vector (7 downto 0)
		);

		end component;
	component multiplexer1
		port 
		(	
		a      	: in std_logic_vector (7 downto 0);
		b      	: in std_logic_vector (7 downto 0);
		c			: out std_logic_vector(7 downto 0);
		enBL		: in std_logic --1 for bl, 0 for al. comes from muxReg1 and muxReg2 from decoder
		);
		end component;
	component multiplexer2
		port 
			(	
		al      	: in std_logic_vector (7 downto 0);
		bl      	: in std_logic_vector (7 downto 0);
		immd		: in std_logic_vector(7 downto 0);
		d			: out std_logic_vector(7 downto 0);
		enBL		: in std_logic; --1 for bl, 0 for al. comes from muxReg1 and muxReg2 from decoder
		enMOVIMMDATA: in std_logic
		);
		end component;
		
		component giantMux
		port
		(
		exe		: in std_logic; --execute clock
		enADD		: in std_logic;
		enXOR		: in std_logic;
	 	enMOVIMMDATA	: in std_logic; -- do we need this one?
	 	enMOVREGTOREG	: in std_logic;
		enINC		: in std_logic;
	 	enDEC		: in std_logic;
		enROL		: in std_logic; --maybe just one signal for enable ROT?
	 	enROR		: in std_logic;
		enNEG		: in std_logic;
	 	enOUT		: in std_logic; --do we need this one?
	 
		vecadd      	: in std_logic_vector (7 downto 0);
		vecxor      	: in std_logic_vector (7 downto 0);
		vecmovimmdata      : in std_logic_vector (7 downto 0);
		vecmovRegtoReg     : in std_logic_vector (7 downto 0);
		vecinc      	: in std_logic_vector (7 downto 0);
		vecdec      	: in std_logic_vector (7 downto 0);
		vecrot      	: in std_logic_vector (7 downto 0); --merged ROL and ROT into one entity
		--ror      	: in std_logic_vector (7 downto 0);
		vecneg      	: in std_logic_vector (7 downto 0);
		vecout      	: in std_logic_vector (7 downto 0);
	 
		c		: out std_logic_vector(7 downto 0)
		
		);
		end component;
		--all of our signals
		
		--enable signals & immdata
		signal enADD, enXOR, enMOVREGTOREG, enMOVIMMDATA, enMOVAL, enMOVBL, enINC, enDEC, enROL, enROR, enNEG, enOUT, muxReg2, muxReg1: STD_LOGIC;
		signal immdata : std_LOGIC_VECTOR (7 downto 0);
		
		--mux & regs
		signal regin, mux1out, mux2out, alout, blout, reg3out : std_logic_vector (7 downto 0);
		--signal notalout, notblout: std_logic_vector (7 downto 0); -- do we need these(?)
		
		--giant mux input and component outputs
		signal vecadd, vecxor, vecmovRegtoReg, vecinc, vecdec, vecrot, vecneg, vecout, c : std_LOGIC_VECTOR (7 downto 0);
		
		--adder
		--signal carryin, carryout : std_logic;
		
		--giant mux
		signal giantmuxout: std_logic_vector(7 downto 0);
		--signal notgiantmuxout: std_logic_vector(7 downto 0); --do we need this(?)
		
begin
	--all of our port maps
	instructionDecoder: decoder port map(inpt, upd, enADD, enXOR, enMOVREGTOREG, enMOVIMMDATA, enMOVAL, enMOVBL, enINC, enDEC, enROL, enROR, enNEG, enOUT, muxReg2, muxReg1, immdata);
	AL: reg8bit port map(enMOVAL, reg3out, alout); --enMOVAL or upd (?)
	BL: reg8bit port map(enMOVBL, reg3out, blout); --enMOVBL or upd (?)
	reg3: reg8bit port map(exe, giantmuxout, reg3out); --whats the upd for this one(?) ***this should update on the execute clock*** -Tyler
	--mux1 is for reg1 and reg, mux2 is for reg2 in input parameters
	mux1: multiplexer1 port map(alout, blout, mux1out, muxReg1);
	mux2: multiplexer1 port map(alout, blout, mux2out, muxReg2); --idk if immdata into mux2 is a good idea (?)**probably not, immdata straight into giantmux -danny
	--changed vecmovimmdata to immdata
	bigmux: giantMux port map(exe, enAdd, enXOR, enMOVIMMDATA, enMOVREGTOREG, enINC, enDEC, enROL, enROR, enNEG, enOUT, vecadd, vecxor, immdata, vecmovRegtoReg, vecinc, vecdec, vecrot, vecneg, vecout, giantmuxout);
	regAdder: adder port map(mux1out, mux2out, vecadd);
	regXor: xorcomp port map(exe, upd, mux1out, mux2out, vecxor);
	regInc: increment port map(mux1out, vecinc);
	regDec: decrement port map(mux1out, vecdec);
	regRot: rotator port map(mux1out, vecrot, enROR, enROL);
	regNeg: negate port map(mux1out, vecneg);
	
	--(?) How to connect display_hex
	regOut: display_hex port map(mux1out, outputA, outputB);
	
	--(?) issues 	: probably make it so OUT doesnt go into reg3? or is it okay
	--					: some of our components have exe and upd, some dont
	--					: should we remove cout and cin from adder and incrementer and negator? *** We did -Danny &Tyler
end;
