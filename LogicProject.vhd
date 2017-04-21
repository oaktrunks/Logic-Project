library IEEE; use IEEE.STD_Logic_1164.all;
entity LogicProject is
port(instruction: in STD_LOGIC_VECTOR (15 downto 0);
EXE, UPD: in STD_LOGIC;
enADD, enXOR, enMOVREGTOREG, enMOVDATA, enINC, enDEC, enROL, enROR, enNEG, enOUT: out STD_LOGIC;
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
