`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/12 15:48:15
// Design Name: 
// Module Name: debouning
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


module debounce (
    input  clk,
    input  rst,
    input  i_btn,
    output o_btn
);

    reg r_dff;
    reg [3:0] r_debounce;
    reg [$clog2(100000)-1:0] tick_counter;
    reg  r_debounce_clk;

    wire w_debounce;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            tick_counter <= 0;
        end else begin
            if (tick_counter == 100000) begin
                tick_counter <= 0;
                r_debounce_clk   <= 1'b1;
            end else begin
                tick_counter <= tick_counter + 1;
                r_debounce_clk   <= 1'b0;
            end
        end


    end

    
    always @(posedge r_debounce_clk, posedge rst) begin
        if (rst) begin
            r_debounce <= 0;
        end else begin
            r_debounce <= {i_btn, r_debounce[3:1]};
        end

    end

    assign w_debounce = &r_debounce;

    always @(posedge r_debounce_clk, posedge rst) begin
        if (rst) begin
            r_dff <= 1'b0;
        end else begin
            r_dff <= w_debounce;
        end
    end

    assign o_btn = w_debounce & (~r_dff);
endmodule
