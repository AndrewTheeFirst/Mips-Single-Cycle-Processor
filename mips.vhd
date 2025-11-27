library ieee;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity mips is
    port(
        reset                   : in std_logic;
        slow_clock, fast_clock  : in std_logic;
        PC_out, Instruction_out : out std_logic_vector(31 downto 0);
        Read_reg1_out           : out std_logic_vector( 4 downto 0);
        Read_reg2_out           : out std_logic_vector( 4 downto 0);
        Write_reg_out           : out std_logic_vector( 4 downto 0);
        Read_data1_out          : out std_logic_vector(31 downto 0);
        Read_data2_out          : out std_logic_vector(31 downto 0);
        Write_data_out          : out std_logic_vector(31 downto 0)
    );
end mips;

architecture arch of mips is
-- declare components (modules)
    component mips_rom
        PORT
        (
            address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            q		    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END component;

    component mips_ram
        PORT
        (
            address		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            wren		: IN STD_LOGIC ;
            q		    : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END component;

    component mips_sign_extend
        port(
            data_in     : in std_logic_vector(15 downto 0);
            data_out    : out std_logic_vector(31 downto 0)
        );
    end component;

    component mips_pc
        port(
            bus_in 	: in std_logic_vector(31 downto 0);
            bus_out : out std_logic_vector(31 downto 0);
            clock 	: in std_logic;
            reset_n : in std_logic
        );
    end component;

    component mips_register_file 
        port(
            clock, reset, RegWrite  : in    std_logic;
            read_reg1, read_reg2    : in    std_logic_vector(4 downto 0);
            write_reg               : in    std_logic_vector(4 downto 0);
            write_data              : in    std_logic_vector(31 downto 0);
            read_data1, read_data2  : out   std_logic_vector(31 downto 0)
        );
    end component;

    component mips_control 
        port(   
            opcode              : in std_logic_vector(5 downto 0);
            funct               : in std_logic_vector(5 downto 0);
            RegDst, ALUSrc      : out std_logic;
            Jump, Jal, Jr       : out std_logic;
            Beq, Bne            : out std_logic;
            MemRead, MemWrite   : out std_logic;
            RegWrite, MemtoReg  : out std_logic;
            ALUControl          : out std_logic_vector(3 downto 0)
        );
    end component;

    component mips_alu
        port(
            ALUControl      : in std_logic_vector( 3 downto 0);
            inputA, inputB  : in std_logic_vector(31 downto 0);
            shamt           : in std_logic_vector( 4 downto 0);
            Zero            : out std_logic;
            ALU_Result      : out std_logic_vector(31 downto 0)
        );
    end component;
-- declare signals (wires)
    signal PC_OUT_WIRE          : std_logic_vector(31 downto 0);
    signal Instruction          : std_logic_vector(31 downto 0);
    signal RegDst_WIRE          : std_logic;
    signal RegDst_MUXOUT        : std_logic_vector(4 downto 0);
    signal ALUSrc_WIRE          : std_logic;
    signal ALUSrc_MUXOUT        : std_logic_vector(31 downto 0);
    signal Branch_MUXSEL        : std_logic;
    signal Branch_MUXOUT        : std_logic_vector(31 downto 0);
    signal Jump_MUXSEL          : std_logic;
    signal Jump_MUXOUT          : std_logic_vector(31 downto 0);
    signal SignExtendImm        : std_logic_vector(31 downto 0);
    signal RegWrite_WIRE        : std_logic;
    signal read_data1_WIRE      : std_logic_vector(31 downto 0);
    signal read_data2_WIRE      : std_logic_vector(31 downto 0);
    signal ALU_Result_WIRE      : std_logic_vector(31 downto 0);
    signal ALUControl_WIRE      : std_logic_vector(3 downto 0);
    signal MemWrite_WIRE        : std_logic;
    signal MemRead_WIRE         : std_logic;
    signal ALUZeroBit_WIRE      : std_logic;
    signal BEQ_WIRE             : std_logic;
    signal BNE_WIRE             : std_logic;
    signal JumpAddr_WIRE        : std_logic_vector(31 downto 0);
    signal PC_PLUS_FOUR         : std_logic_vector(31 downto 0);
    signal MemtoReg_WIRE        : std_logic;
    signal MemtoReg_MUXOUT      : std_logic_vector(31 downto 0);
    signal ReadMemData_WIRE     : std_logic_vector(31 downto 0);
    signal Jal_WIRE             : std_logic;
    signal Jal_MemtoReg_MUXOUT  : std_logic_vector(31 downto 0);
    signal Jal_RegDst_MUXOUT    : std_logic_vector(4 downto 0);
    signal Jr_WIRE              : std_logic;
    signal Jr_MUXOUT            : std_logic_vector(31 downto 0);

begin
-- connect component ports and signals - port map
    SIGN_EXT: mips_sign_extend port map(
        data_in     => Instruction(15 downto 0),
        data_out    => SignExtendImm
    );

    ALU: mips_alu port map(
        ALUControl  => ALUControl_WIRE,
        inputA      => read_data1_WIRE,
        inputB      => ALUSrc_MUXOUT,
        shamt       => Instruction(10 downto 6),
        Zero        => ALUZeroBit_WIRE,
        ALU_Result  => ALU_Result_WIRE
    );

    REGISTER_FILE: mips_register_file port map(
        clock       => slow_clock,
        reset       => reset,
        RegWrite    => RegWrite_WIRE,
        read_reg1   => Instruction(25 downto 21),
        read_reg2   => Instruction(20 downto 16),
        write_reg   => Jal_RegDst_MUXOUT,
        write_data  => Jal_MemtoReg_MUXOUT,
        read_data1  => read_data1_WIRE,
        read_data2  => read_data2_WIRE
    );

    CONTROL: mips_control port map(
        opcode      => Instruction(31 downto 26),
        funct       => Instruction(5 downto 0),
        RegDst      => RegDst_WIRE,
        ALUSrc      => ALUSrc_WIRE,
        Jump        => Jump_MUXSEL,
        Jal         => Jal_WIRE,
        Jr          => Jr_WIRE,
        Beq         => BEQ_WIRE,
        Bne         => BNE_WIRE,
        MemRead     => MemRead_WIRE,
        MemWrite    => MemWrite_WIRE,
        RegWrite    => RegWrite_WIRE,
        MemtoReg    => MemtoReg_WIRE,
        ALUControl  => ALUControl_WIRE
    );
        
    PC: mips_pc port map(
        bus_in 	=> Jr_MUXOUT,
        bus_out => PC_OUT_WIRE,
        clock 	=> slow_clock,
        reset_n => reset
    );

    RAM: mips_ram port map(
        address => ALU_Result_WIRE(7 downto 2),
        clock   => fast_clock,
        data    => read_data2_WIRE,
        wren    => MemWrite_WIRE,
        q       => ReadMemData_WIRE
    );

    ROM: mips_rom port map (
        address	=> PC_OUT_WIRE(7 downto 2),
        clock	=> fast_clock,
        q		=> Instruction
    );

    -- mux logic + combinational
    PC_PLUS_FOUR <= PC_OUT_WIRE + X"00000004";
    Branch_MUXSEL <= '1' when ((BEQ_WIRE = '1' and ALUZeroBit_WIRE = '1')
    or (BNE_WIRE = '1' and ALUZeroBit_WIRE = '0'))
    else '0';
    JumpAddr_WIRE <= PC_PLUS_FOUR(31 downto 28) & Instruction(25 downto 0) & "00";
    
    with ALUSrc_WIRE select ALUSrc_MUXOUT <=
        read_data2_WIRE when '0',
        SignExtendImm when others;
    
    with MemtoReg_WIRE select MemtoReg_MUXOUT <=
        ALU_Result_WIRE when '0',
        ReadMemData_WIRE when others;
        
    -- FEEDS INTO WRITE DATA
    with Jal_WIRE select Jal_MemtoReg_MUXOUT <=
        MemtoReg_MUXOUT when '0',
        read_data1_WIRE when others;
        
    with RegDst_WIRE select RegDst_MUXOUT <= 
        Instruction(20 downto 16) when '0',
        Instruction(15 downto 11) when others;
    
    -- FEEDS INTO WRITE REGISTER
    with Jal_WIRE select Jal_RegDst_MUXOUT <=
        RegDst_MUXOUT when '0',
        "11111" when others;

    with Branch_MUXSEL select Branch_MUXOUT <=
        PC_PLUS_FOUR when '0',
        (SignExtendImm(29 downto 2) & "00") + PC_PLUS_FOUR when others; -- adds pc + 4 + branch offset

    with Jump_MUXSEL select Jump_MUXOUT <=
        Branch_MUXOUT when '0',
        JumpAddr_WIRE when others;

    -- FEEDS INTO PC REGISTER
    with Jr_WIRE select Jr_MUXOUT <=
        Jump_MUXOUT when '0',
        read_data1_WIRE when others;

-- connect top levels
    PC_out          <= PC_OUT_WIRE;
    Instruction_out <= Instruction;
    Read_reg1_out   <= Instruction(25 downto 21);
    Read_reg2_out   <= Instruction(20 downto 16);
    Write_reg_out   <= Jal_RegDst_MUXOUT;
    Read_data1_out  <= read_data1_WIRE;
    Read_data2_out  <= read_data2_WIRE;
    Write_data_out  <= Jal_MemtoReg_MUXOUT;

end arch;