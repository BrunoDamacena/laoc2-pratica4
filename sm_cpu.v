module sm_cpu(
	state,
	writeMiss,
	readMiss,
	writeBack,
	invalidate
);

	input[1:0] state;
	output reg writeMiss, readMiss, writeBack, invalidate;
	
	
end sm_cpu