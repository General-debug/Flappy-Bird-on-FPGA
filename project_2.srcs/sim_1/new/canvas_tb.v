`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/21 15:06:02
// Design Name: 
// Module Name: canvas_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module canvas_tb(
    );
    
    reg Clk, sys_rst_n;
    wire hsync, vsync;
    wire [11:0]vga_data_pin;
    
canvas UTT(.sys_clk_in(Clk),
               .sys_rst_n(sys_rst_n),
               .hsync(hsync),.vsync(vsync),
               .vga_data_pin(vga_data_pin));
    
always begin
    Clk = 1; #5;
    Clk = 0; #5;
end    

initial begin
    sys_rst_n = 0;
    #10;
    sys_rst_n = 1;
end
    
endmodule
