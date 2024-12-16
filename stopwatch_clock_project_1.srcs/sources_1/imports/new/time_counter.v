`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/13 21:52:10
// Design Name: 
// Module Name: time_counter
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


module time_counter (
    input clk,
    input rst,
    output [6:0] o_bcd_msec,
    output [5:0] o_bcd_sec,
    output [5:0] o_bcd_min,
    output [4:0] o_bcd_hour
);
    wire w_tick_msec, w_tick_sec, w_tick_min, w_tick_hour;

    tick_msec U_Tick_Msec (
        .clk(clk),
        .rst(rst),
        .tick_msec(w_tick_msec)
    );

    counter_msec U_Counter_Msec (
        .tick_msec(w_tick_msec),
        .rst(rst),
        .o_bcd_msec(o_bcd_msec),
        .tick_sec(w_tick_sec)
    );

    counter_sec U_Counter_Sec (
        .tick_sec(w_tick_sec),
        .rst(rst),
        .o_bcd_sec(o_bcd_sec),
        .tick_min(w_tick_min)
    );

    counter_min U_Counter_Min (
        .tick_min(w_tick_min),
        .rst(rst),
        .o_bcd_min(o_bcd_min),
        .tick_hour(w_tick_hour)
    );

    counter_hour U_Counter_Hour (
        .tick_hour(w_tick_hour),
        .rst(rst),
        .o_bcd_hour(o_bcd_hour)
    );

endmodule

// 10ms 주기로 틱 생성
module tick_msec (
    input clk,
    input rst,
    output reg tick_msec
);
    reg [$clog2(1_000_000)-1:0] r_tick_counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            tick_msec <= 0;
            r_tick_counter <= 0;
        end else begin
            if (r_tick_counter == 1_000_000) begin
                tick_msec <= 1'b1;
                r_tick_counter <= 0;
            end else begin
                r_tick_counter <= r_tick_counter + 1;
                tick_msec <= 1'b0;
            end

        end
    end
endmodule

// 1000ms 카운팅, 1초 주기로 틱 생성성
module counter_msec (
    input tick_msec,
    input rst,
    output reg [6:0] o_bcd_msec,
    output reg tick_sec
);

    always @(posedge tick_msec, posedge rst) begin
        if (rst) begin
            o_bcd_msec <= 0;
            tick_sec <= 0;
        end else begin
            if (o_bcd_msec == 100-1) begin
                o_bcd_msec <= 0;
                tick_sec <= 1'b1;
            end else begin
                o_bcd_msec <= o_bcd_msec + 1;
                tick_sec <= 1'b0;
            end
        end
    end
endmodule

// 60초 카운팅, 1분 주기로 틱 생성
module counter_sec (
    input tick_sec,
    input rst,
    output reg [5:0] o_bcd_sec,
    output reg tick_min
);
    always @(posedge tick_sec, posedge rst) begin
        if (rst) begin
            o_bcd_sec <= 0;
            tick_min <= 0;
        end else begin
            if (o_bcd_sec == 60-1) begin
                o_bcd_sec <= 0;
                tick_min <= 1'b1;
            end else begin
                o_bcd_sec <= o_bcd_sec + 1;
                tick_min <= 1'b0;
            end
        end
    end
endmodule



// 60분 카운팅, 1시간 주기로 틱 생성
module counter_min (
    input tick_min,
    input rst,
    output reg [5:0] o_bcd_min,
    output reg tick_hour
);
    always @(posedge tick_min, posedge rst) begin
        if (rst) begin
            o_bcd_min <= 0;
            tick_hour <= 0;
        end else begin
            if (o_bcd_min == 60-1) begin
                o_bcd_min <= 0;
                tick_hour <= 1'b1;
            end else begin
                o_bcd_min <= o_bcd_min + 1;
                tick_hour <= 1'b0;
            end
        end
    end
endmodule

// 24시간 카운팅
module counter_hour (
    input tick_hour,
    input rst,
    output reg [4:0] o_bcd_hour
);
    always @(posedge tick_hour, posedge rst) begin
        if (rst) begin
            o_bcd_hour <= 0;
        end else begin
            if (o_bcd_hour == 24-1) begin
                o_bcd_hour <= 0;
            end else begin
                o_bcd_hour <= o_bcd_hour + 1;
            end
        end
    end
endmodule
