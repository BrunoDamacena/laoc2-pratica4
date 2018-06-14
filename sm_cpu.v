module sm_cpu(
	clock,
	write,
	state,
	writeMiss,
	readMiss,
	writeBack,
	invalidate,
	currentState
);
	input clock;
	input write;
	input[1:0] state;
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
				case(state)
					2'b00: // Invalid -> Invalid
					begin
					end
					2'b01: // Invalid -> Shared
					begin
						// Place read miss on the bus
					end
					2'b10: // Invalid -> Modified
					begin
					end
				endcase
			end
			2'b01: // Shared
			begin
				case(state)
					2'b00: // Shared -> Invalid
					begin
					end
					2'b01: // Shared -> Shared
					begin
					end
					2'b10: // Shared -> Modified
					begin
					end
				endcase
			end
			2'b10: // Modified
			begin
				case(state)
					2'b00: // Modified -> Invalid
					begin
					end
					2'b01: // Modified -> Shared
					begin
					end
					2'b10: // Modified -> Modified
					begin
					end
				endcase
			end
		endcase
	end
	
endmodule