----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2025 07:07:05 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
  Port (clk: in std_logic;
        rst: in std_logic;
        en: in std_logic;
        jump: in std_logic;
        jumpAddress: in std_logic_vector(31 downto 0);
        pcSrc: in std_logic;
        branchAddress: in std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal D: std_logic_vector(31 downto 0);
type t_mem is array(0 to 31) of std_logic_vector(31 downto 0);

-- Se parcurge memoria pana la intalnirea unei valori nule si se numara cate valori sunt mai mici decat valoarea data X.            
signal rom: t_mem := (
    B"100011_00000_00010_0000000000000000",      -- LW $2, 0($0) => 0x8C020000  => incarcam valoarea X la adresa 0

    B"100011_00000_00011_0000000000000100",      -- LW $3, 4($0) => 0x8C030004  => incarcam prima valoare din vectorul A la adresa 4
    
    B"000000_00000_00000_00101_00000_100000",    -- ADD $5, $0, $0  => 0x00002820 => initializam counterul
    
    B"100011_00011_00100_0000000000000000",      -- LW $4, 0($3) =>  0x8C640000 => incarcam valoarea curenta din vector in $4
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020

    B"000100_00100_00000_0000000000001101",      -- BEQ $4, $0, 13  =>  0x1080000D  => daca $4 == 0 sarim la final
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020

    B"000000_00100_00010_00110_00000_101010",    -- SLT $6, $4, $2  =>  0x0082302A  => comparam valoarea curenta cu X: daca $4 < $2 => $6 = 1, altfel $6 = 0
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020

    B"000100_00110_00000_0000000000000101",      -- BEQ $6, $0, 5  =>  0x10C00005  => daca $6 == 0 sarim peste incrementarea counterului
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020

    B"001000_00101_00101_0000000000000001",      -- ADDI $5, $5, 1  =>  0x20A50001  => incrementam count

    B"001000_00011_00011_0000000000000100",      -- ADDI $3, $3, 4  =>  0x20630004  => sarim la inceputul buclei

    B"000010_00000000000000000000000011",        -- J 3 => 0x08000003
    B"000000_00000_00000_00000_00000_100000",    -- NoOp  =>  0x00000020
    
    B"101011_00000_00101_0000000000001000",      -- SW $5, 8($0)  => 0xAC050008  => scriem rezultatul la adresa 8

    others => X"00000000"
);

    
signal Q: std_logic_vector(31 downto 0);
signal sum: std_logic_vector(31 downto 0);
signal mux1: std_logic_vector(31 downto 0);
signal data: std_logic_vector(31 downto 0);

begin

sum <= Q + X"00000004";

pc <= sum;

process(branchAddress, pcSrc, sum)
begin

    if pcSrc = '0' then
        mux1 <= sum;
    else mux1 <= branchAddress;
    end if;
end process;

process(jump, jumpAddress, mux1)
begin

    if jump = '0' then
        D <= mux1;
    else D <= jumpAddress;
    
    end if; 

end process;

process(clk, rst)
begin

    if rst = '1' then
        Q <= (others => '0');
    elsif rising_edge(clk) then
        if en = '1' then
            Q <= D;
        end if;
     end if;

end process;

data <= rom(conv_integer(Q(6 downto 2)));
instruction <= data; 

end Behavioral;
