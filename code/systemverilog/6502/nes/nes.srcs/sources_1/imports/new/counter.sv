//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 02/01/2015 11:00:22 PM
//// Design Name: 
//// Module Name: counter
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


//module counter(
//        input logic wait_10,
//        input logic wait_15,
//        input logic clk,
//        output logic en
//    );
    
//    enum logic [1:0] {CNT_WAIT,CNT_10,CNT_15,CNT_OVER} state,next_state;

//    bit [7:0] counter;
    
//    always_ff @(posedge clk)begin
//        if(wait_10==0 && wait_15==0) 
//            state <= CNT_WAIT;
//        else state <= next_state;
//    end   
    
//    always_comb
//        case(state)
//            CNT_WAIT: begin
//                counter = 0;
//                en = 0;
//                if(wait_10==1)
//                    next_state = CNT_10;
//                else if(wait_15==1)
//                    next_state = CNT_15;
//                else 
//                    next_state = CNT_WAIT;
//            end
//            CNT_10: begin
//                en = 0;
//                counter = counter+1;
//                if(counter == 100 ) 
//                    next_state = CNT_OVER;
//                else
//                    next_state = CNT_10;
//            end
//            CNT_15:begin
//                en = 0;
//                counter = counter +1;
//                if(counter == 150) 
//                    next_state = CNT_OVER;
//                else
//                    next_state = CNT_15;
//            end
//            CNT_OVER:begin
//                en = 1;
//                next_state = CNT_WAIT;
//            end 
            
//            default: next_state = CNT_WAIT;
//        endcase
       
//endmodule
