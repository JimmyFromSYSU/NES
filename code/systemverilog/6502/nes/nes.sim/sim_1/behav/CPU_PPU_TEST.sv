`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/10 15:52:39
// Design Name: 
// Module Name: CPU_PPU_TEST
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


module CPU_PPU_TEST(

    );    
        logic clk;
        logic [3:0] vgaRed;
        logic [3:0] vgaBlue;
        logic [3:0] vgaGreen;
        logic Hsync,Vsync;
       
        initial begin
            clk = 0;
            //$monitor("%h",addr);
            repeat (100000000) #5 clk = ~clk;
        end
               logic reset, nclk;
        //assign led[15:0] = sw[15:0] ;
        ////cpu access  !!!!!!!!!!!!!!!!!!!!!!
       // logic cpu_en;
        //logic [7:0] cpu_ din;
        //logic cpu_write;
        //logic [7:0] cpu_dout;
        //logic [15:0] cpu_addr;
        logic write;
        logic [7:0] dout;
        logic en;
        logic [15:0] addr; 
        logic [7:0] din;
        logic [7:0] din_ppu_reg;
        logic [5:0] cover_check_data; //
        logic [8:0] vga_scan_index;
        logic cover_bg;
        //initial begin
        //    clk = 0;
            //$monitor("%h",addr);
        //    repeat (100000000) #5 clk = ~clk;
        //end
        
        
        
        //ppu write line
        logic [8:0] ppu_line_addr;
        logic [5:0] ppu_line_data;
        logic ppu_line_write;
        
        logic [11:0] RGB ;
        logic [5:0] color_index;
        // add vga !!!!!!!!!!!!!!! 
        
        logic valid;
        
        logic [7:0] h_c;
        logic [7:0] v_c;
        //logic [7:0] Y;
        
    
        logic [2:0] main_state;
        logic [2:0] bg_state;
        logic [2:0] sp_state;
        logic [2:0] p_state;
        
        logic [7:0] test;
        logic end_palette;
        logic [7:0] ppu_y;
        bit [31:0] count;
                
        
        logic [4:0] state;
                
        logic fetch;
        logic [7:0] INS;
        logic [5:0] ins_name;
        logic [3:0] addr_mode;
        logic nmi_status;
                    
        logic [7:0] A,X,Y;
        logic [7:0]SP;
        logic [15:0] PC;
        logic [7:0] STATUS;
                
                   
        logic [7:0] din_prom,din_pram;
                 
          divide_16 div16(clk,nclk);
          assign reset = 0;       
         //assign reset = sw[15];
        ///////////////////////////////////////////////////////////////////////////////////////////////////  PPU
        logic [15:0] addr_2006;
        logic [7:0] addr_2006_low;
        logic [7:0] addr_2006_hig;
        logic [7:0] reg2000;
        logic [7:0] reg2001;
        logic [7:0] reg2002;
        logic [7:0] reg2005;
        logic [7:0] reg2007;
        logic enable_vram ;
        logic enable_palette; 
        logic write2007;
        logic write2006;
        
        PPU ppu_test(
            //input logic nmi,
            .reset(reset),
            .clk_mem(clk), // 100M for memory access by other component such as CPU
            .clk(nclk), // for PPU state transform and clock
            .ppu_y(ppu_y),
            
            
            // cpu connect  !!!!!!!!!!!!
            .en(en),//nfxz
            .write(write),//nfxz
            .din(dout),
            .dout(din_ppu_reg),
            .addr(addr),
            
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
            
            
            //state
            .main_state(main_state),
            .bg_state(bg_state), 
            .sp_state(sp_state),        
            .p_state(p_state),
            
            
            .addr_2006(addr_2006),
            .addr_2006_low(addr_2006_low),
            .addr_2006_hig(addr_2006_hig),
            .reg2000(reg2000),
            .reg2001(reg2001),
            .reg2002(reg2002),
            .reg2005(reg2005),
            .reg2007(reg2007),
            .enable_vram(enable_vram) ,
            .enable_palette(enable_palette),
            .write2007(write2007),
            .write2006(write2006),
            
            
            //test
            .end_palette(end_palette),
            .test(test)
        );
        ////////////////////////////////////////////////////////////////////////////////////   VGA
        
        COLOR_TABLE  color_t (.addra(color_index),.douta(RGB),.ena(1'b1),.clka(clk));

        assign vga_scan_index [8] = v_c[0];
        assign vga_scan_index [7:0] = h_c[7:0];
        
        
        assign cover_bg = 1;
        
        MY_SCAN_LINE_BUF mslb (
            .clk(clk),
            .addra(vga_scan_index),.douta(color_index[5:0]), // for vga
            .addrb(ppu_line_addr),.dinb(ppu_line_data),.web(ppu_line_write)  // for ppu
        );
        

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
            .clk(clk)
        );
        
        //////////////////////////////////////////////////////////////////////////////////////////// CPU
        
        
         
                
            CPU6502 cpu_test(
            .reset(reset), .nmi(nmi), .clk(nclk),
            .en(en), .write(write),
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
        PRAM pram(.addra(addr[10:0]),.douta(din_pram),.dina(dout),.ena((addr[15:13]==3'b000)&&en),.wea(write),.clka(clk));
        PROM prom (.addra(addr[14:0]),.douta(din_prom),.ena(addr[15]&&en),.clka(clk));
        
        always_comb begin
            if(addr[15]&&en) din = din_prom;
            //else if( (addr[15:13]==3'b001)&&en) din = din_ppu_reg;
            else if( (addr[15:0]>=16'h2000 && addr[15:0]<=16'h2007)&&en) din = din_ppu_reg;
            else if( (addr[15:0]==16'h4016 || addr[15:0]==16'h4017)&&en) din = 8'h40;  //joystick
            else if( (addr[15:13]==3'b000)&&en) din = din_pram;
            else din = 8'b0;
        end
        
        always_ff @(posedge fetch)
            count <= count + 1;  
        
endmodule
