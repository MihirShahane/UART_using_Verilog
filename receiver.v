`timescale 1ns / 1ps
//This module simulates the Receiver(Rx) in UART communication setting.
module receiver(input clk, input clken, input rx_en, input Rx, input ready_clr,
output reg ready, output reg [7:0] data_out);

parameter RX_START = 2'b00;
parameter RX_DATA  = 2'b01;
parameter RX_STOP  = 2'b10;

reg [1:0] state = RX_START;
reg [2:0] bit_cnt = 3'b000;

initial begin
    ready = 1'b0;
    data_out = 8'b0;
end

always @(posedge clk) begin
    if(ready_clr)
        ready <= 1'b0;
        
    if(clken && ~rx_en) begin
        case (state)
            RX_START: begin
                if (!Rx) begin
                    state   <= RX_DATA;
                    bit_cnt <= 3'b000;
                end
            end
            
            RX_DATA: begin
                data_out[bit_cnt] <= Rx;
                if (bit_cnt == 3'd7) begin
                    state <= RX_STOP;
                end else begin
                    bit_cnt <= bit_cnt + 1'b1;
                end
            end
            
            RX_STOP: begin
                if (Rx) begin
                    ready <= 1'b1;
                end
                state <= RX_START;
            end
            
            default: state <= RX_START;
        endcase
    end
end

endmodule
