-- Ficheiro: phi111_tb.vhd (VERSÃO COM EDGE CASES)
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity phi111_tb is
end phi111_tb;

architecture comportamento of phi111_tb is
	signal s_clk, s_inicio : std_logic := '0';
	signal s_reset : std_logic := '1';
	signal s_A, s_B : std_logic_vector(7 downto 0);
	signal s_pronto : std_logic;
	signal s_mult : std_logic_vector(7 downto 0);
	constant CLK_PERIOD : time := 10 ns;
begin
	dut : entity work.phi111_multiplicador
	port map(
		clk    => s_clk,
		reset  => s_reset,
		inicio => s_inicio,
		A      => s_A,
		B      => s_B,
		pronto => s_pronto,
		mult   => s_mult
	);

	s_clk <= not s_clk after CLK_PERIOD / 2;
	
	stimulus_proc: process
	begin
		-- 1. Fase de Reset Inicial
		s_reset <= '1';
		s_inicio <= '0';
		wait until rising_edge(s_clk);
		wait until rising_edge(s_clk);
		s_reset <= '0';

		-------------------------------------------------
		-- TESTE 1: 3 x 3 (Validação básica)
		-------------------------------------------------
		s_A <= std_logic_vector(to_unsigned(3, 8));
		s_B <= std_logic_vector(to_unsigned(3, 8));
		s_inicio <= '1';
		wait until rising_edge(s_clk);
		s_inicio <= '0';
		wait until s_pronto = '1';

		-- Pequena pausa entre os testes
		wait until rising_edge(s_clk);
		wait until rising_edge(s_clk);

		-------------------------------------------------
		-- TESTE 2: 10 x 0 (Edge Case sugerido)
		-------------------------------------------------
		s_A <= std_logic_vector(to_unsigned(10, 8));
		s_B <= std_logic_vector(to_unsigned(0, 8));
		s_inicio <= '1';
		wait until rising_edge(s_clk);
		s_inicio <= '0';
		wait until s_pronto = '1';

		-- Pequena pausa entre os testes
		wait until rising_edge(s_clk);
		wait until rising_edge(s_clk);

		-------------------------------------------------
		-- TESTE 3: 0 x 10 (A outra condição de zero)
		-------------------------------------------------
		s_A <= std_logic_vector(to_unsigned(0, 8));
		s_B <= std_logic_vector(to_unsigned(10, 8));
		s_inicio <= '1';
		wait until rising_edge(s_clk);
		s_inicio <= '0';
		wait until s_pronto = '1';

		-- Pequena pausa entre os testes
		wait until rising_edge(s_clk);
		wait until rising_edge(s_clk);
		
		-------------------------------------------------
		-- TESTE 4: 1 x 15 (Multiplicação por um)
		-------------------------------------------------
		s_A <= std_logic_vector(to_unsigned(1, 8));
		s_B <= std_logic_vector(to_unsigned(15, 8));
		s_inicio <= '1';
		wait until rising_edge(s_clk);
		s_inicio <= '0';
		wait until s_pronto = '1';

		-- Fim da simulação
		wait;
	end process;
end comportamento;