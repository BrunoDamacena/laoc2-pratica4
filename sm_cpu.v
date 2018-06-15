module sm_cpu(
	clock,
	write,
	miss,
	writeMiss,
	readMiss,
	writeBack,
	invalidate,
	currentState
);
	input clock;
	input write;
	input miss;
	output reg writeMiss, readMiss, writeBack, invalidate;
	
	output reg[1:0] currentState;
	
	initial begin
		currentState = 2'b00;
		writeMiss = 0;
		readMiss = 0;
		writeBack = 0;
		invalidate = 0;
	end
	
	always @(posedge clock)
	begin
		case(currentState)
			2'b00: // Invalid
			begin
				if (write)
				begin // CPU write
					writeMiss = 1;
					readMiss = 0;
					writeBack = 0;
					invalidate = 0;
					currentState = 2'b10; // Modified
				else // CPU read
					writeMiss = 0;
					readMiss = 1;
					writeBack = 0;
					invalidate = 0;
					currentState = 2'b01; // Shared
				end
			end
			2'b01: // Shared
			begin
				if (write)
				begin // CPU write
					if (miss)
					begin // CPU write miss
						writeMiss = 1;
						readMiss = 0;
						writeBack = 0;
						invalidate = 0;
						currentState = 2'b10; // Modified
					else // CPU write
						writeMiss = 0;
						readMiss = 0;
						writeBack = 0;
						invalidate = 1;
						currentState = 2'b10; // Modified
					end
				else // CPU read
					if (miss)
					begin // CPU read miss
						writeMiss = 0;
						readMiss = 1;
						writeBack = 0;
						invalidate = 0;
						currentState = 2'b01; // Shared
					else // CPU read hit
						writeMiss = 0;
						readMiss = 0;
						writeBack = 0;
						invalidate = 0;
						currentState = 2'b01; // Shared
					end
				end
			end
			2'b10: // Modified
			begin
				if (write)
				begin // CPU write
					if (miss)
					begin // CPU write miss
						writeMiss = 1;
						readMiss = 0;
						writeBack = 1;
						invalidate = 0;
						currentState = 2'b10; // Modified
					else // CPU write
						writeMiss = 0;
						readMiss = 0;
						writeBack = 0;
						invalidate = 0;
						currentState = 2'b10; // Modified
					end
				else // CPU read
					if (miss)
					begin // CPU read miss
						writeMiss = 0;
						readMiss = 1;
						writeBack = 1;
						invalidate = 0;
						currentState = 2'b01; // Shared
					else // CPU read hit
						writeMiss = 0;
						readMiss = 0;
						writeBack = 0;
						invalidate = 0;
						currentState = 2'b10; // Modified
					end
				end
			end
		endcase
	end
	
endmodule