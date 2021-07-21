`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/21 15:19:47
// Design Name: 
// Module Name: bird_display
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


module bird_display
    #(parameter BIRD_LENGTH = 40,
        parameter BIRD_WIDTH = 40)
    (
    input clk_25mhz,
    input reset,
    input [9:0]bird_x,
    input [9:0]bird_y,
    input [9:0]h_cnt,
    input [9:0]v_cnt,
    input valid,
    output valid_bird,
    output [11:0]data_bird
    );

    wire[9:0] bird_x1;
    wire[9:0] bird_y1;
    wire[9:0] data;

    assign bird_x1 = bird_x + BIRD_WIDTH + 1;
    assign bird_y1 = bird_y + BIRD_LENGTH + 1;

    assign valid_bird = valid && h_cnt > bird_x && h_cnt < bird_x1 && v_cnt > bird_y && v_cnt < bird_y1;
    assign data = 12'h55f;
    assign data_bird = valid_bird ? data : 0;

endmodule
