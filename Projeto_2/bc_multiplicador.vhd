library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bc_multiplicador is
	port(
		clk, reset, inicio : in  std_logic;
		B_eq_zero, A_eq_zero, A_eq_um : in std_logic;
		P_carga, P_reset, A_carga_dec, A_carga_op, A_reset, op_sel : out std_logic;
		pronto : out std_logic
	);
end bc_multiplicador;

architecture comportamento of bc_multiplicador is
	type tipo_estado is (Init, LoopCheck, AcumP, DecA, Fim);
	signal prox_estado, estado : tipo_estado := Init;
begin
	logica_proximo_estado : process(estado, inicio, B_eq_zero, A_eq_zero)
	begin
		case estado is
			when Init =>
				if inicio='1' then
					prox_estado <= LoopCheck;
				else
					prox_estado <= Init;
				end if;
			when LoopCheck =>
				if A_eq_zero='1' or B_eq_zero='1' then
					prox_estado <= Fim;
				else
					prox_estado <= AcumP;
				end if;
			when AcumP => 
				prox_estado <= DecA;
			when DecA =>
				prox_estado <= LoopCheck;
			when Fim =>
				prox_estado <= Init;
		end case;
	end process;
	
	registrador_estado : process(clk, reset)
	begin
		if reset = '1' then
			estado <= Init;
		elsif rising_edge(clk) then
			estado <= prox_estado;
		end if;
	end process;
	
	logica_saida : process(estado)
	begin
		P_carga <= '0'; P_reset <= '0';
		A_carga_dec <= '0'; A_carga_op <= '0'; A_reset <= '0';
		op_sel <= '0'; pronto <= '0';

		case estado is
			when Init =>
				P_reset <= '1';
				A_carga_op <= '1';
				pronto <= '0';
			when LoopCheck =>
			when AcumP =>
				P_carga <= '1';
				op_sel <= '1';
			when DecA =>
				A_carga_dec <= '1';
				op_sel <= '0';
			when Fim =>
				pronto <= '1';
		end case;
	end process;
end comportamento;