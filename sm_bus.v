module sm_bus(
	clock,
	writeMiss,
	readMiss,
	invalidate,
	writeBack,
    abortMemoryAccess,
	currentState
);
    input clock;
    input writeMiss;
    input readMiss;
    input invalidate;

    output reg writeBack;
    output reg abortMemoryAccess;

    output reg[1:0] currentState;
	
	initial begin
		currentState = 2'b10;
		writeBack = 0;
		abortMemoryAccess = 0;
	end

    always @(posedge clock)
	begin
        writeBack = 0;
        abortMemoryAccess = 0;
		case(currentState)
			2'b00: // Invalid
			begin
                // Nothing to do here :)
			end
			2'b01: // Shared
			begin   
				if (writeMiss || invalidate)
                begin
                    currentState = 2'b00; // Invalid   
                end
                if (readMiss)
                begin
                    currentState = 2'b01; // Shared
                end
			end
			2'b10: // Modified
			begin     
				if (writeMiss)
                begin
                    currentState = 2'b00; // Invalid
                    writeBack = 1;
                    abortMemoryAccess = 1;
                end

                if(readMiss)
                begin
                    currentState = 2'b01; // Shared
                    writeBack = 1;
                    abortMemoryAccess = 1;
                end
			end
		endcase
	end
endmodule