----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2022 06:28:02 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in std_logic;
           btn : in std_logic_vector (4 downto 0);
           sw : in std_logic_vector (15 downto 0);
           led : out std_logic_vector (15 downto 0);
           an : out std_logic_vector (3 downto 0);
           cat : out std_logic_vector (6 downto 0));

end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( btn : in std_logic;
           clk : in std_logic;
           en : out std_logic);
end component;

component SSD is
    Port ( digit : in std_logic_vector (15 downto 0);
           clk : in std_logic;
           cat : out std_logic_vector (6 downto 0);
           an : out std_logic_vector (3 downto 0));
end component;

component IFF is
    Port ( clk : in std_logic; 
           en : in std_logic;  
           jmpA : in std_logic_vector (15 downto 0); 
           brA : in std_logic_vector (15 downto 0); 
           jmp : in std_logic; 
           pcsrc : in std_logic; 
           rst : in std_logic; 
           instr : out std_logic_vector (15 downto 0);
           next_instr : out std_logic_vector (15 downto 0);  -- PC + 1 pe schema 
           
           jrAdress: in std_logic_vector (15 downto 0); 
           jmpR: in std_logic
     );

end component;

component ID is
    Port ( clk : in std_logic;
           en : in std_logic;
           instr : in std_logic_vector (15 downto 0);
           wd : inout std_logic_vector (15 downto 0);
           RegWrite : in std_logic;
           RegDst : in std_logic;
           ExtOp : in std_logic;
           RD1 : inout std_logic_vector (15 downto 0);
           RD2 : inout std_logic_vector (15 downto 0);
           ExtImm : out std_logic_vector (15 downto 0);
           func : out std_logic_vector (2 downto 0);
           sa : out std_logic);

end component;

component UC is
    Port ( 
        Instr : in std_logic_vector(15 downto 0);
        RegDst : out std_logic;
        ExtOp : out std_logic;
        ALUSRC : out std_logic;
        Branch : out std_logic;
        Jump : out std_logic;
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic;
        ALUOp : out std_logic_vector(2 downto 0);
        
        Bgez : out std_logic;
        Bltz : out std_logic;
        jmpR : out std_logic
   );

end component;

component EX is
    Port(next_instr: in std_logic_vector (15 downto 0);
         rd1: in std_logic_vector (15 downto 0);
         rd2: in std_logic_vector (15 downto 0);
         extImm: in std_logic_vector (15 downto 0);
         func: in std_logic_vector (2 downto 0);
         sa: in std_logic;
         ALUSrc: in std_logic;
         ALUOp: in std_logic_vector (2 downto 0);
         branchAddr: out std_logic_vector (15 downto 0);
         ALURes: out std_logic_vector (15 downto 0);
         Zero: out std_logic; -- out beq
         GE: out std_logic; --out bgez
         GL: out std_logic -- out bltz
    );
end component;

component MEM is
  Port ( 
        clk :       in std_logic;
        enable :    in std_logic;
        r_data : in std_logic_vector (15 downto 0);
        AluResIn :  in std_logic_vector (15 downto 0);
        MemWrite :  in std_logic;
        memdata :    out std_logic_vector (15 downto 0);
        AluResOut : out std_logic_vector (15 downto 0)
  );
end component;

signal en0 : std_logic;
signal en1 : std_logic;
signal next_instr : std_logic_vector (15 downto 0) := x"0000";
signal instr : std_logic_vector (15 downto 0) := x"0000";
signal branch_addr : std_logic_vector (15 downto 0) := x"0000";
signal jrAdress: std_logic_vector (15 downto 0);
signal jmpR: std_logic;
signal rdata1:  std_logic_vector(15 downto 0) := x"0000";
signal rdata2:  std_logic_vector(15 downto 0) := x"0000";
signal wdata:   std_logic_vector(15 downto 0):= x"0000";
signal func:    std_logic_vector(2 downto 0) := "000";
signal extImm:  std_logic_vector(15 downto 0) := x"0000";
signal sa:      std_logic := '0';
signal regDst:   std_logic := '0';
signal extOp:    std_logic := '0';
signal aluSrc:   std_logic := '0';
signal branch:   std_logic := '0';
signal bgez:     std_logic := '0';
signal bltz:     std_logic := '0';
signal jump:     std_logic := '0';
signal memWrite: std_logic := '0';
signal memToReg: std_logic := '0';
signal regWrite: std_logic := '0';
signal aluOp:    std_logic_vector(2 downto 0) := "000"; 
signal aluRes: std_logic_vector(15 downto 0) := x"0000";
signal jump_addr: std_logic_vector(15 downto 0) := x"0000";
signal zero: std_logic;
signal ge: std_logic := '0';
signal gl: std_logic := '0';
signal aluResout: std_logic_vector(15 downto 0) := x"0000";
signal memData: std_logic_vector(15 downto 0) := x"0000";
signal ssd_signal : std_logic_vector(15 downto 0) := x"0000";
signal pcsrc: std_logic; 
signal out_mux: std_logic_vector(15 downto 0) := x"0000";

begin

    M0: MPG port map(btn(0), clk, en0);
    M1: MPG port map(btn(1), clk, en1);
   
    jump_addr <= next_instr(15 downto 13) & instr(12 downto 0);
    -- pcsrc <= branch and zero;
    I: IFF port map (clk, en0, jump_addr, branch_addr, jump, pcsrc, en1, instr, next_instr, rdata1, jmpR);
    
    out_mux <= aluResout when memToReg = '0' else memData;
    IDD: ID port map (clk, en0, instr, out_mux, regWrite, regDst, extOp, rdata1, rdata2, extImm, func, sa);
    U: UC port map(instr, regDst, extOp, aluSrc, branch, jump, memWrite, memToReg, regWrite, aluOp, bgez, bltz, jmpR);
    
    E: EX port map(next_instr, rdata1, rdata2, extImm, func, sa, aluSrc, aluOp, branch_addr, aluRes, zero, ge, gl);
    
    M: MEM port map(clk, en0, rdata2, aluRes, memWrite,  memData, aluResout);
    
    S: SSD port map(ssd_signal, clk => clk, cat => cat, an => an);
    
    pcsrc <= (branch and zero) or (gl and bltz) or (ge and bgez);
    
    
    mux_afisare: process(sw(7 downto 5))
                 begin 
                         case sw(7 downto 5) is
                            when "000" => ssd_signal <= instr;
                            when "001" => ssd_signal <= next_instr;
                            when "010" => ssd_signal <= rdata1;
                            when "011" => ssd_signal <= rdata2;
                            when "100" => ssd_signal <= extImm;
                            when "101" => ssd_signal <= aluRes;
                            when "110" => ssd_signal <= memData;
                            when "111" => ssd_signal <= out_mux; 
                            when others=> ssd_signal <= (others=>'0');
                         end case;
                 end process;
     led(13 downto 0) <= aluOp & regDst & extOp & aluSrc & branch & bgez & bltz & jump & jmpR & memWrite & memToReg & regWrite;
                       -- 3        1        1       1        1        1      1      1      1        1         1         1  
end Behavioral;
