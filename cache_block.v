module cache_block(
			clock,
			write,
			state,
			address,
			data_in,
			current_state,
			current_address,
			current_data
);
	input clock;
	input write;
	input [1:0] state;
	input [2:0] address;
	input [3:0] data_in;
	output reg [1:0] current_state;
	output reg [2:0] current_address;
	output reg [3:0] current_data;
	
	initial begin
		current_state = 2'b00; // Invalid
		current_address = 3'b000;
		current_data = 4'b0000;
	end
	
	always @(posedge clock)
	begin
		if(write)
		begin
			current_state = state;
			current_address = address;
			current_data = data_in;
		end
	end

endmodule