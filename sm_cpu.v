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
		writeMiss = 0;
		readMiss = 0;
		writeBack = 0;
		invalidate = 0;
		case(currentState)
			2'b00: // Invalid
			begin
				if (write)
				begin // CPU write
					writeMiss = 1;
					currentState = 2'b10; // Modified
				end
				else // CPU read
				begin
					readMiss = 1;
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
						currentState = 2'b10; // Modified
					end
					else // CPU write
					begin
						invalidate = 1;
						currentState = 2'b10; // Modified
					end
				end
				else // CPU read
				begin
					if (miss)
					begin // CPU read miss
						readMiss = 1;
						currentState = 2'b01; // Shared
					end
					else // CPU read hit
					begin
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
						writeBack = 1;
						currentState = 2'b10; // Modified
					end
					else // CPU write
					begin
						currentState = 2'b10; // Modified
					end
				end
				else // CPU read
				begin
					if (miss)
					begin // CPU read miss
						readMiss = 1;
						writeBack = 1;
						currentState = 2'b01; // Shared
					end
					else // CPU read hit
					begin
						currentState = 2'b10; // Modified
					end
				end
			end
		endcase
	end
	
endmodule