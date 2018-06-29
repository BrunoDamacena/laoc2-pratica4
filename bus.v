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
	output [3:0] data_out_cpu1;
	output [3:0] data_out_cpu2;
	output done_cpu1;
	output done_cpu2;
	
	reg [1:0] state;
	
	reg [12:0] bus_in_cpu1;
	reg [12:0] bus_in_cpu2;
	
	reg memory_write;
	reg [2:0] memory_address;
	reg [3:0] memory_data_in;
	wire [3:0] memory_data_out;
	
	wire [12:0] bus_out_cpu1;
	wire [12:0] bus_out_cpu2;
	
	cpu cpu1(bus_in_cpu1, clock, execute_instruction_cpu1, instruction, address, data_in, data_out_cpu1, done_cpu1, bus_out_cpu1);
	cpu cpu2(bus_in_cpu2, clock, execute_instruction_cpu2, instruction, address, data_in, data_out_cpu2, done_cpu2, bus_out_cpu2);
	
	memory memory(clock, memory_write, memory_address, memory_data_in, memory_data_out);
	
	initial begin
		state = 2'b00;
		bus_in_cpu1 = 10'b0000000000;
		bus_in_cpu2 = 10'b0000000000;
		memory_write = 0;
		memory_address = 3'b000;
		memory_data_in = 4'b0000;	
	end
		
	always @(posedge clock)
	begin
		memory_write = 0;	
		
		if(bus_out_cpu1[10])
		begin
			bus_in_cpu2 = bus_out_cpu1;
		end
		
		if(bus_out_cpu2[10])
		begin
			bus_in_cpu1 = bus_out_cpu2;
		end
		
		case(state)
			2'b00:
			begin
				if(bus_out_cpu1[12] | bus_out_cpu1[9]) // write-back/read-miss
				begin
					memory_write =  bus_out_cpu1[12]; // update memory in case of write-back
					memory_address = bus_out_cpu1[6:4];
					memory_data_in =  bus_out_cpu1[3:0];
					state = 2'b01;
				end
				else
				if(bus_out_cpu2[12] | bus_out_cpu2[9]) // read/write miss cpu 2
				begin
					memory_write = bus_out_cpu2[12]; // update memory in case of write-back
					memory_address = bus_out_cpu2[6:4];
					memory_data_in = bus_out_cpu2[3:0];
					state = 2'b10;				
				end
			end
			2'b01: // read miss cpu 1 - cycle 2
			begin
				bus_in_cpu1[12:7] = 4'b001000;
				bus_in_cpu1[6:4] = memory_address;
				if(bus_out_cpu2[11] & bus_out_cpu2[6:4] == memory_address) // abort memory access: solved from cache
				begin
					bus_in_cpu1[3:0] = bus_out_cpu2[3:0];
				end
				else // solved from memory				
				begin
					bus_in_cpu1[3:0] = memory_data_out;
				end
				state = 2'b11;
			end
			
			2'b10: // read miss cpu 2 - cycle 2
			begin
				bus_in_cpu2[12:7] = 4'b001000;
				bus_in_cpu2[6:4] = memory_address;
				if(bus_out_cpu1[11] & bus_out_cpu1[6:4] == memory_address) // abort memory access: solved from cache
				begin
					bus_in_cpu2[3:0] = bus_out_cpu1[3:0];
				end
				else // solved from memory				
				begin
					bus_in_cpu2[3:0] = memory_data_out;
				end
				state = 2'b11;
			end
			2'b11:
			begin
				state = 2'b00;
			end
		endcase
		
	end
endmodule