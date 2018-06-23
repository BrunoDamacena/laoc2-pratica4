onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory/clock
add wave -noupdate /memory/write
add wave -noupdate /memory/address
add wave -noupdate /memory/data_in
add wave -noupdate /memory/data_out
add wave -noupdate -expand /memory/memory_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {500 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/memory/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/memory/write 
wave create -driver freeze -pattern constant -value 000 -range 2 0 -starttime 0ps -endtime 1000ps sim:/memory/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ps -endtime 1000ps sim:/memory/data_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 100 -range 2 0 -starttime 0ps -endtime 250ps Edit:/memory/address 
wave modify -driver freeze -pattern constant -value 000 -range 2 0 -starttime 225ps -endtime 250ps Edit:/memory/address 
wave modify -driver freeze -pattern constant -value 1 -starttime 25ps -endtime 75ps Edit:/memory/write 
wave modify -driver freeze -pattern constant -value 0110 -range 3 0 -starttime 0ps -endtime 250ps Edit:/memory/data_in 
wave modify -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 125ps -endtime 250ps Edit:/memory/data_in 
WaveCollapseAll -1
wave clipboard restore
