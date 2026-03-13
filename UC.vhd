----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 07:15:14 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
  Port (Instr: in std_logic_vector(5 downto 0);
        RegDst: out std_logic;
        ExtOp: out std_logic;
        ALUSrc: out std_logic;
        Branch: out std_logic;
        jump: out std_logic;
        ALUOp: out std_logic_vector(1 downto 0);
        MemWrite: out std_logic;
        MemToReg: out std_logic;
        RegWrite: out std_logic;
        Br_gtz: out std_logic;
        Br_ne: out std_logic
  );
end UC;

architecture Behavioral of UC is

begin

    process(Instr)
    begin
    RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0'; Branch <= '0';
    jump <= '0'; MemWrite <= '0'; MemToReg <= '0'; ALUOp <= "00";
    RegWrite <= '0'; Br_gtz <= '0'; Br_ne <= '0';
    
        case Instr is
        when "000000" => RegDst <= '1'; 
                         RegWrite <= '1';
                         ALUOp <= "00";
        when "001000" => ExtOp <= '1';
                         ALUSrc <= '1';
                         RegWrite <= '1';
                         ALUOp <= "01";
        when "100011" => ExtOp <= '1';
                         ALUSrc <= '1';
                         RegWrite <= '1';
                         ALUOp <= "01";
                         MemToReg <= '1';
        when "101011" => ExtOp <= '1';
                         MemWrite <= '1';
                         ALUOp <= "01";
                         ALUSrc <= '1';
        when "000100" => ExtOp <= '1';
                         Branch <= '1';
                         ALUOp <= "10";
        when "000111" => ExtOp <= '1';
                         Br_gtz <= '1';
                         ALUOp <= "10";
        when "000101" => ExtOp <= '1';
                         Br_ne <= '1';
                         ALUOp <= "10";
        when "000010" => jump <= '1';
        when others   => null;  -- Nu face nimic pentru opcoduri necunoscute
    end case;

    end process;

end Behavioral;
