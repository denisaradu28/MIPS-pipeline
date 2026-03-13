----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2025 06:40:42 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
  Port (clk: in std_logic;
        Instr: in std_logic_vector(25 downto 0);
        WA: in std_logic_vector(4 downto 0);
        WD: in std_logic_vector(31 downto 0);
        RegWr: in std_logic;
        RD1: out std_logic_vector(31 downto 0);
        RD2: out std_logic_vector(31 downto 0);
        en: in std_logic;
        ExtImm: out std_logic_vector(31 downto 0);
        Func: out std_logic_vector(5 downto 0);
        SA: out std_logic_vector(4 downto 0);
        ExtOp: in std_logic;
        RT: out std_logic_vector(4 downto 0);
        RD: out std_logic_vector(4 downto 0)
       );
end ID;

architecture Behavioral of ID is

type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file: reg_array:=(others => X"00000000");
signal RA1: std_logic_vector(4 downto 0);
signal RA2: std_logic_vector(4 downto 0);
signal imm : std_logic_vector(15 downto 0);

begin


    process(clk)
    begin
        if falling_edge(clk)then
            if en = '1' and RegWr = '1' then
                reg_file(conv_integer(WA)) <= WD;
            end if;
        end if;
    end process;
   

    RA1 <= Instr(25 downto 21);
    RA2 <= Instr(20 downto 16);

    RD1 <= reg_file(conv_integer(RA1));
    RD2 <= reg_file(conv_integer(RA2));
    
    Func <= Instr(5 downto 0);
    SA <= Instr(10 downto 6);

    RT <= Instr(20 downto 16);
    RD <= Instr(15 downto 11);
    
    ExtImm(15 downto 0) <= Instr(15 downto 0);
    ExtImm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1'
    else (others => '0');

end Behavioral;
