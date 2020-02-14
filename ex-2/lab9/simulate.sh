rm -rf work
vlib work
vlog +cover=bcefsx -sv test-top.sv top.sv ex2-1.v top-property.sv
vcom alu.vhd 
vsim -c -coverage test_top -do "run 1000ns; coverage report -memory -cvg -details -file coverage_rep.txt;exit"
