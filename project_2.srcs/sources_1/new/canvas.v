`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/21 15:00:14
// Design Name: 
// Module Name: canvas
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


module canvas(
    input sys_clk_in,
    input sys_rst_n,
    output hsync,
    output vsync,
    output[11:0] vga_data_pin
    );

    wire valid;
    wire[9:0] h_cnt;
    wire[9:0] v_cnt;
    wire[59:0] tube_x, tube_y, tube_gap_height;
    wire[9:0] bird_x, bird_y;
    wire clk_25mhz;
    wire valid_background, valid_bird, valid_obstacles;
    wire [11:0] data_background, data_bird, data_obstacles;
    reg[11:0] data;

    assign bird_x = 10'h0A0;
    assign bird_y = 10'h0F0;

    assign tube_y = 60'h03216320FA4B15E;
    assign tube_x = 60'h078823994A641E8;
    assign tube_gap_height = 60'h1d84e11c4611040;

    clk_wiz_0 Instance_clk_25mhz(.clk_in1(sys_clk_in),.reset(~sys_rst_n),.clk_out1(clk_25mhz));
    
    vga_640x480_vh Instance_vga(.pclk(clk_25mhz),.reset(~sys_rst_n),
                                .hsync(hsync),.vsync(vsync),
                                .valid(valid),.h_cnt(h_cnt),.v_cnt(v_cnt));

    bird_display Instance_bird_display(.clk_25mhz(clk_25mhz),.reset(~sys_rst_n),
                                        .bird_x(bird_x),.bird_y(bird_y),
                                        .h_cnt(h_cnt),.v_cnt(v_cnt),
                                        .valid(valid),
                                        .valid_bird(valid_bird),.data_bird(data_bird));

    obstacles_display Instance_obstacles_display(.clk_25mhz(clk_25mhz),
                                                    .tube_y(tube_y),.tube_x(tube_x),.tube_gap_height(tube_gap_height),
                                                    .h_cnt(h_cnt),.v_cnt(v_cnt),
                                                    .valid(valid),
                                                    .valid_obstacles(valid_obstacles),.data_obstacles(data_obstacles));

    always @(*) begin
        if(!valid) data <= 12'h000;
        else if(valid_bird) data <= data_bird;
        else if(valid_obstacles) data <= data_obstacles;
        else 
            data <= 12'hfff;
    end

    assign vga_data_pin = data;

endmodule
