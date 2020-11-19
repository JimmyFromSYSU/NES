`timescale 1ns / 1ps
//`include "DataType.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2015 03:08:43 PM
// Design Name: 
// Module Name: PPU
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

//PPU chip test
//module PPU_chip_test();
//endmodule
//
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/05 21:41:09
// Design Name: 
// Module Name: PPU_TEST
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


module PPU(
    input bit reset,
    input bit clk_mem, // 100M for memory access by other component such as CPU
    input bit clk, // for PPU state transform and clock
    input bit [7:0] ppu_y,
    // cpu connect
    input bit en,
    input bit write,
    input bit read,
    input bit [7:0] din,
    output bit [7:0] dout,
    input bit [15:0] addr

    //,output bit fetch  
    //,input bit [7:0] X
    ,output bit NMI
    ,input bit Hsync
    ,input bit Vsync
    ,input bit [7:0] Y
    ,input bit valid
    
    
    // scanline buffer
    ,output bit [8:0] sb_addr
    ,output bit [5:0] sb_data 
    ,output bit sb_write
    ,output bit [2:0] main_state
    ,output bit [2:0] bg_state
    ,output bit [2:0] sp_state
    ,output bit [2:0] p_state
    ,output bit end_palette
    
    ,output bit [15:0] addr_2006
    ,output bit [7:0] addr_2006_low
    ,output bit [7:0] addr_2006_hig
    ,output bit [7:0] reg2000
    ,output bit [7:0] reg2001
    ,output bit [7:0] reg2002
    ,output bit [7:0] reg2005
    ,output bit [7:0] reg2007
    ,output bit enable_vram 
    ,output bit enable_palette 
    ,output bit write2007
    ,output bit write2006
    ,input bit sel_name[1:0]
    ,output bit [7:0] test,
    
    input bit start_dma,
    output bit read_1,
    output bit finish_dma,
    input bit [7:0] data_1,
    input bit[7:0] din_dma,
    output bit isBg,
    output bit[1:0] palette_pos,
    output bit[15:0] addr_1
);
    bit [7:0] reg2007_v;
    bit [7:0] reg2007_p;
    
    assign addr_2006_low[7:0]  = 0;
    assign addr_2006_hig[7:0]  = 0;
//         bit [7:0] reg2000;
//         bit [7:0] reg2001;
//         bit [7:0] reg2002;
//         bit [7:0] reg2005;
//         bit [7:0] reg2007;
//         bit write2006 ,write2007;
//         bit [15:0] addr_2006 ;
//         bit [7:0] addr_2006_low;
//         bit [7:0] addr_2006_hig;
//         bit enable_vram;
//         bit enable_palette;
         
    bit [7:0] X;

    bit [7:0] color_index;
    bit [4:0] selPalette;
    
    bit en_once;
    
    bit flag;
    always_ff @(negedge Hsync,negedge Vsync)begin
        if(~Vsync) flag = 0;
        else flag <= ~flag;
    end
    
    assign sb_write = en_once; // from low_bit_fsm
    always_comb begin 
        sb_addr[8] = ppu_y[0];      
        sb_addr[7:0] = X;
        sb_data = color_index[5:0];
    end


    
    //
    bit [15:0] vAddr;
    bit [7:0] vData;
    
    
    bit [1:0] palette_index_bg;
    bit [1:0] palette_index_sp;
   // bit [1:0] palette_pos;
    //bit isBg;
    

    always_comb begin 
        selPalette[4] = ~isBg;
        if(en_once)
            selPalette[1:0] = palette_pos[1:0];
        else selPalette[1:0] = 0;
        
        if(isBg)selPalette[3:2] =  palette_index_bg;
        else selPalette[3:2] =  palette_index_sp;
    end
    
    //////////////////////////////////////////////////////////////////////  RAM
    bit [7:0] OAM_addr;
        bit [7:0] OAM_data;
        bit OAM_read;
        
        bit[15:0] addr_2;
        bit[7:0] data_2;
        bit write_2;
        //output bit read_1,
        //output bit finish_dma,
        //input bit [7:0] data_1,
        //input bit[7:0] din,
        //output bit[15:0] addr_1,
        
        DMA dma(
            .clk(clk),
            .start(start_dma),

            .read_1(read_1),
            .finish_dma(finish_dma),
            .data_1(data_1),
            .din(din_dma),
            .addr_1(addr_1),
            
            .addr_2(addr_2),
            .data_2(data_2),
            .write_2(write_2)
        );
        
        
        OAM oam(
                .addra(addr_2),
                .dina(data_2),
                .ena(1'b1),   //
                .wea(write_2),   //
                .clka(clk_mem),
                
                .addrb(OAM_addr[7:0]),
                .doutb(OAM_data[7:0]),
                .enb(OAM_read),   
                .clkb(clk_mem)
        );
        
        bit [12:0] tmp_vrom_addr;
        always_comb begin
                if(read2007) tmp_vrom_addr = addr_2006[12:0]-1;
                else tmp_vrom_addr = addr_2006[12:0];
        end
         /////////////////////////////////////////////////////////////////////    REGISTER
         //always_ff @(posedge clk_mem)begin if(write == 1'b1 && addr==16'h2000 )reg2000[7:0] <= din; end
         //always_ff @(posedge clk_mem)begin if(write == 1'b1 && addr==16'h2001  )reg2001[7:0] <= din; end
         always_ff @(negedge clk)begin if(write == 1'b1 && addr==16'h2000 )reg2000[7:0] <= din; end
         //always_ff @(negedge clk)begin if(write == 1'b1 && addr==16'h2001  )reg2001[7:0] <= din; end
         always_ff @(negedge clk)begin if(write == 1'b1 && addr==16'h2005  )reg2005[7:0] <= din; end
//         always_comb begin
//               reg2000[0] = sel_name[0];
//               reg2000[1] = sel_name[1];
//               reg2000[7:2] = 0;
//                 end;
                 
 
         
         always_comb begin
               //reg2002[7] = ~valid; //nfxz
               reg2002[7] = 1'b1;
               reg2002[6:0] =  0;
         end
         
         assign  write2006 = ( (write == 1'b1) && (addr==16'h2006) );
         assign  write2007 = ( (write == 1'b1) && (addr==16'h2007) );
         assign  read2007 =  ( (read == 1'b1) && (addr==16'h2007) );

        bit flip;

          bit [15:0] addr_2006_tmp;
          always_ff @(posedge clk)begin
                addr_2006 <= addr_2006_tmp;
          end
          always_ff @(negedge clk)begin
                if(write2006)begin
                    if(flip == 0)begin
                        flip <= 1;
                        addr_2006_tmp [15:8] <= din;
                    end
                    else begin
                        flip <=0;
                        addr_2006_tmp[7:0] <= din;
                    end
                end
                else if((write2007) || read2007) begin
                    addr_2006_tmp <= addr_2006_tmp + 1;
                    flip <=0;
                end
          end
          bit enable_vrom;
          bit [8:0] tmp_vrom_data;
           always_comb begin
                 if((addr==16'h2002)) dout = reg2002;
                 else if((addr==16'h2007)) begin
                    if(enable_palette) begin
                        reg2007 = reg2007_p;
                        dout = reg2007_p;
                    end
                    else if(enable_vrom)begin
                        reg2007 = tmp_vrom_data;
                        dout = tmp_vrom_data;
                        //tmp_vrom_addr = 
                    end
                    else begin
                        reg2007 = reg2007_v;
                        dout = reg2007_v;
                    end
                 end
                 else dout = 0;
           end
        ////////////////////////////////////////////////////////////////////////////////// RAM
        assign NMI = ((!Vsync));//&& reg2000[7]); // !!!!! 0x2000_7
        //assign NMI = ((!Vsync) ); // nfxz Ctrl flag
       
        assign enable_vram  = (en&&(addr_2006[15:12] == 4'h2));
        assign enable_palette  = (en&&(addr_2006[15:5] == 11'b0011_1111_000));
        assign enable_vrom = (en && (addr_2006[15:13] == 3'h0));
        Palette p(
            .addra(addr_2006[4:0]), // write
            .dina(din),
            .douta(reg2007_p[7:0]),
            //.ena(1'b1),
            //.wea(1'b0),     //
            .ena(enable_palette),     //                                  
            .wea(write2007),     //           
            .clka(clk_mem),
            
            .addrb(selPalette),
            .doutb(color_index),
            .dinb(0),
            .web(0),     //    
            .enb(1'b1),     //
            .clkb(clk_mem)
        );
    
    bit [7:0] vram_data; //  attr nametable
    bit [11:0] vram_addr ; // calc by PPU_BG_FSM
    // write or read by cpu  nametable + attribute

    bit [7:0] vram_out_tmp;
    VRAM vram(
        .addra(addr_2006[11:0]),
        .douta(reg2007_v[7:0]),
        .dina(din),
        .ena(enable_vram),   //                      
        .wea(write2007),     //                         //nfxz
        //.wea(1'b0),     //
        //.ena(1'b1),    ////////////////////important?
        .clka(clk_mem),
        
        .addrb(vram_addr[11:0]),
        .doutb(vram_data[7:0]),
        .dinb(8'b0000_0000),
        .enb(1'b1),   
        .web(1'b0),   
        .clkb(clk_mem)
    );
    
   ///////////////////////////////////////////////////////////////////
    bit start_bg,end_bg,start_sp,end_sp;
    bit start_palette_bg,start_palette_sp;

    //bit end_palette;
    bit start_palette;
    //temp
    bit [12:0] vrom_index_bg;
    bit [12:0] vrom_index_sp;
    bit [12:0] vrom_index;
    bit [7:0] line_X_bg;
    bit [7:0] line_X_sp;
    bit [7:0] line_X;
    bit [12:0]vrom_addr;
    always_comb begin
        if(isBg) begin
            start_palette = start_palette_bg;
            vrom_index = vrom_index_bg;
            line_X = line_X_bg;
        end
        else begin
            start_palette = start_palette_sp;
            vrom_index = vrom_index_sp;
            line_X = line_X_sp;
        end
    end
    
    //////////////////////////////////////////////////////////////////////  FSM
    bit [1:0] nt_index;
    PPU_BG_FSM pbf(
        .clk(clk),
        .reset(reset),
        .start_bg(start_bg),
        .end_bg(end_bg),
        // get vram data
        .vram_addr(vram_addr),
        .vram_data(vram_data),
        .end_palette(end_palette),
        .palette_index(palette_index_bg),
        .name_table_index(nt_index[1:0]),
        //.name_table_index(2'b00), //nfxz
        // for palette
        .vrom_index(vrom_index_bg),
        .start_palette(start_palette_bg),
        .line_X(line_X_bg),
        .scroll_y(reg2005),
        .Y(ppu_y), /////////////////////////////////////////////////////////////////////////////
        .state(bg_state)

    );
    
    
    PPU_SPRITE_FSM psf(
        .clk(clk),
        .reset(reset),
        .start_sp(start_sp),
        .end_sp(end_sp),
        .Y(ppu_y),
        //
        .OAM_addr(OAM_addr),
        .OAM_data(OAM_data),
        .OAM_read(OAM_read),
        .palette_index(palette_index_sp),
        
        // for palette 
        .vrom_index(vrom_index_sp),
        .start_palette(start_palette_sp),
        .line_X(line_X_sp),
        .end_palette(end_palette) ,
        
        .state(sp_state)
    );
    
    //PPU_MAIN_FSM
    //PPU_BG_FSM
    //PPU_SPRITE_FSM
    //PPU_LOW_BITS
    bit frame_index_fetch;
    always_ff @(posedge frame_index_fetch)begin
        nt_index <= reg2000[1:0];
    end

    
    PPU_MAIN_FSM pmf( // ctrl
        .clk(clk),
        .frame_index_fetch(frame_index_fetch),
        .reset(reset),
        .NMI((!Vsync)),
        .Vsync(Vsync), // longer than one clk at least
        .Hsync(Hsync|(~flag)),// longer than one clk at least
        
        //
        .isBg(isBg), // to Palette
        
        //
        .start_bg(start_bg),
        .end_bg(end_bg),
        .start_sp(start_sp),
        .end_sp(end_sp),
        .state(main_state)
    );
    

    PPU_LOW_BITS plb(
        .clk(clk),
        .reset(reset),
        .clk_mem(clk_mem),
        .start_palette(start_palette),
        
        //
        .index(vrom_index),
        .line_X(line_X),
        .palette_pos(palette_pos),
        .finish_palette(end_palette),
        .en_once(en_once),
        .X(X),
        .tmp_vrom_data(tmp_vrom_data),
        .tmp_vrom_addr(tmp_vrom_addr),
        .state(p_state)
       // .vrom_addr(vrom_addr)
    );

   //assign test = reg2000[7:0];
   assign test = vram_addr[7:0];
    
endmodule


