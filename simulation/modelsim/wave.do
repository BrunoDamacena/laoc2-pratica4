view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/bus/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/execute_instruction_cpu1 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/execute_instruction_cpu2 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/bus/instruction 
wave create -driver freeze -pattern constant -value 000 -range 2 0 -starttime 0ps -endtime 1000ps sim:/bus/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ps -endtime 1000ps sim:/bus/data_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 1 -starttime 25ps -endtime 75ps Edit:/bus/execute_instruction_cpu1 
wave modify -driver freeze -pattern constant -value 1 -starttime 25ps -endtime 75ps Edit:/bus/instruction 
wave modify -driver freeze -pattern constant -value 1100 -range 3 0 -starttime 0ps -endtime 1000ps Edit:/bus/data_in 
wave modify -driver freeze -pattern constant -value 1 -starttime 425ps -endtime 475ps Edit:/bus/execute_instruction_cpu2 
WaveCollapseAll -1
wave clipboard restore
