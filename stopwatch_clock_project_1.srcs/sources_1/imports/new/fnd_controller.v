`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 21:52:38
// Design Name: 
// Module Name: fnd_controller
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


module fnd_controller (
    input clk,
    input rst,
    input btn_run_stop,
    input btn_mode,
    input [4:0] i_bcd_hour,
    input [5:0] i_bcd_min,
    input [5:0] i_bcd_sec,
    input [6:0] i_bcd_msec,
    input [12:0] i_bcd_data,
    output [3:0] fnd_com,
    output [7:0] fnd_font
);
    wire w_tick_1000Hz;
    wire [1:0] w_sel;
    wire [3:0] w_digit_10_msec, w_digit_100_msec, w_digit_1_sec, w_digit_10_sec, w_digit_1_min, w_digit_10_min, w_digit_1_hour, w_digit_10_hour;
    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000;
    wire [3:0] w_seg_data;

    clk_div_1000Hz U_Clk_Div_1000Hz (
        .clk(clk),
        .rst(rst),
        .tick_1000Hz(w_tick_1000Hz)
    );

    counter_4 U_Counter_4 (
        .tick_1000Hz(w_tick_1000Hz),
        .rst(rst),
        .o_sel(w_sel)
    );

    decoder_2X4 U_Decoder_2X4 (
        .i_sel  (w_sel),
        .fnd_com(fnd_com)
    );

    digit_splitter_msec U_Digit_Splitter_Msec (
        .i_bcd_msec(i_bcd_msec),
        .digit_10_msec(w_digit_10_msec),
        .digit_100_msec(w_digit_100_msec)
    );

    digit_splitter_sec U_Digit_Splitter_Sec (
        .i_bcd_sec(i_bcd_sec),
        .digit_1_sec(w_digit_1_sec),
        .digit_10_sec(w_digit_10_sec)
    );

    digit_splitter_min U_Digit_Splitter_Min (
        .i_bcd_min(i_bcd_min),
        .digit_1_min(w_digit_1_min),
        .digit_10_min(w_digit_10_min)
    );

    digit_splitter_hour U_Digit_Splitter_Hour (
        .i_bcd_hour(i_bcd_hour),
        .digit_1_hour(w_digit_1_hour),
        .digit_10_hour(w_digit_10_hour)
    );

    digit_splitter_stop_watch U_Digit_Splitter_Stop_Watch(
        .bcd_data(i_bcd_data),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000)
    );

    mux_12X1 U_Mux_12X1 (
        .digit_sel(w_sel),
        .run_stop(btn_run_stop),
        .mode(btn_mode),
        .digit_10_msec(w_digit_10_msec),
        .digit_100_msec(w_digit_100_msec),
        .digit_1_sec(w_digit_1_sec),
        .digit_10_sec(w_digit_10_sec),
        .digit_1_min(w_digit_1_min),
        .digit_10_min(w_digit_10_min),
        .digit_1_hour(w_digit_1_hour),
        .digit_10_hour(w_digit_10_hour),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000),
        .seg_data(w_seg_data)
    );

    fnd_font U_Fnd_Font (
        .seg_data(w_seg_data),
        .fnd_font(fnd_font)
    );

endmodule

module clk_div_1000Hz (
    input clk,
    input rst,
    output reg tick_1000Hz
);
    reg [$clog2(100_000)-1:0] r_tick_counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_tick_counter <= 0;
        end else begin
            if (r_tick_counter == 100_000) begin
                r_tick_counter <= 0;
                tick_1000Hz <= 1'b1;
            end else begin
                r_tick_counter <= r_tick_counter + 1;
                tick_1000Hz <= 1'b0;
            end
        end
    end
endmodule

module counter_4 (
    input tick_1000Hz,
    input rst,
    output reg [1:0] o_sel
);
    always @(posedge tick_1000Hz, posedge rst) begin
        if (rst) begin
            o_sel = 2'b00;
        end else begin
            o_sel <= o_sel + 1;
        end
    end
endmodule

module decoder_2X4 (
    input [1:0] i_sel,
    output reg [3:0] fnd_com
);

    always @(*) begin
        case (i_sel)
            2'b00:   fnd_com = 4'b1110;
            2'b01:   fnd_com = 4'b1101;
            2'b10:   fnd_com = 4'b1011;
            2'b11:   fnd_com = 4'b0111;
            default: fnd_com = 4'b1111;
        endcase
    end
endmodule

module digit_splitter_msec (
    input  [6:0] i_bcd_msec,
    output [3:0] digit_10_msec,
    output [3:0] digit_100_msec
);

    assign digit_10_msec  = i_bcd_msec % 10;
    assign digit_100_msec = (i_bcd_msec / 10) % 10;

endmodule

module digit_splitter_sec (
    input  [5:0] i_bcd_sec,
    output [3:0] digit_1_sec,
    output [3:0] digit_10_sec
);

    assign digit_1_sec  = i_bcd_sec % 10;
    assign digit_10_sec = (i_bcd_sec / 10) % 10;

endmodule

module digit_splitter_min (
    input  [5:0] i_bcd_min,
    output [3:0] digit_1_min,
    output [3:0] digit_10_min
);

    assign digit_1_min  = i_bcd_min % 10;
    assign digit_10_min = (i_bcd_min / 10) % 10;

endmodule

module digit_splitter_hour (
    input  [4:0] i_bcd_hour,
    output [3:0] digit_1_hour,
    output [3:0] digit_10_hour
);

    assign digit_1_hour  = i_bcd_hour % 10;
    assign digit_10_hour = (i_bcd_hour / 10) % 10;

endmodule

module digit_splitter_stop_watch (
    input  [12:0] bcd_data,
    output [ 3:0] digit_1,
    output [ 3:0] digit_10,
    output [ 3:0] digit_100,
    output [ 3:0] digit_1000
);

    assign digit_1 = bcd_data % 10;  // 100ms
    assign digit_10 = (bcd_data / 10) % 10;  // 1초
    assign digit_100 = (bcd_data / 100) % 6;  // 10초
    assign digit_1000 = (bcd_data / 600) % 10;  // 1분

endmodule

module mux_12X1 (
    input      [1:0] digit_sel,
    input            run_stop,
    input            mode,
    input      [3:0] digit_10_msec,
    input      [3:0] digit_100_msec,
    input      [3:0] digit_1_sec,
    input      [3:0] digit_10_sec,
    input      [3:0] digit_1_min,
    input      [3:0] digit_10_min,
    input      [3:0] digit_1_hour,
    input      [3:0] digit_10_hour,
    input      [3:0] digit_1,
    input      [3:0] digit_10,
    input      [3:0] digit_100,
    input      [3:0] digit_1000,
    output reg [3:0] seg_data
);
    wire [3:0] select;
    assign select = {mode, run_stop, digit_sel};
    always @(select) begin
        case (select)
            4'b0000: seg_data = digit_1_min;
            4'b0001: seg_data = digit_10_min;
            4'b0010: seg_data = digit_1_hour;
            4'b0011: seg_data = digit_10_hour;
            4'b0100: seg_data = digit_10_msec;
            4'b0101: seg_data = digit_100_msec;
            4'b0110: seg_data = digit_1_sec;
            4'b0111: seg_data = digit_10_sec;
            4'b1000: seg_data = digit_1;
            4'b1001: seg_data = digit_10;
            4'b1010: seg_data = digit_100;
            4'b1011: seg_data = digit_1000;
            4'b1100: seg_data = digit_1;
            4'b1101: seg_data = digit_10;
            4'b1110: seg_data = digit_100;
            4'b1111: seg_data = digit_1000;

            default: seg_data = digit_1_min;
        endcase
    end
endmodule


module fnd_font (
    input [3:0] seg_data,
    output reg [7:0] fnd_font
);

    //4bit binary -> 7sec decimal

    always @(seg_data) begin

        case (seg_data)
            8'h0: fnd_font = 8'hc0;
            8'h1: fnd_font = 8'hf9;
            8'h2: fnd_font = 8'ha4;
            8'h3: fnd_font = 8'hb0;
            8'h4: fnd_font = 8'h99;
            8'h5: fnd_font = 8'h92;
            8'h6: fnd_font = 8'h82;
            8'h7: fnd_font = 8'hf8;
            8'h8: fnd_font = 8'h80;
            8'h9: fnd_font = 8'h90;
            8'ha: fnd_font = 8'h88;
            8'hb: fnd_font = 8'h83;
            8'hc: fnd_font = 8'hc6;
            8'hd: fnd_font = 8'ha1;
            8'he: fnd_font = 8'h86;
            8'hf: fnd_font = 8'h8e;

            default: fnd_font = 8'hff;
        endcase

    end

endmodule
