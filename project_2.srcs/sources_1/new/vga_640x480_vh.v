`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 09:56:17
// Design Name: 
// Module Name: vga_640x480_vh
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 产生VGA时序hsync和vsync，输出坐标h_cnt，v_cnt。
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_640x480_vh(
	input pclk,
	input reset,
	output hsync,
	output vsync,
	output valid,
	output [9:0] h_cnt,
	output [9:0] v_cnt
	);  
 
   parameter    h_frontporch = 96;
   parameter    h_active = 144;
   parameter    h_backporch = 784;
   parameter    h_total = 800;
   
   parameter    v_frontporch = 2;
   parameter    v_active = 35;
   parameter    v_backporch = 515;
   parameter    v_total = 525;
   
	reg[9:0] x_cnt, y_cnt, v_cnt_in, h_cnt_in;
	reg h_valid, v_valid;
	reg vsync_in, hsync_in;


	always @(posedge pclk) begin
		if(reset) begin
			x_cnt<=10'd1;
			y_cnt<=10'd1;
		end
		else begin
			if (x_cnt==h_total) begin
				x_cnt<=10'd1;
			end 
			else begin
				x_cnt<=x_cnt+1'b1;
			end
			
			if ((y_cnt==v_total) && (x_cnt == h_total)) begin
				y_cnt<=10'd1;
			end 
			else if(x_cnt == h_total) begin
				y_cnt<=y_cnt+1'b1;
			end
			
			if (x_cnt > h_frontporch) begin
				hsync_in<=1'b1;
			end
			else begin
				hsync_in<=1'b0;
			end
			
			if (y_cnt > v_frontporch) begin
				vsync_in<=1'b1;
			end
			else begin
				vsync_in<=1'b0;
			end		
		
			if ((x_cnt > h_active) && (x_cnt<=h_backporch)) begin
				h_valid<=1'b1;
			end
			else begin
				h_valid<=1'b0;
			end
			if ((y_cnt > v_active) && (y_cnt<=v_backporch)) begin
				v_valid<=1'b1;
			end
			else begin
				v_valid<=1'b0;
			end		
			if ((x_cnt > h_active) && (x_cnt<=h_backporch))  begin
				h_cnt_in<=x_cnt-h_active;
			end
			else begin
				h_cnt_in<=10'd0;
			end
			if (v_valid==1'b1) begin
				v_cnt_in<=y_cnt-v_active;
			end
			else begin
				v_cnt_in<=10'd0;
			end		
		end
	end
	
	assign valid = (h_valid & v_valid);
	assign vsync = vsync_in;
	assign hsync = hsync_in;
	assign h_cnt = h_cnt_in;
	assign v_cnt = v_cnt_in;
  
endmodule