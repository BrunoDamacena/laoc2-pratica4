module cpu(
			clock,
			instruction,
			state,
			address,
			data_in,
			current_state,
			current_address,
			current_data
);
	input clock;
	input instruction;
	input [1:0] state;
	input [2:0] address;
	input [3:0] data_in;
	output reg [1:0] current_state;
	output reg [2:0] current_address;
	output reg [3:0] current_data;
	
	reg current_cb;
	
	wire [1:0] current_state_cb1;
	wire [2:0] current_address_cb1;
	wire [3:0] current_data_cb1;
	
	wire [1:0] current_state_cb2;
	wire [2:0] current_address_cb2;
	wire [3:0] current_data_cb2;
	
	wire write = instruction;
	
	initial begin
		current_state = 2'b00; // Invalid
		current_address = address;
		current_data = 4'b0000;
		current_cb = 0;
	end
	
	cache_block cb1(clock, write & ~current_cb, state & ~{2{state}}, address & ~{3{address}}, data_in & ~{4{data_in}}, current_state_cb1, current_address_cb1, current_data_cb1);
	cache_block cb2(clock, write & current_cb, state & {2{state}}, adrress & {3{address}}, data_in & {4{data_in}}, current_state_cb2, current_address_cb2, current_data_cb2);
	
	always @(posedge clock)
	begin
		
		// Direct Mapping
		if(address[0])
		begin
			current_cb = 0;
			current_state = current_state_cb1;
			current_address = current_address_cb1;
			current_data = current_data_cb1;
		end
		else
		begin
			current_cb = 1;
			current_state = current_state_cb2;
			current_address = current_address_cb2;
			current_data = current_data_cb2;
		end
		
		if(write)
		begin
			current_state = state;
			current_address = address;
			current_data = data_in;
		end
	end

endmodule