view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/cache_block/clock 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/cache_block/write 
wave create -driver freeze -pattern constant -value 00 -range 1 0 -starttime 0ps -endtime 1000ps sim:/cache_block/state 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 000 -range 2 0 -starttime 0ps -endtime 1000ps sim:/cache_block/address 
WaveExpandAll -1
wave create -driver freeze -pattern constant -value 0000 -range 3 0 -starttime 0ps -endtime 1000ps sim:/cache_block/data_in 
WaveExpandAll -1
wave modify -driver freeze -pattern constant -value 1 -starttime 125ps -endtime 175ps Edit:/cache_block/write 
wave modify -driver freeze -pattern constant -value 01 -range 1 0 -starttime 125ps -endtime 150ps Edit:/cache_block/state 
wave modify -driver freeze -pattern constant -value 01 -range 1 0 -starttime 125ps -endtime 175ps Edit:/cache_block/state 
wave modify -driver freeze -pattern constant -value 110 -range 2 0 -starttime 125ps -endtime 175ps Edit:/cache_block/address 
wave modify -driver freeze -pattern constant -value 1000 -range 3 0 -starttime 125ps -endtime 175ps Edit:/cache_block/data_in 
wave modify -driver freeze -pattern constant -value 10 -range 1 0 -starttime 325ps -endtime 375ps Edit:/cache_block/state 
wave modify -driver freeze -pattern constant -value 1 -starttime 325ps -endtime 375ps Edit:/cache_block/write 
WaveCollapseAll -1
wave clipboard restore
