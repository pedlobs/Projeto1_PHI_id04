library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_display_duplo is
    Port (
        binary_input1 : in  STD_LOGIC_VECTOR(3 downto 0); -- entrada para display 1
        binary_input2 : in  STD_LOGIC_VECTOR(3 downto 0); -- entrada para display 2
        intercambia   : in  STD_LOGIC;                    -- 0 = normal, 1 = troca
        segments1     : out STD_LOGIC_VECTOR(6 downto 0); -- saída display 1
        segments2     : out STD_LOGIC_VECTOR(6 downto 0)  -- saída display 2
    );
end top_display_duplo;

architecture Structural of top_display_duplo is

    -- componente a ser instanciado ("molde"/função)
    component display_segments_seven
        Port (
            binary_input : in  STD_LOGIC_VECTOR(3 downto 0);
            segments     : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Sinais internos para rotear as entradas
    signal s_entrada_para_display1 : STD_LOGIC_VECTOR(3 downto 0);
    signal s_entrada_para_display2 : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Lógica para intercambiar as entradas com base no sinal 'intercambia'
    -- Se 'intercambia' for '0', a entrada 1 vai para o display 1.
    -- Se for '1', a entrada 2 vai para o display 1.
    s_entrada_para_display1 <= binary_input1 when intercambia = '0' else binary_input2;

    -- Se 'intercambia' for '0', a entrada 2 vai para o display 2.
    -- Se for '1', a entrada 1 vai para o display 2.
    s_entrada_para_display2 <= binary_input2 when intercambia = '0' else binary_input1;


    -- Instância 1 do conversor (Display 1)
    -- Agora usa o sinal interno como entrada
    U1: display_segments_seven
        port map (
            binary_input => s_entrada_para_display1,
            segments     => segments1
        );

    -- Instância 2 do conversor (Display 2)
    -- Agora usa o sinal interno como entrada
    U2: display_segments_seven
        port map (
            binary_input => s_entrada_para_display2,
            segments     => segments2
        );

end Structural;