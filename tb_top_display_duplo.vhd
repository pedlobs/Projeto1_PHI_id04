library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.all;                -- Biblioteca para manipulação de arquivos de texto
use IEEE.STD_LOGIC_TEXTIO.all;     -- Biblioteca para ler/escrever std_logic em texto

-- A entidade de um testbench é sempre vazia, pois ele é o topo do mundo da simulação.
entity tb_top_display_duplo is
end tb_top_display_duplo;

architecture test of tb_top_display_duplo is

    -- 1. Declare o componente que você quer testar (seu design principal)
    component top_display_duplo
        Port (
            binary_input1 : in  STD_LOGIC_VECTOR(3 downto 0);
            binary_input2 : in  STD_LOGIC_VECTOR(3 downto 0);
            intercambia   : in  STD_LOGIC;
            segments1     : out STD_LOGIC_VECTOR(6 downto 0);
            segments2     : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- 2. Crie sinais internos para conectar ao componente a ser testado
    signal s_bin1      : STD_LOGIC_VECTOR(3 downto 0);
    signal s_bin2      : STD_LOGIC_VECTOR(3 downto 0);
    signal s_intercambia : STD_LOGIC;
    signal s_seg1      : STD_LOGIC_VECTOR(6 downto 0);
    signal s_seg2      : STD_LOGIC_VECTOR(6 downto 0);

begin

    -- 3. Instancie o Componente (chamamos de Unit Under Test - UUT)
    --    e conecte os sinais internos às portas do seu design.
    UUT: top_display_duplo
        port map (
            binary_input1 => s_bin1,
            binary_input2 => s_bin2,
            intercambia   => s_intercambia,
            segments1     => s_seg1,
            segments2     => s_seg2
        );

    -- 4. Crie o processo de estímulo, que vai ler e escrever nos arquivos.
    stimulus_process: process
        -- Declaração dos arquivos
        file f_in  : TEXT open read_mode is "F:\Biblioteca\Documentos\QuartusProjects\entradas.txt";
        file f_out : TEXT open write_mode is "saidas.txt";

        -- Variáveis para os buffers de linha
        variable L_in, L_out : LINE;

        -- Variáveis para armazenar os valores lidos da linha
        variable v_bin1, v_bin2 : STD_LOGIC_VECTOR(3 downto 0);
        variable v_intercambia  : STD_LOGIC;
        
    begin
        -- Escreve um cabeçalho no arquivo de saída para ficar mais organizado
        write(L_out, string'("Resultados da Simulacao"));
        writeline(f_out, L_out);
        write(L_out, string'("Segments1       Segments2"));
        writeline(f_out, L_out);
        write(L_out, string'("---------------------------"));
        writeline(f_out, L_out);

        -- Loop que executa enquanto houver linhas no arquivo de entrada
        while not endfile(f_in) loop
            -- Lê uma linha inteira do arquivo de entrada
            readline(f_in, L_in);

            -- Extrai os valores da linha e os armazena nas variáveis
            read(L_in, v_bin1);
            read(L_in, v_bin2);
            read(L_in, v_intercambia);

            -- Aplica os valores lidos aos sinais que estão conectados ao seu design
            s_bin1 <= v_bin1;
            s_bin2 <= v_bin2;
            s_intercambia <= v_intercambia;

            -- Aguarda um tempo para que a lógica do seu design processe as entradas
            wait for 10 ns;

            -- Escreve os valores de saída (que já foram calculados pelo seu design)
            -- no buffer de linha de saída
            write(L_out, s_seg1);
            write(L_out, string'("         ")); -- Adiciona um espaço para alinhar as colunas
            write(L_out, s_seg2);
            
            -- Escreve a linha completa no arquivo de saída
            writeline(f_out, L_out);

        end loop;

        -- Fecha os arquivos (é uma boa prática de programação)
        file_close(f_in);
        file_close(f_out);

        -- Envia uma mensagem para o console do ModelSim indicando o fim
        report "Simulacao concluida a partir de arquivo. Verifique o arquivo saidas.txt";
        
        -- O processo para aqui e a simulação termina.
        wait;
    end process;

end test;