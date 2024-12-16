`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/14 13:06:29
// Design Name: 
// Module Name: tb
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


module tb_top ();

    reg clk;
    reg rst;
    reg i_run_stop;
    reg i_mode;
    reg i_clear;
    wire [3:0] fnd_com;
    wire [7:0] fnd_font;

    top_module dut_t(
        .clk(clk),
        .rst(rst),
        .btn_mode(i_mode),
        .btn_run_stop(i_run_stop),
        .btn_clear(i_clear),
        .fnd_com(fnd_com),
        .fnd_font(fnd_font)
    );


    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize inputs
        rst = 1;
        i_run_stop = 0;
        i_clear = 0;
        i_mode = 0;
        // Wait for 100ns for global reset to finish
        #100;
        rst = 0;

        #500;
        i_run_stop = 1;
        #1000;
        i_run_stop = 0;

        #5000000;
        i_run_stop = 1;
        #1000;
        i_run_stop = 0;

        // Run for a longer duration
        #1000000000;  // Let it run for 1 second

        // Stop the simulation
        $stop;
    end


endmodule
