transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {F:/Biblioteca/Documentos/MultiplicadorILAN/bo_multiplicador.vhd}
vcom -93 -work work {F:/Biblioteca/Documentos/MultiplicadorILAN/bc_multiplicador.vhd}
vcom -93 -work work {F:/Biblioteca/Documentos/MultiplicadorILAN/phi111_multiplicador.vhd}

