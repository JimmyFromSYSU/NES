`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/06 14:06:16
// Design Name: 
// Module Name: TEST_VGA
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


module TEST_VGA(

    );
    
    logic  clk;
    
    initial begin
         clk = 0;
         //$monitor("%h",addr);
         repeat (4000000) #5 clk = ~clk;
         //repeat (400000) #5 clk = ~clk;
    end
    logic [3:0] vgaRed,vgaBlue,vgaGreen;
    logic Hsync,Vsync;
    logic [7:0] h_c;
    logic [7:0] v_c;
    vga v(
        .vgaRed(vgaRed),
        .vgaBlue(vgaBlue),
        .vgaGreen(vgaGreen),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .h_c(h_c),
        .v_c(v_c),
        .clk(clk)
    );
endmodule
