library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity phi111_multiplicador is
	port(
		clk, reset, inicio : in  std_logic;
		A, B : in std_logic_vector(7 downto 0);
		pronto : out std_logic;
		mult : out std_logic_vector(7 downto 0)
	);
end phi111_multiplicador;

architecture comportamento of phi111_multiplicador is
	signal s_B_eq_zero, s_A_eq_zero, s_A_eq_um : std_logic;
	signal s_P_carga, s_P_reset, s_A_carga_dec, s_A_carga_op, s_A_reset, s_op_sel : std_logic;
begin
	bc: entity work.bc_multiplicador
	port map(
		clk => clk,
		reset => reset,
		inicio => inicio,
		B_eq_zero => s_B_eq_zero,
		A_eq_zero => s_A_eq_zero,
		A_eq_um => s_A_eq_um,
		P_carga => s_P_carga,
		P_reset => s_P_reset, 
		A_carga_dec => s_A_carga_dec,
		A_carga_op => s_A_carga_op,
		A_reset => s_A_reset,
		op_sel => s_op_sel,
		pronto => pronto
	);

	bo : entity work.bo_multiplicador
	port map(
		clk => clk,
		reset => reset,
		A => A,
		B => B,
		B_eq_zero => s_B_eq_zero,
		A_eq_zero => s_A_eq_zero,
		A_eq_um => s_A_eq_um,
		P_carga => s_P_carga,
		P_reset => s_P_reset, 
		A_carga_dec => s_A_carga_dec,
		A_carga_op => s_A_carga_op,
		A_reset => s_A_reset,
		op_sel => s_op_sel,
		P_out => mult
	);
end comportamento;