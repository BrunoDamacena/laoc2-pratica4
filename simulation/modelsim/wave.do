onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bus/clock
add wave -noupdate /bus/execute_instruction_cpu1
add wave -noupdate /bus/execute_instruction_cpu2
add wave -noupdate /bus/instruction
add wave -noupdate /bus/address
add wave -noupdate /bus/data_in
add wave -noupdate /bus/data_out_cpu1
add wave -noupdate /bus/data_out_cpu2
add wave -noupdate /bus/done_cpu1
add wave -noupdate /bus/done_cpu2
add wave -noupdate /bus/state
add wave -noupdate /bus/bus_in_cpu1
add wave -noupdate /bus/bus_in_cpu2
add wave -noupdate /bus/bus_out_cpu1
add wave -noupdate /bus/bus_out_cpu2
add wave -noupdate /bus/cpu1/current_state_cb1
add wave -noupdate /bus/cpu1/write_cb1
add wave -noupdate /bus/cpu1/state_cb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {748 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 167
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {781 ps} {1049 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/bus/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/execute_instruction_cpu1 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/execute_instruction_cpu2 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/instruction 
wave create -driver freeze -pattern constant -value 110 -range 2 0 -starttime 0ps -endtime 1000ps sim:/bus/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1100 -range 3 0 -starttime 0ps -endtime 1000ps sim:/bus/data_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 1 -starttime 25ps -endtime 75ps Edit:/bus/execute_instruction_cpu1 
wave modify -driver freeze -pattern constant -value 1 -starttime 525ps -endtime 575ps Edit:/bus/execute_instruction_cpu2 
wave modify -driver freeze -pattern constant -value 1 -starttime 525ps -endtime 575ps Edit:/bus/instruction 
WaveCollapseAll -1
wave clipboard restore
