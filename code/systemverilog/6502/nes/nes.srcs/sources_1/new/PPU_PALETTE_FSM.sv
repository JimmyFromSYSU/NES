`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/04/09 13:24:11
// Design Name: 
// Module Name: PPU_PALETTE_FSM
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

//////////////////////////////////////////////////////////////////////////////////// PALETTE
module selectLowBit(
    input bit [7:0] f,
    input bit [7:0] s,
    input bit [2:0] select,
    output bit [1:0] out
);
    always_comb begin
        out[0] = f[select];
        out[1] = s[select];
    end
endmodule

module PPU_LOW_BITS(
    input bit clk,
    input bit clk_mem,
    input bit reset,
    input bit start_palette,
    
    //
    input bit [12:0] index,
    input bit [7:0] line_X,
    output bit [1:0] palette_pos,
    output bit finish_palette,
    output bit en_once, // for data save into scan line
    output bit [7:0] X,
    output bit [2:0] state,
    //output bit [7:0] first_bit,
    //output bit [12:0] vrom_addr
    //output bit [2:0] sel
    output  bit [7:0] tmp_vrom_data,
    output  bit [12:0] tmp_vrom_addr
);
    bit finish_one_palette;
    assign en_once = finish_one_palette ;
    bit [7:0] first_bit;
    bit [7:0] second_bit;
    bit [2:0] sel;
    assign sel[2:0] =  wait_palette_q[2:0];
    
    selectLowBit slb (.f(first_bit),.s(second_bit),.select(sel) ,.out(palette_pos));
    
    bit [12:0] vrom_addr;//
    bit [7:0] vrom_byte; //error
   
    VROM vrom (.addra(vrom_addr),.douta(vrom_byte),.ena(1'b1),.clka(clk_mem),
                .addrb(tmp_vrom_addr),.doutb(tmp_vrom_data),.enb(1'b1),.clkb(clk_mem));


    enum bit [2:0] {WAIT,VROM_1,VROM_2,PALETTE}  next_state;
       
    always_ff @(posedge clk)begin
        if(reset == 1'b1) state <= WAIT;
        else state <= next_state;
    end
    bit palette_load_x;
    bit start_loop;
    auto_add #(8) x_pos
    (
        .P(line_X),
        .Q(X),
        .reset(reset),
        .load(palette_load_x),
        .en(finish_one_palette),
        .clk(clk)
    );

    bit palette_cnt_start;    
    bit [7:0] wait_palette_q;
    counter #(8) palette_time
    (
         .P(8'd7),
         .Q(wait_palette_q),
         .reset(reset),
         .load(palette_cnt_start),
         .en(finish_one_palette),
         .clk(clk)
     );
     
     assign done_8_palette = (wait_palette_q == 0);



   // nextstate  
    always_comb begin
        next_state = WAIT;
        case(state) 
        //WAIT,VROM_1,VROM_2,PALETTE
            WAIT: if(start_palette)next_state = VROM_1; 
            VROM_1: next_state = VROM_2; 
            VROM_2: next_state = PALETTE; 
            PALETTE: 
                if(done_8_palette) next_state = WAIT;  
                else next_state = PALETTE;
            default: next_state = WAIT;
        endcase
       end
   
   //read operate
   always_ff @(negedge clk)begin
         case(state) 
            VROM_1: first_bit <= vrom_byte;
            VROM_2: second_bit<= vrom_byte;
            default:begin
                first_bit <= first_bit;
                second_bit <= second_bit;
            end
         endcase
   end
   
   // operation
    always_comb begin
        finish_palette = 0;
        finish_one_palette = 0;
        palette_cnt_start = 0;
        vrom_addr = 0;
        palette_load_x=0;
        case(state) 
            WAIT: finish_palette = 1;
            VROM_1 :begin
                palette_cnt_start = 1;
                vrom_addr = index;
            end
            VROM_2: begin
                vrom_addr[12:0] = (index[12:0] + 13'b0_0000_0000_0000_1000);
                if(next_state == PALETTE)palette_load_x = 1;
            end
            PALETTE: begin
                if(next_state == WAIT) finish_palette = 1;
                finish_one_palette = 1;
            end
            //default: next_state = WAIT_V;
        endcase
    end
endmodule
