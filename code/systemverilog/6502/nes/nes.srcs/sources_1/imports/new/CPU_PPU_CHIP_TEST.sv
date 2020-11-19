`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/10 21:07:56
// Design Name: 
// Module Name: CPU_PPU_CHIP_TEST
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
module selectData(
    input bit [5:0] data[512],
    input bit [8:0] select,
    output bit [5:0] out);
    
always_comb
    out[5:0] = data[select][5:0];
endmodule 


module saveData(
    output bit [5:0] data[512],
    input bit [8:0] select,
    input bit [5:0] in,
    input bit clk,
    input bit write);
    
    always_ff @(posedge clk)
        if(write)data[select][5:0] <= in[5:0];
endmodule


module MY_SCAN_LINE_BUF (
    input bit clk,
    input bit [8:0] addra,
    output bit [5:0] douta,

    input bit [8:0] addrb,
    input bit [5:0] dinb,
    input bit web
);
    bit [5:0] data[512];
    selectData sel_d (.data(data),.select(addra),.out(douta));
    saveData save_d(.data(data),.select(addrb),.in(dinb),.clk(clk),.write(web));
endmodule 


module CPU_PPU_CHIP_TEST(
    input bit clk,
    output bit [15:0] led,
    input bit [15:0] sw,
    output bit [6:0] seg,
    output bit [7:0] an, 
        output bit dp,
    output bit [3:0] vgaRed,
    output bit [3:0] vgaBlue,
    output bit [3:0] vgaGreen,
    input logic MISO,
    output logic SS,
    output logic MOSI,
    output logic SCK,
    
    output bit Hsync,
    output bit Vsync
);
        bit reset ;
        assign reset = sw[0];
        bit nclk;
       // assign led[15:0] = sw[15:0] ;
         bit [31:0] count;
       
        assign led[15:0] = count[15:0];
        bit write;
        bit [7:0] dout;
        bit en;//,write;
        bit [15:0] addr; 
        bit [7:0] din;
        
        bit [7:0] din_ppu_reg;
        bit [5:0] cover_check_data; //
        bit [8:0] vga_scan_index;
        
        
        //ppu write line
        bit [8:0] ppu_line_addr;
        bit [5:0] ppu_line_data;
        bit ppu_line_write;
        
        bit [11:0] RGB ;
        bit [5:0] color_index;

        bit valid;
 
        bit [7:0] h_c;
        bit [7:0] v_c;

        bit [2:0] main_state;
        bit [2:0] bg_state;
        bit [2:0] sp_state;
        bit [2:0] p_state;

        bit end_palette;
        
        bit [7:0] ppu_y;
        
        //bit [31:0] count;

        bit [4:0] state;
                
        bit fetch;
        
        bit [7:0] INS;
        
        bit [5:0] ins_name;
        bit [3:0] addr_mode;
        
        bit nmi_status;
        bit nmi;    
            
        bit [7:0] A,X,Y;
        bit [7:0]SP;
        bit [15:0] PC;
        bit [7:0] STATUS;
                
        bit [7:0] din_prom,din_pram;
        //bit write,en;
        
        divide_16 div16(clk,nclk);

        ///////////////////////////////////////////////////////////////////////////////////////////////////  PPU

        bit ppu_en;
        bit ppu_write;
        bit [15:0] ppu_addr;
        always_comb begin
                ppu_write = write;
                ppu_en = en;
                ppu_addr = addr;
        end
         bit read;  
        bit read_1;
        bit finish_dma;
        bit [7:0] data_1;
        //bit[7:0] din ;
        bit[15:0] addr_1 ;
        bit start_dma = ((addr[15:0]==16'h4014)&&en&&write);
        bit isBg;
        bit[1:0] palette_pos;
        PPU ppu_test(
                  //input bit nmi,
                  .isBg(isBg),
                  .palette_pos(palette_pos),
                  .reset(0),  //nfxz
                  .clk_mem(clk), // 100M for memory access by other component such as CPU
                  .clk(nclk), // for PPU state transform and clock
                  .ppu_y(ppu_y),
                  .read(read),
                  
                  // cpu connect  !!!!!!!!!!!!
                  //.en(0),
                 // .write(0),
                  .en(ppu_en),//nfxz
                  .write(ppu_write),//nfxz
                  .din(dout),
                  .dout(din_ppu_reg),
                  .addr(ppu_addr),
                  
                  //,output bit fetch  
                  .NMI(nmi),
                  .Hsync((~v_valid)|Hsync),
                  .Vsync(Vsync),
                  .Y(v_c),
                  
                  .valid(v_valid),
                  
                  
                  // scanline buffer
                  .sb_addr(ppu_line_addr),
                  .sb_data(ppu_line_data),
                  .sb_write(ppu_line_write),
                  
                  
                  //state
                  .main_state(main_state),
                  .bg_state(bg_state), 
                  .sp_state(sp_state),        
                  .p_state(p_state),
                  
                  .sel_name({sw[15],sw[14]}),

                  .end_palette(end_palette),
                  
                  
                  .start_dma(start_dma),
                  .read_1(read_1),
                  .finish_dma(finish_dma),
                  .data_1(data_1),
                  .din_dma(dout),
                  .addr_1(addr_1)
              );
                   ////////////////////////////////////////////////////////////////////////////////////   VGA
        
        COLOR_TABLE  color_t (.addra(color_index),.douta(RGB),.ena(1'b1),.clka(clk));

        assign vga_scan_index [8] = v_c[0];
        assign vga_scan_index [7:0] = h_c[7:0];

//        SCAN_LINE_BUF slb (
//            .addra(vga_scan_index),.clka(clk),.dina(6'b0),.douta(color_index[5:0]),.ena(1'b1),.wea(1'b0), // for vga
//            .addrb(ppu_line_addr),.clkb(clk),.dinb(ppu_line_data),.doutb(cover_check_data),.enb(1'b1),.web(ppu_line_write)  // for ppu
//        );
        
        MY_SCAN_LINE_BUF mslb (
            .clk(clk),
            .addra(vga_scan_index),.douta(color_index[5:0]), // for vga
            .addrb(ppu_line_addr),.dinb(ppu_line_data),
            .web(ppu_line_write&&(palette_pos[0]||palette_pos[1]||isBg))  // for ppu
        );
        
//        assign vgaRed = RGB[3:0];
//        assign vgaGreen = RGB[7:4];
//        assign vgaBlue = RGB[11:8];
        
        always_comb begin
            if(valid)begin
                vgaRed = RGB[3:0];
                vgaGreen = RGB[7:4];
                vgaBlue = RGB[11:8];
            end
            else begin
                vgaRed = 0;
                vgaGreen = 0;
                vgaBlue = 0;
            end
        end
     
        vga_sig vs(
            .Hsync(Hsync),
            .Vsync(Vsync),
            .h_c(h_c),
            .v_c(v_c),
            .valid(valid),
            .v_valid(v_valid),
            .ppu_y(ppu_y),
            .clk(clk),
            .reset(0)
        );
        
        //////////////////////////////////////////////////////////////////////////////////////////// CPU
        bit cpu_final_clk;
        bit cpu_clk;
        
        divide_cpu div_cpu (clk,cpu_clk);     

        
        always_comb begin
               cpu_final_clk = cpu_clk;
        end
        bit cpu_nmi ;
        
        bit[3:0] mask_nmi;
        always_ff @(posedge reset, posedge nmi)begin
            if(reset==1'b1)mask_nmi <= 2'b10;
            else if(mask_nmi>0) mask_nmi <= (mask_nmi-1);
        end
       always_comb begin
            if(mask_nmi>0)cpu_nmi = 0;
            else 
                cpu_nmi = nmi;
       end
        bit final_nmi;
        always_ff @(posedge cpu_nmi)begin
            final_nmi <= ~ final_nmi;
        end
        
         
           CPU6502 cpu_test(
               //.start_dma(start_dma),
                //.end_dma(finish_dma),
                .reset(reset), //nfxz
                .nmi(final_nmi), //nfxz 
                //.clk((nclk &&(~sw[15]))),//nfxz
                .clk(nclk),//nfxz
                .en(en), .write(write),
                .read(read),
                .din(din),
                .dout(dout),
                .addr(addr)
                ,.fetch(fetch)
                ,.INS(INS)
                ,.PC(PC)
                ,.STATUS(STATUS)
                ,.ins_name(ins_name)
                ,.A(A)
                ,.state(state)
                ,.addr_mode(addr_mode)
                ,.X(X),.Y(Y)
                ,.SP(SP) 
                ,.nmi_status(nmi_status)
            );
            
            //PPU_REG ppu_reg(.addra(addr[2:0]),.douta(din_ppu_reg),.dina(dout),.ena((addr[15:13]==3'b001)&&en),.wea(write),.clka(clk));
            PRAM pram(
            .addra(addr[10:0]),.douta(din_pram),.dina(dout),.ena((addr[15:13]==3'b0)&&en),.wea(write),.clka(clk),
            .addrb(addr_1[10:0]),.doutb(data_1),.dinb(0),.enb(read_1),.web(0),.clkb(clk)
            );
            
            
            PROM prom (.addra(addr[14:0]),.douta(din_prom),.ena(addr[15]&&en),.clka(clk));
            bit [7:0] btn_dout;
            always_comb begin
                if(addr[15]&&en) din = din_prom;
                //else if( (addr[15:13]==3'b001)&&en) din = din_ppu_reg;
                else if( (addr[15:0]>=16'h2000 && addr[15:0]<=16'h2007)&&en) din = din_ppu_reg;
                else if( (addr[15:0]==16'h4017)&&en) din = 8'h40;  //joystick
                else if( (addr[15:0]==16'h4016)&&en) din = btn_dout;  //joystick
                else if( (addr[15:13]==3'b0)&&en) din = din_pram;
                else din = 8'b0;
            end
            
            always_ff @(posedge fetch)
                count <= count + 1;  
            
        bit [3:0] show[8];
                    // left -> right
       assign show[7][3:0] = A[7:4];
       assign show[6][3:0] = A[3:0];
       
       assign show[5][3:0] = STATUS[7:4];
       assign show[4][3:0] = STATUS[3:0];
                
       assign show[3][3:0] = PC[15:12];
       assign show[2][3:0] = PC[11:8];
       assign show[1][3:0] = PC[7:4];
       assign show[0][3:0] = PC[3:0];
       
       show_num sn(
            .clk(clk),
            .seg(seg),
            .an(an), 
            .dp(dp),
            .show(show)
       ); 
       
       
       button_input bi(
           .MISO(MISO),
           .SS(SS),
           .MOSI(MOSI),
           .SCK(SCK),

           .read(read),
           .write(write),
           .din(dout),
           .dout(btn_dout),
           .addr(addr),
           .sw(sw),
           .clk(nclk),
           .clk100M(clk)
       );

endmodule



