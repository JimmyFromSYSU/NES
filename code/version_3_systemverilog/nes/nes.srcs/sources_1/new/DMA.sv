`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/21 09:03:52
// Design Name: 
// Module Name: DMA
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


module DMA(
    input bit clk,
    //input bit write,
    input bit start,
    input bit[7:0] din,
    output bit[15:0] addr_1,
    input bit [7:0] data_1,
    output bit read_1,
    output bit[15:0] addr_2,
    output bit[7:0] data_2,
    output bit write_2,
    output bit finish_dma
);
    bit [8:0] wait_DMA_q;
    bit start_cnt;
    bit done_once;
    auto_add #(9) x_pos
    (
        .P(9'b0),
        .Q(wait_DMA_q),
        .reset(1'b0),
        .load(start_cnt),
        .en(done_once),
        .clk(clk)
    );

    assign done_DMA = (wait_DMA_q == 9'h0FF);
    enum bit [2:0] {WAIT,READY,GET_DATA,SAVE_DATA}  state,next_state;
    always_ff @(posedge clk)begin
        state <= next_state;
    end
    
    always_comb begin
        case(state)
            WAIT : if(start)next_state = READY; else next_state = WAIT;
            READY : next_state = GET_DATA;
            GET_DATA :next_state = SAVE_DATA;
            SAVE_DATA :if(done_DMA) next_state = WAIT ; else next_state = GET_DATA;
        endcase
    end
    
    bit [15:0] tmp_addr;
    bit [7:0] tmp_data;
    always_ff @(negedge clk)begin
        if(state == WAIT)begin
            if(start == 1)tmp_addr <= {din,8'h00};
            done_once <= 0;
        end
        else if(state == GET_DATA)begin
            tmp_data <= data_1;
            done_once<=0;
        end
        else if(state == READY)done_once <= 0;
        else if(state == SAVE_DATA)done_once <= 1;
    end
    
    always_comb begin
        start_cnt = 0;
        finish_dma = 0;
        read_1 = 0;
        write_2 = 0;
        case(state)
            //WAIT:if(start==1) addr
            READY: start_cnt=1;
            GET_DATA: begin
                addr_1 = tmp_addr + wait_DMA_q ; 
                read_1 = 1;
            end
            SAVE_DATA: begin
                addr_2 = wait_DMA_q;
                data_2 = tmp_data;
                write_2 = 1;
                if(next_state == WAIT) finish_dma = 1;
            end
        endcase
    end
endmodule
