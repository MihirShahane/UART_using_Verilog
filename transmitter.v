`timescale 1ns / 1ps
// This module simulates the Transmitter(TX) in UART Communication setting.
module transmitter(input clk,input clken,input tx_en,input [7:0] data_in,
output reg Tx,output Tx_busy);

parameter TX_IDLE = 2'b00;
parameter TX_START = 2'b01;
parameter TX_DATA = 2'b10;
parameter TX_STOP = 2'b11;

reg [7:0] data = 8'h00;
reg [2:0] counter = 3'h0;
reg [1:0] state = TX_IDLE;

initial begin
    Tx = 1'b1;
end

always @(posedge clk) begin
    case(state)
        TX_IDLE: begin
            if(~tx_en) begin
                state <= TX_START;
                data <= data_in;
                counter <= 3'h0;
            end
        end
       
        TX_START: begin
            if(clken) begin
                state <= TX_DATA;
                Tx <= 1'b0;
            end
        end
       
        TX_DATA: begin
            if(clken) begin
                Tx <= data[counter];
                counter <= counter + 1;
                if(counter == 3'h7)
                    state <= TX_STOP;
            end
        end
        
        TX_STOP: begin
            if(clken) begin
                Tx <= 1'b1;
                state <= TX_IDLE;
            end
        end
        default: begin
            Tx <= 1'b1;
            state <= TX_IDLE;
        end
    endcase
end
   
endmodule
