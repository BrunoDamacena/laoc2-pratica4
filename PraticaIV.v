module PraticaIV(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, LEDG);
	input [17:0] SW;
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;
	output [0:6] HEX4;
	output [0:6] HEX5;
	output [0:6] HEX6;
	output [0:6] HEX7;
	output [17:0] LEDR;
	output [7:4] LEDG;
	
	// Wires - In CPU
	wire clock_cpu;
	wire write_cpu;
	wire miss_cpu;
	
	// Wires - In Bus
	wire clock_bus;
	wire writeMiss_bus;
	wire readMiss_bus;
	wire invalidate_bus;
	
	// Wires - Out CPU
	wire writeMiss_cpu;
	wire readMiss_cpu;
	wire writeBack_cpu;
	wire invalidate_cpu;
	wire [1:0] currentState_cpu;
	
	// Wires - Out Bus
	wire writeBack_bus;
	wire abortMemoryAccess_bus;
	wire [1:0] currentState_bus;
	
	// Wires - displays
	wire [0:6] display_currentState_cpu;
	wire [0:6] display_currentState_bus;
	
	// Assigns - CPU to the Cyclone II Board	
	assign clock_cpu = SW[17];
	assign write_cpu = SW[16];
	assign miss_cpu = SW[15];
	
	assign LEDR[17] = write_cpu;
	assign LEDR[16] = writeMiss_cpu;
	assign LEDR[15] = readMiss_cpu;
	assign LEDR[14] = writeBack_cpu;
	assign LEDR[13] = invalidate_cpu;
	
	assign LEDG[7:6] = currentState_cpu[1:0];
	assign LEDG[5:4] = currentState_bus[1:0];

	// Assigns - Bus to the Cyclone II Board
	assign clock_bus = SW[3];
	assign writeMiss_bus = SW[2];
	assign readMiss_bus = SW[1];
	assign invalidate_bus = SW[0];
	
	assign LEDR[4] = writeMiss_bus;
	assign LEDR[3] = readMiss_bus;
	assign LEDR[2] = invalidate_bus;
	assign LEDR[1] = writeBack_bus;
	assign LEDR[0] = abortMemoryAccess_bus;
	
	// Assigns - displays
	assign display_currentState_cpu = (7'b1001111 & ~{7{currentState_cpu[1]}} & ~{7{currentState_cpu[0]}}) // Invalid - I
											  | (7'b0100100 & ~{7{currentState_cpu[1]}} & {7{currentState_cpu[0]}}) // Shared - S
											  | (7'b0110000 & {7{currentState_cpu[1]}} & ~{7{currentState_cpu[0]}}); // Modified - 0
											  
   assign display_currentState_bus = (7'b1001111 & ~{7{currentState_bus[1]}} & ~{7{currentState_bus[0]}}) // Invalid - I
											  | (7'b0100100 & ~{7{currentState_bus[1]}} & {7{currentState_bus[0]}}) // Shared - S
											  | (7'b0110000 & {7{currentState_bus[1]}} & ~{7{currentState_bus[0]}}); // Modified - 0
	
	
	
	assign HEX0 = display_currentState_bus;
	assign HEX7 = display_currentState_cpu;
	
	// Turn idle displays off
	assign HEX1 = 7'b1110111;
	assign HEX2 = 7'b1110111;
	assign HEX3 = 7'b1110111;
	assign HEX4 = 7'b1110111;
	assign HEX5 = 7'b1110111;
	assign HEX6 = 7'b1110111;
	
	sm_cpu sm_cpu(clock_cpu, write_cpu, miss_cpu, writeMiss_cpu, readMiss_cpu, writeBack_cpu, invalidate_cpu, currentState_cpu);
	sm_bus sm_bus(clock_bus, writeMiss_bus, readMiss_bus, invalidate_bus, writeBack_bus, abortMemoryAccess_bus, currentState_bus);
	
endmodule