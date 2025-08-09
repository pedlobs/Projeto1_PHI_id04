library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity bo_multiplicador is
	port(
		clk, reset : in  std_logic;
		A, B : in std_logic_vector(7 downto 0);
		B_eq_zero, A_eq_zero, A_eq_um : out std_logic;
		P_carga, P_reset, A_carga_dec, A_carga_op, A_reset, op_sel : in std_logic;
		P_out : out std_logic_vector(7 downto 0)
	);
end bo_multiplicador;

architecture comportamento of bo_multiplicador is
	signal reg_p, reg_a, somador_out, somador_op_a, somador_op_b : std_logic_vector(7 downto 0);
begin
	registradores : process(clk, reset)
	begin
		if reset='1' then
			reg_p <= (others => '0');
			reg_a <= (others => '0');
		elsif rising_edge(clk) then
			if P_carga = '1' then
				reg_p <= somador_out;
			elsif P_reset = '1' then
				reg_p <= (others => '0');
			end if;
			
			if A_carga_op = '1' then
				reg_a <= A;
			elsif A_carga_dec = '1' then
				reg_a <= somador_out;
			elsif A_reset = '1' then
				reg_a <= (others => '0');
			end if;
		end if;
	end process;
	
	multiplexador : process(op_sel, reg_p, reg_a, B)
	begin
		if op_sel = '1' then
			somador_op_a <= reg_p;
			somador_op_b <= B;
		else
			somador_op_a <= reg_a;
			somador_op_b <= std_logic_vector(to_signed(-1, 8));
		end if;
	end process;
	
	somador_out <= std_logic_vector(signed(somador_op_a) + signed(somador_op_b));
	
	B_eq_zero <= '1' when to_integer(signed(B)) = 0 else '0';
	A_eq_um   <= '1' when to_integer(signed(reg_a)) = 1 else '0';
	A_eq_zero <= '1' when to_integer(signed(reg_a)) = 0 else '0';
	
	P_out <= reg_p;
	
end comportamento;