----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2025 07:43:30 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
  Port (MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en : in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        ALUResOut: out std_logic_vector(31 downto 0)
        );
end MEM;

architecture Behavioral of MEM is

type t_mem is array(0 to 63) of std_logic_vector(31 downto 0);
signal mem: t_mem := (
    0 => X"0000000A", -- X = 10
    1 => X"0000000C", -- pointer la vector, adresa 12 (3*4 bytes)
    2 => X"00000000", -- rezultat (va deveni 2)
    3 => X"00000005", -- vector[0] < X
    4 => X"0000000F", -- vector[1] >= X
    5 => X"00000003", -- vector[2] < X
    6 => X"00000000", -- terminator
    others => X"00000000"
);

signal Address : std_logic_vector(5 downto 0);

begin

Address <= ALUResIn(7 downto 2);

    process(clk)
    begin
        if rising_edge(clk)then 
            if en = '1' and MemWrite = '1' then
                mem(conv_integer(Address)) <= RD2;
            end if;
        end if;  
    end process;
    
    MemData <= mem(conv_integer(Address));
    
    ALUResOut <= ALUResIn;


end Behavioral;
