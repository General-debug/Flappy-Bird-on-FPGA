`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/21 15:36:07
// Design Name: 
// Module Name: obstacles_display
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


module obstacles_display
    #(    
    parameter tube_width = {10'd44, 10'd44, 10'd44, 10'd44, 10'd44, 10'd44},
    parameter tube_mouth_height = {10'd30, 10'd30, 10'd30, 10'd30, 10'd30, 10'd30},
    parameter tube_mouth_heighlight1 = 12,
    parameter ground = 450,
    parameter ceil = 50)
(
    input clk_25mhz,//25.2Mhz时钟
    input [59:0] tube_y,//六根柱子的上侧坐标
    input [59:0] tube_x,//六根柱子的右侧坐标
    input signed [59:0] tube_gap_height,//柱子的上下间距，指上柱子下侧到下柱子上侧
    input [9:0]h_cnt,
    input [9:0]v_cnt,
    input valid,
    output reg valid_obstacles,
    output reg[11:0] data_obstacles
    );

    //管道直接判断区域并上色
    wire [59:0] tube_mouth_l;
    wire [59:0] tube_mouth_r;
    wire [59:0] tube_mouth_t1;//上方柱子
    wire [59:0] tube_mouth_b1;
    wire [59:0] tube_mouth_t2;//下方柱子
    wire [59:0] tube_mouth_b2;

    wire overflow_left;//左侧是否溢出屏幕
    reg valid_tube_edge;
    reg valid_tube_mouth;
    reg valid_tube_body;
    reg valid_tube_heighlight1;
    reg valid_tube_heighlight2;
    reg valid_tube_shadow1;

    assign overflow_left = tube_x[59:50] < tube_width[59:50];
    assign tube_mouth_r = tube_x;
    assign tube_mouth_l = overflow_left ? {10'd0, tube_x[49:0] - tube_width[49:0]} : tube_x - tube_width;
    assign tube_mouth_b1 = tube_y;
    assign tube_mouth_t1 = tube_y - tube_mouth_height;
    assign tube_mouth_t2 = tube_y + tube_gap_height;
    assign tube_mouth_b2 = tube_y + tube_gap_height + tube_mouth_height;

    integer i;
    reg [9:0]tmp_l, tmp_r, tmp_t1, tmp_b1, tmp_t2, tmp_b2, tmp_body_l, tmp_body_r;
    always @(posedge clk_25mhz) begin
        valid_tube_body = 0;
        valid_tube_edge = 0;
        valid_tube_mouth = 0;
        for(i = 0; i < 6; i = i + 1) begin
            case (i)//能不能这样对寄存器进行处理？？
                0:begin
                    tmp_l = tube_mouth_l[59:50];
                    tmp_r = tube_mouth_r[59:50];
                    tmp_t1 = tube_mouth_t1[59:50];
                    tmp_b1 = tube_mouth_b1[59:50];
                    tmp_t2 = tube_mouth_t2[59:50];
                    tmp_b2 = tube_mouth_b2[59:50];
                end 
                1:begin
                    tmp_l = tube_mouth_l[49:40];
                    tmp_r = tube_mouth_r[49:40];
                    tmp_t1 = tube_mouth_t1[49:40];
                    tmp_b1 = tube_mouth_b1[49:40];
                    tmp_t2 = tube_mouth_t2[49:40];
                    tmp_b2 = tube_mouth_b2[49:40];
                end
                2:begin
                    tmp_l = tube_mouth_l[39:30];
                    tmp_r = tube_mouth_r[39:30];
                    tmp_t1 = tube_mouth_t1[39:30];
                    tmp_b1 = tube_mouth_b1[39:30];
                    tmp_t2 = tube_mouth_t2[39:30];
                    tmp_b2 = tube_mouth_b2[39:30];
                end
                3:begin
                    tmp_l = tube_mouth_l[29:20];
                    tmp_r = tube_mouth_r[29:20];
                    tmp_t1 = tube_mouth_t1[29:20];
                    tmp_b1 = tube_mouth_b1[29:20];
                    tmp_t2 = tube_mouth_t2[29:20];
                    tmp_b2 = tube_mouth_b2[29:20];
                end 
                4:begin
                    tmp_l = tube_mouth_l[19:10];
                    tmp_r = tube_mouth_r[19:10];
                    tmp_t1 = tube_mouth_t1[19:10];
                    tmp_b1 = tube_mouth_b1[19:10];
                    tmp_t2 = tube_mouth_t2[19:10];
                    tmp_b2 = tube_mouth_b2[19:10];
                end
                5:begin
                    tmp_l = tube_mouth_l[9:0];
                    tmp_r = tube_mouth_r[9:0];
                    tmp_t1 = tube_mouth_t1[9:0];
                    tmp_b1 = tube_mouth_b1[9:0];
                    tmp_t2 = tube_mouth_t2[9:0];
                    tmp_b2 = tube_mouth_b2[49:0];
                end 
                default: begin
                    tmp_l = tube_mouth_l[9:0];
                    tmp_r = tube_mouth_r[9:0];
                    tmp_t1 = tube_mouth_t1[9:0];
                    tmp_b1 = tube_mouth_b1[9:0];
                    tmp_t2 = tube_mouth_t2[9:0];
                    tmp_b2 = tube_mouth_b2[49:0];
                end 
            endcase

            tmp_body_l = tmp_l + 1;
            tmp_body_r = tmp_r - 1;

            valid_tube_edge = valid_tube_edge ||
                                ((( ((i!=0)||(~overflow_left)) && h_cnt == tmp_l)||h_cnt == tmp_r) && (v_cnt >= tmp_t1 && v_cnt <= tmp_b1)) ||
                               ((v_cnt == tmp_t1 || v_cnt == tmp_b1) && (h_cnt >= tmp_l && h_cnt <= tmp_r)) ||//上方管道 管道口处的边界
                                ((( ((i!=0)||(~overflow_left)) && h_cnt == tmp_l + 1)||h_cnt == tmp_r - 1) && (v_cnt < tmp_t1 && v_cnt > ceil))||//上方管道壁

                                ((( ((i!=0)||(~overflow_left)) && h_cnt == tmp_l)||h_cnt == tmp_r) && (v_cnt >= tmp_t2 && v_cnt <= tmp_b2)) ||
                               ((v_cnt == tmp_t2 || v_cnt == tmp_b2) && (h_cnt >= tmp_l && h_cnt <= tmp_r)) ||//下方管道 管道口处的边界
                                ((( ((i!=0)||(~overflow_left)) && h_cnt == tmp_l + 1)||h_cnt == tmp_r - 1) && (v_cnt > tmp_b2 && v_cnt < ground));//下方管道壁

            valid_tube_mouth = valid_tube_mouth ||
                                (h_cnt > tmp_l && h_cnt < tmp_r && 
                                    ((v_cnt > tmp_t1 && v_cnt < tmp_b1)||
                                    (v_cnt > tmp_t2 && v_cnt < tmp_b2)));//水管口填色

            valid_tube_body = valid_tube_body ||
                                (h_cnt < tmp_r && h_cnt > tmp_l && 
                                ((v_cnt < tmp_t1 && v_cnt > ceil)||
                                (v_cnt > tmp_b2 && v_cnt < ground)));//水管填色
        end
    end

    always @(posedge clk_25mhz) begin
        if(valid) begin
            if(valid_tube_edge) 
                data_obstacles <= 12'h000;
            else if(valid_tube_mouth)
                data_obstacles <= 12'h0f0;
            else if(valid_tube_body)
                data_obstacles <= 12'h3e0;
            else data_obstacles <= 12'hfff;
        end
        else data_obstacles <= 12'h000;
    end

    always @(posedge clk_25mhz) begin
        valid_obstacles <= valid && (valid_tube_edge || valid_tube_mouth || valid_tube_body);
    end

endmodule
