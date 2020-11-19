`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/09 13:26:36
// Design Name: 
// Module Name: PPU_CHIP_TEST
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




module PPU_CHIP_TEST(
    input logic clk,
    output logic [15:0] led,
    input logic [15:0] sw,
    //output logic [6:0] seg,
    //output logic [7:0] an, 
    output logic [3:0] vgaRed,
    output logic [3:0] vgaBlue,
    output logic [3:0] vgaGreen,
    output logic Hsync,
    output logic Vsync
    //,
    
    //output logic dp
);
    assign led[15:0] = sw[15:0];

logic reset,nclk;
//    //logic [7:0] dout;

divide_16 div16(clk,nclk);

assign reset = 0;

//ppu write line
logic [8:0] ppu_line_addr;
logic [5:0] ppu_line_data;
logic ppu_line_write;
logic end_palette;

logic valid;
logic [7:0] h_c;
logic [7:0] v_c;

logic [11:0] RGB ;
logic [5:0] color_index;

//    logic [2:0] main_state;
//    logic [2:0] bg_state;
//    logic [2:0] sp_state;
//    logic [2:0] p_state;
//    logic [7:0] test;

logic [7:0] ppu_y;

logic [8:0] vga_scan_index;
assign vga_scan_index [8] = v_c[0];
assign vga_scan_index [7:0] = h_c[7:0];

logic [5:0] cover_check_data; //
logic cover_bg;
assign cover_bg = 1;

PPU ppu_test(
    //input logic nmi,
    .reset(reset),
    .clk_mem(clk), // 100M for memory access by other component such as CPU
    .clk(nclk), // for PPU state transform and clock
    .ppu_y(ppu_y),
    // cpu connect  !!!!!!!!!!!!
    .en(1'b0),
    .write(1'b0),
    .din(8'b0),
    .dout(dout),
    .addr(16'b0),
    
    //,output logic fetch  
    //,input logic [7:0] X
    .NMI(nmi),
    .Hsync((~v_valid)|Hsync),
    .Vsync(Vsync),
    .Y(v_c),
    .valid(v_valid),
    
    
    // scanline buffer
    .sb_addr(ppu_line_addr),
    .sb_data(ppu_line_data),
    .sb_write(ppu_line_write),
    
    .main_state(main_state),
    .bg_state(bg_state), 
    .sp_state(sp_state),        
    .p_state(p_state),
    .end_palette(end_palette),
    .test(test)
);

COLOR_TABLE  color_t (.addra(color_index),.douta(RGB),.ena(1'b1),.clka(clk));



SCAN_LINE_BUF slb (
   .addra(vga_scan_index),.clka(clk),.dina(6'b0),.douta(color_index[5:0]),.ena(1'b1),.wea(1'b0), // for vga
   .addrb(ppu_line_addr),.clkb(clk),.dinb(ppu_line_data),.doutb(cover_check_data),.enb(cover_bg),.web(ppu_line_write)  // for ppu
);

assign vgaRed = RGB[3:0];
assign vgaGreen = RGB[7:4];
assign vgaBlue = RGB[11:8];

vga_sig vs(
    .Hsync(Hsync),
    .Vsync(Vsync),
    .ppu_y(ppu_y),
    .h_c(h_c),
    .v_c(v_c),
    .valid(valid),
    .v_valid(v_valid),
    .clk(clk)
);
endmodule


