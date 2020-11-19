`timescale 1ns / 1ps
//module test();
//    bit [15:0] sw;
//    bit [15:0] led;
//    bit clk;
//    bit [3:0] vgaRed;
//    bit [3:0] vgaBlue;
//    bit [3:0] vgaGreen;
//    bit Hsync;
//    bit Vsync;
//    initial begin
//        sw= 16'b0000_0000_1000_1100;
//        clk = 0;
//        repeat(1000000) #5 clk = ~clk;
//        #1 $finish;
//    end

//    vga vgatest(vgaRed,vgaBlue,vgaGreen,Hsync,Vsync,sw,led,clk);
//endmodule :test



module vga_chip_test(
    output bit [3:0] vgaRed,
    output bit [3:0] vgaBlue,
    output bit [3:0] vgaGreen,
    output bit Hsync,
    output bit Vsync,
    //input bit [15:0] sw,
    //output bit [15:0] led,

    input bit clk
);
    bit [11:0] h_c;
    bit [11:0] v_c;
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

module vga_sig(
    output bit Hsync,
    output bit Vsync,
    output bit [7:0] h_c,
    output bit [7:0] v_c,
    output bit valid,
    output bit v_valid,
    output bit [7:0] ppu_y,
    input bit clk,
    input bit reset
);

    bit [11:0] h_counter;
    bit [11:0] v_counter; 
    
    //bit valid ;
    createHV chv(.clk(clk),.HS(Hsync),.VS(Vsync),.hcounter(h_counter),.vcounter(v_counter));
    
    always_comb begin
        h_c= 0;
        v_c= 0;
        valid= 0;
        v_valid = 0;
        
        if(v_counter >= 12'd31 && v_counter < 12'd511)begin
            v_valid = 1;
            ppu_y = (v_counter - 12'd31)/12'd2 + 1;
            if(h_counter >= 12'd576 && h_counter < 12'd3136) valid=1;
        end
        else begin
            ppu_y = 0;
        end
        
        //if(h_counter >= 12'd576 && h_counter < 12'd3136 && v_counter >= 12'd31 && v_counter < 12'd511)begin   
        //end
        
        if(valid)begin
            h_c = (h_counter - 12'd576)/12'd10; ////////////// problem
            v_c = (v_counter - 12'd31)/12'd2;
        end
    end
    
//    always_ff @(posedge clk)begin
//        if(~valid) h_c <= 0;
//        else begin
//            h_c <= (h_counter - 12'd576)/12'd10;
//            v_c = (v_counter - 12'd31)/12'd2;
//        end
//    end
    
endmodule

module vga(
    output bit [3:0] vgaRed,
    output bit [3:0] vgaBlue,
    output bit [3:0] vgaGreen,
    output bit Hsync,
    output bit Vsync,
    output bit [7:0] h_c,
    output bit [7:0] v_c,
    input bit clk
);
    
    //bit [11:0] h_c;
    //bit [11:0] v_c;
    bit valid;
    vga_sig vs(
        .Hsync(Hsync),
        .Vsync(Vsync),
        .h_c(h_c),
        .v_c(v_c),
        .valid(valid),
        .clk(clk)
    );

    
    
    bit [11:0] color;
    //IMG_BUFFER img(.addra(v_c*256+h_c),.douta(color),.ena(1),.clka(clk));
    always_comb begin
        vgaRed = 0;
        vgaGreen = 0;
        vgaBlue = 0;
        if(valid)begin
            vgaRed = color[3:0];
            vgaGreen = color[7:4];
            vgaBlue = color[11:8];
        end
    end 

endmodule
