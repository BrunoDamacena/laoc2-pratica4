module cpu(
			bus_in,
			clock,
			execute_instruction,
			instruction,
			address,
			data_in,
			data_out,
			done,
			bus_out
);
	input [12:0] bus_in; //  
	input clock;
	input instruction;
	input execute_instruction;
	input [2:0] address;
	input [3:0] data_in;
	output reg [3:0] data_out;
	output reg done;
	output reg [12:0] bus_out;
	
	// Regs to save instruction in execution
	reg instruction_reg;
	reg [2:0] address_reg;
	reg [3:0] data_in_reg;
	
	reg message_sent;
	
	wire readMiss;
	wire writeMiss;
	wire invalidate;
	
	reg write_cb1;
	reg write_cb2;
	reg [1:0] state_cb;
	reg [2:0] address_cb;
	reg [3:0] data_cb;
	
	reg [1:0] state; // 00 is Idle (waiting for instruction); 01 is execute CB State Machine changes
	
	wire [1:0] current_state_cb1;
	wire [2:0] current_address_cb1;
	wire [3:0] current_data_cb1;
	
	wire [1:0] current_state_cb2;
	wire [2:0] current_address_cb2;
	wire [3:0] current_data_cb2;
	
	wire [1:0] current_state_sm_cb1;
	wire [1:0] current_state_sm_cb2;
	
	wire write = instruction;
	wire readMiss_sm_cb1, readMiss_sm_cb2;
	wire writeMiss_sm_cb1, writeMiss_sm_cb2;
	wire invalidate_sm_cb1, invalidate_sm_cb2;
	
	assign readMiss = readMiss_sm_cb1 | readMiss_sm_cb2;
	assign writeMiss = writeMiss_sm_cb1 | writeMiss_sm_cb2;
	assign invalidate = invalidate_sm_cb1 | invalidate_sm_cb2;
	
	initial begin
		data_out = 4'b0000;
		bus_out = 10'b0000000000;
		state = 2'b00;
		write_cb1 = 0;
		write_cb2 = 0;
		done = 1;
		message_sent = 0;
	end
	
	// The Cache Block state machine is activated with the following conditions:
	// - Clock is high (clock)
	// - The address is mapped to this cache block (~address[0] or adddress[0])
	// - Execute instruction is enabled (which means this is the current CPU)
	// - It's the FIRST state of the CPU (state == 2'b01)
	
	wire activate_sm_cb1 = clock & ~address_reg[0] & state == 2'b01;
	wire activate_sm_cb2 = clock & address_reg[0] & state == 2'b01;
	wire miss_sm_cb1 = address_reg != current_address_cb1;
	wire miss_sm_cb2 = address_reg != current_address_cb2;
	
	wire miss = (miss_sm_cb1 & ~address_reg[0]) | (miss_sm_cb2 & address_reg[0]);
	
	sm_cpu sm_cb1(activate_sm_cb1, instruction, miss_sm_cb1, current_state_cb1, writeMiss_sm_cb1, readMiss_sm_cb1, writeBack_sm_cb1, invalidate_sm_cb1, current_state_sm_cb1);
	sm_cpu sm_cb2(activate_sm_cb2, instruction, miss_sm_cb2, current_state_cb2, writeMiss_sm_cb2, readMiss_sm_cb2, writeBack_sm_cb2, invalidate_sm_cb2, current_state_sm_cb2);
		
	wire activate_cb_1 = clock & ~address_reg[0] & state == 2'b10;
	wire activate_cb_2 = clock & address_reg[0] & state == 2'b10; 
	cache_block cb1(activate_cb_1, write_cb1, state_cb, address_cb, data_cb, current_state_cb1, current_address_cb1, current_data_cb1);
	cache_block cb2(activate_cb_2, write_cb2, state_cb, address_cb, data_cb, current_state_cb2, current_address_cb2, current_data_cb2);
	
	wire state_bus_cb1;
	wire state_bus_cb2;
	wire write_back_bus_cb1;
	wire write_back_bus_cb2;
	wire abort_bus_cb1;
	wire abort_bus_cb2;
	sm_bus sm_bus1(clock, current_state_cb1, bus_in[8], bus_in[9], bus_in[7], write_back_bus_cb1, abort_bus_cb1, state_bus_cb1);
	sm_bus sm_bus2(clock, current_state_cb2, bus_in[8], bus_in[9], bus_in[7], write_back_bus_cb2, abort_bus_cb2, state_bus_cb2);
	
	always @(posedge clock)
	begin
		write_cb1 = 0;
		write_cb2 = 0;
	
		case(state)
			2'b00: // Verify state machine
			begin
				bus_out = 10'b0000000000;
				if (execute_instruction)
				begin
					instruction_reg = instruction;
					address_reg = address;
					data_in_reg = data_in;
					state = 2'b01;
					done = 0;
					message_sent = 0;
				end
				if (bus_in[9] | bus_in[8] | bus_in[7])
				begin
					bus_out = 10'b0000000000;
					if (bus_in[6:4] == current_address_cb1)
					begin
						bus_out[12] = write_back_bus_cb1;
						bus_out[11] = abort_bus_cb1;
						if(bus_out[12] | bus_out[11])
						begin
							bus_out[6:4] = current_address_cb1;
							bus_out[3:0] = current_data_cb1;
						end
						if(current_state_cb1 != state_bus_cb1)
						begin
							write_cb1 = 1;
							state_cb = state_bus_cb1;
							address_cb = current_address_cb1;
							data_cb = current_data_cb1;
							state = 2'b10;
						end
					end
					else
					if (bus_in[6:4] == current_address_cb2)
					begin
						bus_out[12] = write_back_bus_cb2;
						bus_out[11] = abort_bus_cb2;
						if(bus_out[12] | bus_out[11])
						begin
							bus_out[6:4] = current_address_cb2;
							bus_out[3:0] = current_data_cb2;
						end		
						if(current_state_cb2 != state_bus_cb2)
						begin
							write_cb2 = 1;
							state_cb = state_bus_cb2;
							address_cb = current_address_cb2;
							data_cb = current_data_cb2;
							state = 2'b10;
						end				
					end
					else
					begin						
						bus_out = 10'b0010000000;
					end
				end
			end
			2'b01:
			begin				
				if(readMiss | writeMiss | invalidate) // if any message must be sent in the bus, add one cycle to send it
				begin
					bus_out[10] = 1;
					bus_out[9] = readMiss;
					bus_out[8] = writeMiss;
					bus_out[7] = invalidate;
					if(invalidate)
					begin
						bus_out[6:4] = (current_address_cb1 & ~{3{address_reg[0]}}) | (current_address_cb2 & {3{address_reg[0]}});
					end
					else
					begin
						bus_out[6:4] = address_reg;
					end
					bus_out[3:0] = 4'b0000;
					state = 2'b11;
				end
				else
				if(~instruction_reg) // read hit - 1 cycle and it's done
				begin
					data_out = (current_data_cb1 & ~{4{address_reg[0]}}) | (current_data_cb2 & {4{address_reg[0]}});
					done = 1;
					state = 2'b00;	
				end
				else
				if(instruction_reg) // write hit
				begin
					// write on supposed cache
					write_cb1 = ~address_reg[0];
					write_cb2 = address_reg[0];
					state_cb = (~{2{address_reg[0]}} & current_state_sm_cb1) | ({2{address_reg[0]}} & current_state_sm_cb2);
					address_cb = address_reg;
					data_cb = data_in_reg;
					state = 2'b10;
				end
			end
			2'b10:
			begin
				// Write hit - 2 cycles and done
				data_out = (current_data_cb1 & ~{4{address_reg[0]}}) | (current_data_cb2 & {4{address_reg[0]}});
				done = 1;
				state = 2'b00;
			end
			2'b11:
			begin
				bus_out = 10'b0000000000;
				if(bus_in[10] | instruction_reg) 
				begin
					write_cb1 = ~address_reg[0];
					write_cb2 = address_reg[0];			
					state_cb = (~{2{address_reg[0]}} & current_state_sm_cb1) | ({2{address_reg[0]}} & current_state_sm_cb2);
					if(instruction_reg)
					begin
						data_cb = data_in_reg; // Write instruction - data was in the instruction
					end
					else
					begin
						data_cb = bus_in[3:0]; // Read instruction - data comes from the bus
					end
					address_cb = address_reg;
					state = 2'b10;
				end
			end
		endcase
	end

endmodule