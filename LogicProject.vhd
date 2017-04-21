library IEEE; use IEEE.STD_Logic_1164.all;
entity LogicProject is
port(instruction: in STD_LOGIC_VECTOR (15 downto 0);
EXE, UPD: in STD_LOGIC;
enADD, enXOR, enMOVREGTOREG, enMOVDATA, enINC, enDEC, enROL, enROR, enNEG, enOUT: out STD_LOGIC;
end;
architecture decoder of LogicProject is
begin
enADD <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enXOR <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enMOVREGTOREG <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enMOVDATA <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enINC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enDEC <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enROL <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enROR <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enNEG <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
enOUT <= instruction(15) and instruction(14) and instruction(13) and instruction(12) and instruction(11) and instruction(10) and instruction(9) and instruction(8) and instruction(7) and instruction(6) and instruction(5) and instruction(4) and instruction(3) and instruction(2) and instruction(1) and instruction(0)
end;
