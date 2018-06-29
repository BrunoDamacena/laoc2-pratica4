module memory(
			clock,
			write,
			address,
			data_in,
			data_out
);
	input clock;
	input write;
	input [2:0] address;
	input [3:0] data_in;
	output reg [3:0] data_out;
	
	reg [3:0] memory_data [7:0];
	
	initial begin
		memory_data[0] = 4'b0011;
		memory_data[1] = 4'b0000;
		memory_data[2] = 4'b0000;
		memory_data[3] = 4'b0000;
		memory_data[4] = 4'b0000;
		memory_data[5] = 4'b0000;
		memory_data[6] = 4'b0000;
		memory_data[7] = 4'b0000;
	end
	
	always @(posedge clock)
	begin
		if(write)
		begin
			memory_data[address] = data_in;
		end
		data_out = memory_data[address];
	end

endmodule