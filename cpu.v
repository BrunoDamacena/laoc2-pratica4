module cpu(
			clock,
			execute_instruction,
			instruction,
			address,
			data_in,
			readMiss,
			writeMiss,
			data_out
);
	input clock;
	input instruction;
	input execute_instruction;
	input [2:0] address;
	input [3:0] data_in;
	output readMiss;
	output writeMiss;
	output reg [3:0] data_out;
	
	reg current_cb;
	reg [1:0] state;
	
	wire [1:0] current_state_cb1;
	wire [2:0] current_address_cb1;
	wire [3:0] current_data_cb1;
	
	wire [1:0] current_state_cb2;
	wire [2:0] current_address_cb2;
	wire [3:0] current_data_cb2;
	
	wire write = instruction;
	wire readMiss_sm_cb1, readMiss_sm_cb2;
	wire writeMiss_sm_cb1, writeMiss_sm_cb2;
	wire invalidate_sm_cb1, invalidate_sm_cb2;
	
	assign readMiss = readMiss_sm_cb1 | readMiss_sm_cb2;
	assign writeMiss = writeMiss_sm_cb1 | writeMiss_sm_cb2;
	assign invalidate = invalidate_sm_cb1 | invalidate_sm_cb2;
	
	initial begin
		data_out = 4'b0000;
		state = 2'b00;
	end
	
	// The Cache Block state machine is activated with the following conditions:
	// - Clock is high (clock)
	// - The address is mapped to this cache block (~address[0] or adddress[0])
	// - Execute instruction is enabled (which means this is the current CPU)
	// - It's the FIRST state of the CPU (state == 2'b00)
	
	wire activate_sm_cb1 = clock & ~address[0] & execute_instruction & state == 2'b00;
	wire miss_sm_cb1 = address != current_address_cb1;
	wire miss_sm_cb2 = address != current_address_cb2;
	
	wire miss = (address != current_address_cb1 & ~address[0]) | (address != current_address_cb1 & address[0])
	
	sm_cpu sm_cb1(activate_sm_cb1, instruction, miss_sm_cb1, current_state_cb1, writeMiss_sm_cb1, readMiss_sm_cb1, writeBack_sm_cb1, invalidate_sm_cb1, currentState_sm_cb1);
	
	wire activate_sm_cb2 = clock & address[0] & execute_instruction & state == 2'b00;
	
	sm_cpu sm_cb2(activate_sm_cb2, instruction, miss_sm_cb2, current_state_cb2, writeMiss_sm_cb2, readMiss_sm_cb2, writeBack_sm_cb2, invalidate_sm_cb2, currentState_sm2);
		
	cache_block cb1(clock, write & ~current_cb, state & ~{2{state}}, address & ~{3{address}}, data_in & ~{4{data_in}}, current_state_cb1, current_address_cb1, current_data_cb1);
	cache_block cb2(clock, write & current_cb, state & {2{state}}, adrress & {3{address}}, data_in & {4{data_in}}, current_state_cb2, current_address_cb2, current_data_cb2);
	
	always @(posedge clock)
	begin
	
		case(state)
			2'b00: // Verify state machine
			begin
				if (execute_instruction)
				begin
					state = 2'b01;
				end
			end
			2'b01:
			begin
				state = 2'b00;
			end
		endcase
		
		// Direct Mapping
		if(address[0])
		begin
			current_cb = 0;
		end
		else
		begin
			current_cb = 1;
		end
		
		if(write)
		begin
		end
	end

endmodule