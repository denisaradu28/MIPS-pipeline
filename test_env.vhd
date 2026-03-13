library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD
    Port(clk: in std_logic;
        digits:in std_logic_vector(31 downto 0);
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0));
end component;

component IFetch
    Port (clk: in std_logic;
        rst: in std_logic;
        en: in std_logic;
        jump: in std_logic;
        jumpAddress: in std_logic_vector(31 downto 0);
        pcSrc: in std_logic;
        branchAddress: in std_logic_vector(31 downto 0);
        pc: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0));
end component;

component ID 
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
end component;

component UC
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
end component;

component EX
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
end component; 

component MEM
    Port (MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en : in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        ALUResOut: out std_logic_vector(31 downto 0)
        );
end component;

signal cnt:std_logic_vector(4 downto 0):=(others=>'0');
signal en:std_logic;

signal result: std_logic_vector(31 downto 0);

signal Jump: std_logic;
signal jAddr: std_logic_vector(31 downto 0);
signal PCSrc: std_logic;
signal BrAddr: std_logic_Vector(31 downto 0);
signal Instr: std_logic_vector(31 downto 0);
signal regDst: std_logic; 
signal regWr: std_logic;
signal extOp: std_logic;
signal aluSrc: std_logic;
signal branch: std_logic;
signal aluOp: std_logic_vector(1 downto 0);
signal memWr: std_logic;
signal memToreg: std_logic;
signal bgtz: std_logic;
signal bne: std_logic;
signal rd1: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal extImm: std_logic_vector(31 downto 0);
signal sa: std_logic_vector(4 downto 0);
signal func: std_logic_vector(5 downto 0);
signal PC: std_logic_vector(31 downto 0);
signal aluRes: std_logic_vector(31 downto 0);
signal zero: std_logic;
signal gtz: std_logic;
signal ne: std_logic;
signal memData: std_logic_vector(31 downto 0);
signal aluResOut: std_logic_vector(31 downto 0);
signal mux: std_logic_vector(31 downto 0);
signal writeAddress: std_logic;
signal rt: std_logic_vector(4 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal rwa: std_logic_vector(4 downto 0);

--REGSTRII PIPELINE
signal Instruction_IF_ID: std_logic_vector(31 downto 0);
signal PCp4_IF_ID: std_logic_vector(31 downto 0);

signal PCp4_ID_EX: std_logic_vector(31 downto 0);
signal RegDst_ID_EX: std_logic;
signal ALUSrc_ID_EX: std_logic;
signal Branch_ID_EX: std_logic;
signal ALUOp_ID_EX: std_logic_vector(1 downto 0);
signal MemWrite_ID_EX: std_logic;
signal Mem2Reg_ID_EX: std_logic;
signal RegWrite_ID_EX: std_logic;
signal RD1_ID_EX: std_logic_vector(31 downto 0);
signal RD2_ID_EX: std_logic_vector(31 downto 0);
signal ExtImm_ID_EX: std_logic_vector(31 downto 0);
signal Func_ID_EX: std_logic_vector(5 downto 0);
signal SA_ID_EX: std_logic_vector(4 downto 0);
signal RT_ID_EX: std_logic_vector(4 downto 0);
signal RD_ID_EX: std_logic_vector(4 downto 0);
signal BrGTZ_ID_EX: std_logic;
signal BrNE_ID_EX: std_logic;

signal Branch_EX_MEM: std_logic;
signal MemWrite_EX_MEM: std_logic;
signal Mem2Reg_EX_MEM: std_logic;
signal RegWrite_EX_MEM: std_logic;
signal Zero_EX_MEM: std_logic;
signal BrAddr_EX_MEM: std_logic_vector(31 downto 0);
signal ALURes_EX_MEM: std_logic_vector(31 downto 0);
signal WA_EX_MEM: std_logic_vector(4 downto 0);
signal RD2_EX_MEM: std_logic_vector(31 downto 0);
signal BrGTZ_EX_MEM: std_logic;
signal BrNE_EX_MEM: std_logic;
signal GTZ_EX_MEM: std_logic;
signal NE_EX_MEM: std_logic;

signal Mem2Reg_MEM_WB: std_logic;
signal RegWrite_MEM_WB: std_logic;
signal ALURes_MEM_WB: std_logic_vector(31 downto 0);
signal MemData_MEM_WB: std_logic_vector(31 downto 0);
signal WA_MEM_WB: std_logic_vector(4 downto 0);

begin


monopulse:MPG port map(en,btn(0),clk);

display: SSD port map (clk, result, an, cat);

fetch: IFetch port map(clk, btn(1), en, Jump, jAddr, pcSrc, BrAddr, PC, Instr);

Instruction_Decode: ID port map(clk, Instruction_IF_ID(25 downto 0), WA_MEM_WB, mux, RegWrite_MEM_WB, rd1, rd2, en, extImm, func, sa, extOp, rt, rd);

Unitate_control: UC port map(Instruction_IF_ID(31 downto 26), regDst, extOp, aluSrc, branch, Jump, aluOp, memWr, memToreg, regWr, bgtz, bne);

InstructionExecute: EX port map(RD1_ID_EX, ALUSrc_ID_EX, RD2_ID_EX, ExtImm_ID_EX, SA_ID_EX, Func_ID_EX, ALUOp_ID_EX, PCp4_ID_EX, RT_ID_EX, RD_ID_EX, RegDst_ID_EX,  aluRes, BrAddr, zero, gtz, ne, rwa);

Memory: MEM port map(MemWrite_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM, clk, en, memData, aluResOut);

--mux de la final

process(MemData_MEM_WB, ALURes_MEM_WB, Mem2Reg_MEM_WB)
begin

    if Mem2Reg_MEM_WB = '0' then
        mux <= ALURes_MEM_WB;
    else 
        mux <= MemData_MEM_WB;
    end if;
end process;

--calcul pcSrc si jAddr

pcSrc <= (Branch_EX_MEM and Zero_EX_MEM) or (BrNE_EX_MEM and NE_EX_MEM) or (BrGTZ_EX_MEM and GTZ_EX_MEM);
jAddr <= PCp4_IF_ID(31 downto 28) & (Instruction_IF_ID(25 downto 0) & "00");

-- mux pt ssd

process(sw(7 downto 5), Instr, PC, rd1, rd2, extImm, aluRes, memData, mux)
begin

    case sw(7 downto 5) is
        when "000" => result <= Instr;
        when "001" => result <= PC;
        when "010" => result <= RD1_ID_EX;
        when "011" => result <= RD2_ID_EX;
        when "100" => result <= ExtImm_ID_EX;
        when "101" => result <= aluRes;
        when "110" => result <= memData;
        when "111" => result <= mux;
        when others => result <= (others => '0');

    end case;
end process; 

-- leduri

led(11 downto 0) <= bne & bgtz & aluOp & regDst & extOp & aluSrc & branch & Jump & memWr & memToreg & regWr; 


--REGISTRU 1 IF-ID
process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            Instruction_IF_ID <= Instr;
            PCp4_IF_ID <= PC;
        end if;
    end if;
end process;

--REGISTRU 2 ID-EX
process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            RegDst_ID_EX <= regDst;
            ALUSrc_ID_EX <= aluSrc;
            Branch_ID_EX <= branch;
            ALUOp_ID_EX <= aluOp;
            MemWrite_ID_EX <= memWr;
            Mem2Reg_ID_EX <= memToreg;
            RegWrite_ID_EX <= regWr;
            RD1_ID_EX <= rd1;
            RD2_ID_EX <= rd2;
            ExtImm_ID_EX <= extImm;
            Func_ID_EX <= func;
            SA_ID_EX <= sa;
            RT_ID_EX <= rt;
            RD_ID_EX <= rd;
            BrGTZ_ID_EX <= bgtz;
            BrNE_ID_EX <= bne;
            PCp4_ID_EX <= PCp4_IF_ID;
        end if;
    end if;
end process;

--REGISTRU 3 EX-MEM
process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            Branch_EX_MEM <= Branch_ID_EX;
            MemWrite_EX_MEM <= MemWrite_ID_EX;
            Mem2Reg_EX_MEM <= Mem2Reg_ID_EX;
            Zero_EX_MEM <= zero;
            ALURes_EX_MEM <= aluRes;
            BrAddr_EX_MEM <= BrAddr;
            WA_EX_MEM <= rwa;
            RD2_EX_MEM <= RD2_ID_EX;
            BrGTZ_EX_MEM <= BrGTZ_ID_EX;
            BrNE_EX_MEM <= BrNE_ID_EX;
            GTZ_EX_MEM <= gtz;
            NE_EX_MEM <= ne;
        end if;
    end if;
end process;

--REGISTRU 4 MEM-WB
process(clk)
begin
    if rising_edge(clk) then
        if en = '1' then
            Mem2Reg_MEM_WB <= Mem2Reg_EX_MEM;
            RegWrite_MEM_WB <= RegWrite_EX_MEM;
            ALURes_MEM_WB <= aluResOut;
            MemData_MEM_WB <= memData;
            WA_MEM_WB <= WA_EX_MEM;
        end if;       
    end if;
end process;

end Behavioral;