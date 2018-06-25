module cpu(
			clock,
			instruction,
			address,
			data_in,
			readMiss,
			writeMiss,
			data_out
);
	input clock;
	input instruction;
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
	wire readMiss_sm1, readMiss_sm2;
	
	wire miss_sm1 = ~address[0] & state == 2'b00 & address != current_address_cb1;
	wire miss_sm2 = address[0] & state == 2'b00 & address != current_address_cb2;
	
	wire write_sm1 = ~address[0] & ~state[1] & ~state[0] & write;
	wire write_sm2 = address[0] & ~state[1] & ~state[0] & write;
	
	assign readMiss = readMiss_sm1 | readMiss_sm2;
	assign writeMiss = writeMiss_sm1 | writeMiss_sm2;
	
	initial begin
		data_out = 4'b0000;
		state = 2'b00;
	end
	
	sm_cpu sm1(clock,	write_sm1, miss_sm1,	writeMiss_sm1,	readMiss_sm1, writeBack_sm1, invalidate_sm1,	currentState_sm1);
	sm_cpu sm2(clock,	write_sm2, miss_sm2,	writeMiss_sm2,	readMiss_sm2, writeBack_sm2, invalidate_sm2,	currentState_sm2);
	
	cache_block cb1(clock, write & ~current_cb, state & ~{2{state}}, address & ~{3{address}}, data_in & ~{4{data_in}}, current_state_cb1, current_address_cb1, current_data_cb1);
	cache_block cb2(clock, write & current_cb, state & {2{state}}, adrress & {3{address}}, data_in & {4{data_in}}, current_state_cb2, current_address_cb2, current_data_cb2);
	
	always @(posedge clock)
	begin
	
		case(state)
			2'b00: // Verify state machine
			begin
				state = 2'b01;
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