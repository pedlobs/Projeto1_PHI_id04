library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.all;                -- manipulação de arquivos de texto
use IEEE.STD_LOGIC_TEXTIO.all;     -- ler/escrever std_logic em texto

entity tb_top_display_duplo is
end tb_top_display_duplo;

architecture test of tb_top_display_duplo is

    -- Declara o componente a ser testado
    component top_display_duplo
        Port (
            binary_input1 : in  STD_LOGIC_VECTOR(3 downto 0);
            binary_input2 : in  STD_LOGIC_VECTOR(3 downto 0);
            intercambia   : in  STD_LOGIC;
            segments1     : out STD_LOGIC_VECTOR(6 downto 0);
            segments2     : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Sinais internos para conectar ao componente a ser testado
    signal s_bin1      : STD_LOGIC_VECTOR(3 downto 0);
    signal s_bin2      : STD_LOGIC_VECTOR(3 downto 0);
    signal s_intercambia : STD_LOGIC;
    signal s_seg1      : STD_LOGIC_VECTOR(6 downto 0);
    signal s_seg2      : STD_LOGIC_VECTOR(6 downto 0);

	 constant somasub_val : std_logic_vector(63 downto 0) := x"DEADBEEFBACABA01";
	 constant mux_val     : std_logic_vector(63 downto 0) := x"01234ABCDE56789A";
	
	 signal sel_somasub, sel_mux : std_logic := '0';
	 signal clock : std_logic := '0';
	 

begin

    -- Instancia o componente (UUT) e conecta os sinais internos às portas do componentes sob teste
    UUT: top_display_duplo
        port map (
            binary_input1 => s_bin1,
            binary_input2 => s_bin2,
            intercambia   => s_intercambia,
            segments1     => s_seg1,
            segments2     => s_seg2
        );
		  
	process(clock)
		variable ptr_mux : integer := 0;
	begin
		if rising_edge(clock) then
			sel_somasub <= somasub_val(ptr_mux);
			sel_mux <= mux_val(ptr_mux);
			ptr_mux := ptr_mux + 1;
			if ptr_mux = 64 then
				ptr_mux	 := 0;
			end if;
		end if;
	end process;
	
	
	-- Leitura do arquivo de entrada
	process(clock)
		file f_in 		: TEXT open READ_MODE is "C:\Users\Pedro\Projeto1_PHI_id04-master\Projeto1_PHI_id04\entradas.txt";
		
		variable L_in	: LINE;
		
	   variable v_bin1, v_bin2 : STD_LOGIC_VECTOR(3 downto 0);
	   variable v_intercambia  : STD_LOGIC;
	  
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
				 
			end if;
		end if;
	end process;
	
	-- Escrita no arquivo de saida
	process(clock)
		file f_out		: TEXT open WRITE_MODE is "C:\Users\Pedro\Projeto1_PHI_id04-master\Projeto1_PHI_id04\saida.txt";
		variable L_out : LINE;
	begin
		if rising_edge(clock) then
			write(L_out, s_seg1);
			write(L_out, string'("         "));
			write(L_out, s_seg2);
			
			writeline(f_out, L_out);
		end if;
	end process;
	
	clock <= not clock after 5 ns;
end test;