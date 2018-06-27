view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/cpu/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/cpu/instruction 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/cpu/execute_instruction 
wave create -driver freeze -pattern constant -value 100 -range 2 0 -starttime 0ps -endtime 1000ps sim:/cpu/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 1010 -range 3 0 -starttime 0ps -endtime 1000ps sim:/cpu/data_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 1 -starttime 25ps -endtime 75ps Edit:/cpu/execute_instruction 
wave modify -driver freeze -pattern constant -value 000 -range 2 0 -starttime 175ps -endtime 225ps Edit:/cpu/address 
wave modify -driver freeze -pattern constant -value 000 -range 2 0 -starttime 225ps -endtime 275ps Edit:/cpu/address 
wave modify -driver freeze -pattern constant -value 1 -starttime 225ps -endtime 275ps Edit:/cpu/instruction 
wave modify -driver freeze -pattern constant -value 000 -range 2 0 -starttime 0ps -endtime 275ps Edit:/cpu/address 
wave modify -driver freeze -pattern constant -value St1 -starttime 225ps -endtime 275ps Edit:/cpu/execute_instruction 
wave modify -driver freeze -pattern constant -value St1 -starttime 525ps -endtime 575ps Edit:/cpu/execute_instruction 
wave modify -driver freeze -pattern constant -value 000 -range 2 0 -starttime 0ps -endtime 775ps Edit:/cpu/address 
wave modify -driver freeze -pattern constant -value 110 -range 2 0 -starttime 0ps -endtime 775ps Edit:/cpu/address 
WaveCollapseAll -1
wave clipboard restore
