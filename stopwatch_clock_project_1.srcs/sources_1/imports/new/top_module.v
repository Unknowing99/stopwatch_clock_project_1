`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 21:47:58
// Design Name: 
// Module Name: top_module
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


module top_module (
    input clk,
    input rst,
    input btn_mode,
    input btn_run_stop,
    input btn_clear,
    output [3:0] fnd_com,
    output [7:0] fnd_font
);
    wire o_run_stop, o_mode, o_clear;
    wire [6:0] w_bcd_msec;
    wire [5:0] w_bcd_sec, w_bcd_min;
    wire [4:0] w_bcd_hour;
    wire [12:0] w_bcd_data;


    debounce U_Debounce_run_stop(
        .clk(clk),
        .rst(rst),
        .i_btn(btn_run_stop),
        .o_btn(i_run_stop)
    );

    debounce U_Debounce_clear(
        .clk(clk),
        .rst(rst),
        .i_btn(btn_clear),
        .o_btn(i_clear)
    );

    debounce U_Debounce_mode(
        .clk(clk),
        .rst(rst),
        .i_btn(btn_mode),
        .o_btn(i_mode)
    );

    control_unit U_Control_Unit(
        .clk(clk),
        .rst(rst),
        .i_mode(i_mode),
        .i_run_stop(i_run_stop),
        .i_clear(i_clear),
        .o_run_stop(o_run_stop),
        .o_clear(o_clear),
        .o_mode(o_mode)
    );

    time_counter U_Time_Counter(
        .clk(clk),
        .rst(rst),
        .o_bcd_msec(w_bcd_msec),
        .o_bcd_sec(w_bcd_sec),
        .o_bcd_min(w_bcd_min),
        .o_bcd_hour(w_bcd_hour)
    );

    stop_watch U_Stop_Watch(
        .clk(clk),
        .rst(rst),
        .i_run_stop(o_run_stop),
        .i_clear(o_clear),
        .i_mode(i_mode),
        .time_100ms(w_bcd_data)
    );

    fnd_controller U_Fnd_Controller(
        .clk(clk),
        .rst(rst),
        .btn_run_stop(o_run_stop),
        .btn_mode(o_mode),
        .i_bcd_hour(w_bcd_hour),
        .i_bcd_min(w_bcd_min),
        .i_bcd_sec(w_bcd_sec),
        .i_bcd_msec(w_bcd_msec),
        .i_bcd_data(w_bcd_data),
        .fnd_com(fnd_com),
        .fnd_font(fnd_font)
    );
endmodule

