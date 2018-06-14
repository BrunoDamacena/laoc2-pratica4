`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:13:16 10/22/2015 
// Design Name: 
// Module Name:    temporizador 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module bcd_7seg(			input				[3:0]		BCD,
								output	reg	[6:0]		SSEG_CA		);
always
case(BCD) 
    4'd0 : SSEG_CA = 7'b0000001;
    4'd1 : SSEG_CA = 7'b1001111;
    4'd2 : SSEG_CA = 7'b0010010;
    4'd3 : SSEG_CA = 7'b0000110;
    4'd4 : SSEG_CA = 7'b1001100;
    4'd5 : SSEG_CA = 7'b0100100;
    4'd6 : SSEG_CA = 7'b0100000;
    4'd7 : SSEG_CA = 7'b0001111;		
    4'd8 : SSEG_CA = 7'b0000000;
    4'd9 : SSEG_CA = 7'b0000100;
    4'd10: SSEG_CA = 7'b0001000;
    4'd11: SSEG_CA = 7'b1100000;
    4'd12: SSEG_CA = 7'b0110001;
    4'd13: SSEG_CA = 7'b1000010;
    4'd14: SSEG_CA = 7'b0110000;
    4'd15: SSEG_CA = 7'b0111000;
endcase 

endmodule