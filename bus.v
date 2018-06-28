module bus(clock,
			execute_instruction_cpu1,
			execute_instruction_cpu2,			
			instruction,
			address,
			data_in,
			data_out_cpu1,
			data_out_cpu2,
			done_cpu1,
			done_cpu2);
	input clock;
	input execute_instruction_cpu1;
	input execute_instruction_cpu2;
	input instruction;
	input [2:0] address;
	input [3:0] data_in;
	output reg [3:0] data_out_cpu1;
	output reg [3:0] data_out_cpu2;
	output done_cpu1;
	output done_cpu2;
	
	reg [10:0] bus_in_cpu1;
	reg [10:0] bus_in_cpu2;
	
	wire [9:0] bus_out_cpu1;
	wire [9:0] bus_out_cpu2;
	
	cpu cpu1(bus_in_cpu1, clock, execute_instruction_cpu1, instruction, address, data_in, data_out_cpu1, done_cpu1, bus_out_cpu1);
	cpu cpu2(bus_in_cpu2, clock, execute_instruction_cpu2, instruction, address, data_in, data_out_cpu2, done_cpu2, bus_out_cpu2);
endmodule