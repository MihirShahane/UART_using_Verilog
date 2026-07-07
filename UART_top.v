`timescale 1ns / 1ps
//This is the top module which integrates both the transmitter and the receiver module into one.
module UART_top(
    input  wire clk,
    input  wire clken,
    input  wire rx_en,
    input  wire tx_en,
    input  wire Rx,
    input  wire ready_clr,
    input  wire [7:0] data_in,
    output wire Tx,
    output wire Tx_busy,
    output wire ready,
    output wire [7:0] data_out
);

    receiver u_receiver (
        .clk (clk),
        .clken (clken),
        .rx_en (rx_en),
        .Rx (Rx),
        .ready_clr (ready_clr),
        .ready (ready),
        .data_out (data_out)
    );

    transmitter u_transmitter (
        .clk (clk),
        .clken (clken),
        .tx_en (tx_en),
        .data_in (data_in),
        .Tx (Tx),
        .Tx_busy (Tx_busy)
    );

endmodule

