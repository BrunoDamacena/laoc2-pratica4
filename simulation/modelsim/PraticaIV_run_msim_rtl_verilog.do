transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Gabriel/Documents/laoc2-pratica4 {C:/Users/Gabriel/Documents/laoc2-pratica4/PraticaIV.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gabriel/Documents/laoc2-pratica4 {C:/Users/Gabriel/Documents/laoc2-pratica4/sm_cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gabriel/Documents/laoc2-pratica4 {C:/Users/Gabriel/Documents/laoc2-pratica4/memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Gabriel/Documents/laoc2-pratica4 {C:/Users/Gabriel/Documents/laoc2-pratica4/sm_bus.v}

