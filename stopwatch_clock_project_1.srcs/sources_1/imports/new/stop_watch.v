`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/14 00:41:26
// Design Name: 
// Module Name: stop_watch
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


module stop_watch (
    input clk,
    input rst,
    input i_run_stop,
    input i_clear,
    input i_mode,
    output [12:0] time_100ms
);

    wire w_tick_10Hz;

    clk_div_10Hz U_Clk_Div_10Hz (
        .clk(clk),
        .rst(rst),
        .tick_10Hz(w_tick_10Hz)
    );

    counter_100ms U_Counter_100ms (
        .tick_10Hz(w_tick_10Hz),
        .rst(rst),
        .i_run_stop(i_run_stop),
        .i_clear(i_clear),
        .i_mode(i_mode),
        .time_100ms(time_100ms)
    );
endmodule




module clk_div_10Hz (
    input clk,
    input rst,
    output reg tick_10Hz
);
    reg [$clog2(10000000):0] r_tick_counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            tick_10Hz <= 0;
            r_tick_counter <= 0;
        end else begin
            if (r_tick_counter == 10000000) begin
                r_tick_counter <= 0;
                tick_10Hz <= 1'b1;
            end else begin
                r_tick_counter <= r_tick_counter + 1;
                tick_10Hz <= 1'b0;
            end
        end
    end

endmodule


module counter_100ms (
    input tick_10Hz,
    input rst,
    input i_run_stop,
    input i_clear,
    input i_mode,
    output reg [12:0] time_100ms
);

    always @(posedge tick_10Hz, posedge rst, posedge i_mode) begin
        if (rst || i_mode) begin
            time_100ms <= 0;
        end else begin
            if (i_run_stop == 1'b1) begin
                if (time_100ms == 6000) begin
                    time_100ms <= 0;
                end else begin
                    time_100ms <= time_100ms + 1;
                end
            end else begin
                if (i_clear == 1'b1) begin
                    time_100ms <= 0;
                end
            end
        end
    end
endmodule
