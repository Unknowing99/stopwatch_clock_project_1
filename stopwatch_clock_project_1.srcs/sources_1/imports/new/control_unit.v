`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/11 16:29:51
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    input clk,
    input rst,
    input i_mode,
    input i_run_stop,
    input i_clear,
    output reg o_run_stop,
    output reg o_clear,
    output reg o_mode
);
    parameter WATCH_HOUR = 3'b000, WATCH_SEC = 3'b001;
    parameter STOP_WATCH_STOP = 3'b100, STOP_WATCH_RUN = 3'b110, STOP_WATCH_CLEAR = 3'b111;
    reg [2:0] state, state_next;

    // state register
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            state <= WATCH_HOUR;
        end else begin
            state <= state_next;
        end
    end

    // combinational state next
    always @(*) begin
        case (state)
            WATCH_HOUR: begin
                if (i_mode == 1'b1) begin
                    state_next = STOP_WATCH_STOP;
                end else if (i_run_stop == 1'b1) begin
                    state_next = WATCH_SEC;
                end else begin
                    state_next = state;
                end
            end
            WATCH_SEC: begin
                if (i_run_stop == 1'b1) begin
                    state_next = WATCH_HOUR;
                end else begin
                    state_next = state;
                end
            end
            STOP_WATCH_STOP: begin
                if (i_run_stop == 1'b1) begin
                    state_next = STOP_WATCH_RUN;
                end else if (i_mode == 1'b1) begin
                    state_next = WATCH_HOUR;
                end else if (i_clear == 1'b1) begin
                    state_next = STOP_WATCH_CLEAR;
                end else begin
                    state_next = state;
                end
            end
            STOP_WATCH_RUN: begin
                if (i_run_stop == 1'b1) begin
                    state_next = STOP_WATCH_STOP;
                end else begin
                    state_next = state;
                end
            end
            STOP_WATCH_CLEAR: begin
                if (i_clear == 1'b1) begin
                    state_next = STOP_WATCH_STOP;
                end else begin
                    state_next = state;
                end
            end
            
            default: state_next = state;
        endcase


    end

    // output register
    always @(*) begin
        case (state)
            WATCH_HOUR: begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
                o_mode = 1'b0;
            end
            WATCH_SEC: begin
                o_run_stop = 1'b1;
                o_clear = 1'b0;
                o_mode = 1'b0;
            end
            STOP_WATCH_STOP: begin
                o_clear = 1'b0;
                o_run_stop = 1'b0;
                o_mode = 1'b1;
            end
            STOP_WATCH_RUN: begin
                o_clear = 1'b0;
                o_run_stop = 1'b1;
                o_mode = 1'b1;
            end
            STOP_WATCH_CLEAR: begin
                o_clear = 1'b1;
                o_run_stop = 1'b0;
                o_mode = 1'b1;
            end
            default: begin
                o_run_stop = 1'b0;
                o_clear = 1'b0;
                o_mode = 1'b0;
            end
        endcase
    end

endmodule
