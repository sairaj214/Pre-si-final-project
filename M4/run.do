##run with command :::::: do run.do
vlib work
vlog FIFO_DESIGN.sv
vlog package.sv
vlog top.sv
vlog test1.sv
vlog Driver.sv
vlog environment.sv
vlog test2.sv
vlog interface.sv
vlog test3.sv
vlog Read_agent.sv
vlog scoreboard.sv
vlog seq_item.sv
vlog seq_base.sv
vlog seq_full.sv
vlog seq_random.sv
vlog sequencer.sv
vlog write_agent.sv
vlog Coverage.sv
vlog Read_monitor.sv
vlog write_monitor.sv

# Choose test
vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll basetest.ucdb; run -all"
# vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll fulltest.ucdb; run -all"
# vsim -coverage -vopt work.tb_top -c -do "coverage save -onexit -directive -codeAll randomtest.ucdb; run -all"

# if you need coverage report after running all 3 tests (ensure ucdb files are created)

# vcover merge output basetest.ucdb fulltest.ucdb randomtest.ucdb
# vcover report -html output

