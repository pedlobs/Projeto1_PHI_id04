library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.all;                -- manipulação de arquivos de texto
use IEEE.STD_LOGIC_TEXTIO.all;     -- ler/escrever std_logic em texto

entity tb_top_display_duplo is
end tb_top_display_duplo;

architecture test of tb_top_display_duplo is

    -- (Declaração do componente e sinais de conexão - sem alterações)
    component top_display_duplo
        Port (
            binary_input1 : in  STD_LOGIC_VECTOR(3 downto 0);
            binary_input2 : in  STD_LOGIC_VECTOR(3 downto 0);
            intercambia   : in  STD_LOGIC;
            segments1     : out STD_LOGIC_VECTOR(6 downto 0);
            segments2     : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal s_bin1        : STD_LOGIC_VECTOR(3 downto 0);
    signal s_bin2        : STD_LOGIC_VECTOR(3 downto 0);
    signal s_intercambia : STD_LOGIC;
    signal s_seg1        : STD_LOGIC_VECTOR(6 downto 0);
    signal s_seg2        : STD_LOGIC_VECTOR(6 downto 0);
    signal clock         : std_logic := '0';
    
    signal s_acabou      : boolean := false;

begin

    UUT: top_display_duplo
        port map (
            binary_input1 => s_bin1,
            binary_input2 => s_bin2,
            intercambia   => s_intercambia,
            segments1     => s_seg1,
            segments2     => s_seg2
        );

    clock <= not clock after 5 ns when s_acabou = false else '0';

    -- Leitura do arquivo de entrada
    leitura_process: process(clock)
        file f_in 		: TEXT open READ_MODE is "C:\Users\Pedro\Projeto1_PHI_id04-master\Projeto1_PHI_id04\entradas.txt";
        variable L_in : LINE;
        variable v_bin1, v_bin2 : STD_LOGIC_VECTOR(3 downto 0);
        variable v_intercambia : STD_LOGIC;
    begin
        if rising_edge(clock) then
            if not endfile(f_in) then
                readline(f_in, L_in);
                read(L_in, v_bin1);
                read(L_in, v_bin2);
                read(L_in, v_intercambia);

                s_bin1 <= v_bin1;
                s_bin2 <= v_bin2;
                s_intercambia <= v_intercambia;
            else
                s_acabou <= true;
            end if;
        end if;
    end process;
    
    -- Escrita no arquivo de saida
    escrita_process: process(clock)
        file f_out		: TEXT open WRITE_MODE is "C:\Users\Pedro\Projeto1_PHI_id04-master\Projeto1_PHI_id04\saida.txt";
        variable L_out : LINE;
        variable primeira_passagem : boolean := true; 
    begin
        if rising_edge(clock) then
            if not s_acabou then
                if not primeira_passagem then
                    write(L_out, s_seg1);
                    write(L_out, string'("         "));
                    write(L_out, s_seg2);
                    writeline(f_out, L_out);
                end if;
                    primeira_passagem := false; 
            end if;
        end if;
    end process;
    
end test;