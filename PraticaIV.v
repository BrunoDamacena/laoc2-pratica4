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
	
	// Wires - Bus
	wire clock;
	wire execute_instruction_cpu1;
	wire execute_instruction_cpu2;
	wire instruction;
	wire [2:0] address;
	wire [3:0] data_in;
	wire [3:0] data_out_cpu1;
	wire [3:0] data_out_cpu2;
	wire done_cpu1;
	wire done_cpu2;
	
	// Wires - displays
	wire [0:6] display_data_out_cpu1;
	wire [0:6] display_data_out_cpu2;
	
	// Assigns - Bus to the Cyclone II Board	
	assign clock = SW[17];
	assign execute_instruction_cpu1 = SW[16];
	assign execute_instruction_cpu2 = SW[15];
	assign instruction = SW[14];
	assign address = SW[13:10];
	assign data_in = SW[9:6];
	assign execute_ = SW[16];
	assign miss_cpu = SW[15];
	
	assign LEDR[17] = done_cpu1;
	assign LEDR[16] = done_cpu2;

	
	// Assigns - displays
	bcd_7seg display_data1(data_out_cpu1, display_data_out_cpu1);
	bcd_7seg display_data2(data_out_cpu2, display_data_out_cpu2);	
	
	assign HEX0 = execute_instruction_cpu1;
	assign HEX7 = execute_instruction_cpu2;
	
	// Turn idle displays off
	assign HEX1 = 7'b1110111;
	assign HEX2 = 7'b1110111;
	assign HEX3 = 7'b1110111;
	assign HEX4 = 7'b1110111;
	assign HEX5 = 7'b1110111;
	assign HEX6 = 7'b1110111;
	
	bus bus(clock, execute_instruction_cpu1, execute_instruction_cpu2, instruction, address, data_in, data_out_cpu1, data_out_cpu2, done_cpu1, done_cpu2);
	
endmodule