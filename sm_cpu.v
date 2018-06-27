module sm_cpu(
	clock,
	write,
	miss,
	state,
	writeMiss,
	readMiss,
	writeBack,
	invalidate,
	newState
);
	input clock;
	input write;
	input miss;
	input [1:0] state;
	output reg writeMiss, readMiss, writeBack, invalidate;
	
	output reg[1:0] newState;
	
	initial begin
		newState = 2'b01;
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
		case(state)
			2'b00: // Invalid
			begin
				if (write)
				begin // CPU write
					writeMiss = 1;
					newState = 2'b10; // Modified
				end
				else // CPU read
				begin
					readMiss = 1;
					newState = 2'b01; // Shared
				end
			end
			2'b01: // Shared
			begin
				if (write)
				begin // CPU write
					if (miss)
					begin // CPU write miss
						writeMiss = 1;
						newState = 2'b10; // Modified
					end
					else // CPU write
					begin
						invalidate = 1;
						newState = 2'b10; // Modified
					end
				end
				else // CPU read
				begin
					if (miss)
					begin // CPU read miss
						readMiss = 1;
						newState = 2'b01; // Shared
					end
					else // CPU read hit
					begin
						newState = 2'b01; // Shared
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
						newState = 2'b10; // Modified
					end
					else // CPU write
					begin
						newState = 2'b10; // Modified
					end
				end
				else // CPU read
				begin
					if (miss)
					begin // CPU read miss
						readMiss = 1;
						writeBack = 1;
						newState = 2'b01; // Shared
					end
					else // CPU read hit
					begin
						newState = 2'b10; // Modified
					end
				end
			end
		endcase
	end
	
endmodule