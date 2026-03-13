----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 06:39:30 PM
-- Design Name: 
-- Module Name: EX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
  Port (RD1: in std_logic_vector(31 downto 0);
        ALUSrc: in std_logic;
        RD2: in std_logic_vector(31 downto 0);
        ExtImm: in std_logic_vector(31 downto 0);
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        ALUOp: in std_logic_vector(1 downto 0);
        PC: in std_logic_vector(31 downto 0);
        RT: in std_logic_vector(4 downto 0);
        RD: in std_logic_vector(4 downto 0);
        RegDst: in std_logic;
        ALURes: out std_logic_vector(31 downto 0);
        BranchAddress: out std_logic_vector(31 downto 0);
        Zero: out std_logic;
        GTZ: out std_logic;
        NE: out std_logic;
        RWA: out std_logic_vector(4 downto 0)
           );
end EX;

architecture Behavioral of EX is

signal ALUCtrl: std_logic_vector(2 downto 0);
signal B: std_logic_vector(31 downto 0);
signal A: std_logic_vector(31 downto 0);
signal C: std_logic_vector(31 downto 0);
signal Z: std_logic;

begin

A <= RD1;

--mux pt B

process(ALUSrc, RD2, ExtImm)
begin
    if ALUSrc = '0' then 
        B <= RD2;
    else 
        B <= ExtImm;
    end if;
end process;

-- ALU 

process(ALUOp, func)
begin

case ALUOp is
    when "00" =>
        case func is
            when "000001" => ALUCtrl <= "000";
            when "000010" => ALUCtrl <= "001";
            when "000011" => ALUCtrl <= "010";
            when "000100" => ALUCtrl <= "011";
            when "000101" => ALUCtrl <= "100";
            when "000110" => ALUCtrl <= "101";
            when "000111" => ALUCtrl <= "110";
            when "001000" => ALUCtrl <= "011";
            when others => ALUCtrl <= "000";
        end case;
     when "01" => ALUCtrl <= "000";
     when "10" => ALUCtrl <= "001";
     when others => ALUCtrl <= (others => 'X');
end case;
end process;

--Operatii

process(ALUCtrl, A, B)
begin
case ALUCtrl is
    when "000" => C <= A + B;
    when "001" => C <= A - B;
    when "010" => C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
    when "011" => C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
    when "100" => C <= A and B;
    when "101" => C <= A or B;
    when "110" => C <= A xor B;
    when "111" => C <= to_stdlogicvector(to_bitvector(B) sra conv_integer(sa));
    when others => C <= (others => 'X');
end case;
end process;

ALURes <= C;

--Branch

Z <= '1' when C = X"00000000" else '0';
Zero <= Z; 
NE <= '0' when C = X"00000000" else '1';
GTZ <= (not C(31)) and (not Z);

--Branch Address

BranchAddress <= PC + (ExtImm(29 downto 0) & "00");

-- MUX pt RWA

process(RT, RD, RegDst)
begin

    if RegDst = '0' then
        RWA <= RT;
    else 
        RWA <= RD;
    end if;

end process;


end Behavioral;
