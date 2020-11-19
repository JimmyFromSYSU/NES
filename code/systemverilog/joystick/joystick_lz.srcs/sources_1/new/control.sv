`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2015 11:00:41 PM
// Design Name: 
// Module Name: control
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

module pulse(
    input logic clk,
    input logic en, // en --> en > 3*clk
    output logic pulse
);
    bit cnt;
    bit reset;
    always_ff @(negedge clk)begin
        if(en == 0) reset <= 0;
        else begin
            if(reset == 0) begin
                reset <= 1;
                cnt <=1;
            end 
            else if(cnt == 1)begin
                pulse <= 1;
                cnt <= 0;
            end
            else 
                pulse <= 0;  
        end
    end
endmodule

module fsm(
     input logic start,
     input logic clk_100M,
     input logic clk_390K,
     output logic wait_15,
     output logic wait_10,
     input logic end_15,
     input logic end_10,
     output logic s_clk,
     output logic SS,
     //output logic en_trans,
     output logic en_recei
     //,output logic [2:0] output_state
     //,output logic en_cnt_1byte
     //,output logic pulse_1byte
);
    logic en_cnt_1bit;
    logic en_cnt_1byte;
    logic start_8bit,start_5byte,en_sck;
    enum logic [2:0]{IDLE, WAIT_15US,WAIT_390K_1,WAIT_390K_0, RECIEVE,TRANS, OVER_8BIT, WAIT_10US} state,next_state;
    //assign output_state = next_state;
    always_ff @(negedge clk_100M)begin
        state <= next_state;
    end
    
    assign s_clk = clk_390K & en_sck;

    logic [7:0] q8bit;
    logic pulse_1bit;
    pulse p_1bit (clk_100M,en_cnt_1bit,pulse_1bit);
    counter #(8) c8bit
    (
        .P(8'd8),
        .Q(q8bit),
        .reset(1'b0),
        .load(start_8bit),
        .en(pulse_1bit),
        .clk(clk_100M)
    );
    assign done_8bit = (q8bit == 0);
    
    logic [7:0] q5byte;
    logic pulse_1byte;
    pulse p_1byte (clk_100M,en_cnt_1byte,pulse_1byte);
    counter #(8) c5byte
    (
        .P(8'd5),
        .Q(q5byte),
        .reset(1'b0),
        .load(start_5byte),
        .en(pulse_1byte),
        .clk(clk_100M)
    );
    assign done_5byte = (q5byte == 0);
    
    //logic reset_cnt_1bit;
    logic create_recei;
    pulse p_recei (clk_100M,create_recei,en_recei);
    always_comb begin
        wait_10 = 0;
        wait_15 = 0;
        en_sck = 0;
        create_recei = 0;
        //en_recei=0;
        en_cnt_1bit=0;
        en_cnt_1byte=0;
        start_8bit=0;
        start_5byte=0;
        
        SS=0;
        
        case(state)
            IDLE:begin
                next_state = start?WAIT_15US: IDLE;
                SS = 1;
                if(start)wait_15 = 1;
            end
            WAIT_15US:begin
                next_state = end_15?WAIT_390K_1:WAIT_15US;
                start_5byte=1;
            end
            WAIT_390K_1: begin
                 next_state = clk_390K?WAIT_390K_1:WAIT_390K_0;
            end
            WAIT_390K_0: begin
                next_state = clk_390K?WAIT_390K_0:RECIEVE;
                start_8bit = 1;
                en_sck = 1;
            end
            RECIEVE: begin
                next_state = (clk_390K)?TRANS:RECIEVE;
                //en_recei = clk_390K;
                en_cnt_1bit = 1; 
                en_sck = 1;
            end
            TRANS:begin
                create_recei = 1;
                next_state = clk_390K? TRANS:(done_8bit?OVER_8BIT:RECIEVE);
                en_sck = 1;
            end
            OVER_8BIT:begin
                wait_10 = 1;
                next_state = WAIT_10US;
                en_cnt_1byte = 1;
            end
            WAIT_10US:begin
                en_cnt_1byte = 1;
                next_state=end_10? (done_5byte?IDLE:WAIT_390K_1) : WAIT_10US;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
