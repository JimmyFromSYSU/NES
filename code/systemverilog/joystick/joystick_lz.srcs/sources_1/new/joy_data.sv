`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/03/2015 10:48:15 AM
// Design Name: 
// Module Name: joy_data
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

//module register 
// #(parameter W= 8)
//(
//    input logic clk,
//    input logic [W-1:0] L,
//    input logic reset,load,clear,
//    output logic [W-1:0] Q  
//);
//    always_ff @(posedge clk)begin
//        if(reset)
//            Q <= 0;
//        else if (load)
//            Q <= L;
//        else if (clear)
//            Q <= 0;
//    end
//endmodule 


module shift_left_register 
 #(parameter W=8)
(
    input logic clk_100M,
    input logic [W-1:0] L,
    input logic reset, load, shift, IN,
    output logic [W-1:0] Q 
);
    always_ff @(posedge clk_100M)begin
        if(reset)
            Q <= 0;
        else if (load)
            Q <= L;
        else if (shift)
            Q <= { Q[W-2:0], IN };
    end
endmodule 

//module shif_in_reg(
//    input logic get_data,
//    input logic clk,
//    input logic en,
//    input logic IN,
//    output logic [39:0] All_Data
//);
//    logic [39:0] Reg_Data;

//    always_ff @(posedge en)begin
//        Reg_Data[39:0] <= {Reg_Data[38:0] , IN};
//    end
    
//    always_ff @(posedge clk)begin
//        if(get_data)
//            All_Data[39:0] <= Reg_Data[39:0];
//    end
//endmodule


//module shif_out_reg(
//    input logic set_data,
//    input logic clk,
//    input logic en,
//    output logic OUT,
//    input logic [39:0] All_Data
//);
//    logic [39:0] Reg_Data;
    
//    always_ff @(posedge en)begin
//        OUT <= Reg_Data[39];
//    end

//    always_ff @(negedge en,posedge set_data)begin   
//        if (en == 0)
//            Reg_Data[39:0] <= {Reg_Data[38:0] , Reg_Data[39]};
//        else
//            Reg_Data[39:0] <= All_Data[39:0];
//    end

//endmodule

module joy_data(
    input logic reset,
    input logic clk,//
    input logic en_trans,//!
    input logic en_recei,//
    input logic data_1byte_ready,//
    input logic [39:0] led_data,
    input logic MISO,//
    output logic MOSI,
    output logic [39:0] ctrl_data,
    output logic data_5byte_ready
);

   // shif_in_reg in_re(data_5byte_ready,clk,en_recei,MISO,ctrl_data);
   // shif_out_reg out_re(data_5byte_ready,clk,en_trans,MOSI,led_data);
   shift_left_register #(40) in_re
   (clk,40'b00000000_00000000_00000000_00000000_00000000,reset,data_5byte_ready,en_trans,MISO,ctrl_data);
   
   //input logic reset, load, shift, IN,

//    bit [2:0] cnt;
//    always_ff @(posedge data_1byte_ready,negedge data_1byte_ready)begin
//        if(cnt == 4 && data_1byte_ready == 1) begin
//            data_5byte_ready <= 1;
//            cnt<= 0;
//        end
//        else if(data_1byte_ready==1)begin
//            cnt <= cnt+1;
//        end
//        else
//            data_5byte_ready <= 0;
//    end
    
endmodule
   
   


////endmodule
//module joy_data(
//    input logic get_data,
//    input logic clk,
//    input logic en,
//    input logic IN,
//    output logic [39:0] All_Data
//);
//    logic [39:0] Reg_Data;
    
//    always_ff @(posedge en)begin
//        Reg_Data[39:0] <= {Reg_Data[38:0] , IN};
//    end
    
//    always_ff @(posedge clk)begin
//        if(get_data)
//            All_Data[39:0] <= Reg_Data[39:0];
//    end
//endmodule
