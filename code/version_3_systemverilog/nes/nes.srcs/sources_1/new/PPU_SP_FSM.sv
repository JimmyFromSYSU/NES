
//////////////////////////////////////////////////////////////////////////////////// SPRITE
module PPU_SPRITE_FSM(
    input bit clk,
    input bit reset,
    input bit start_sp,
    output bit end_sp,
    input bit [7:0] Y,
    //
    output bit [7:0] OAM_addr,
    input bit [7:0] OAM_data,
    output bit [1:0] palette_index,
    
    // for palette 
    output bit [12:0] vrom_index,
    output bit start_palette,
    output bit [7:0] line_X,
    input bit end_palette ,
    output bit OAM_read,
    output bit [2:0] state
);

    enum bit [2:0] {WAIT,OAM_Y,OAM_V,OAM_A,OAM_X,WAIT_LOW,DONE_ONE}  next_state;
       
    always_ff @(posedge clk)begin
        if(reset==1'b1) state <= WAIT;
        else state <= next_state;
    end
    
    bit [7:0] data_y;
    bit [7:0] data_x;
    bit [7:0] data_index;
    bit [7:0] data_attr;
    bit valid_y;
    bit  mode8_8 ;
    //assign mode8_8= ((conf & 0x20)==0);
    assign mode8_8=0;
    
    assign palette_index[1:0] = data_attr[1:0]; 
    
    assign line_X = data_x;
    
    
    //assign data_index = 10;
    
    //assign valid_y = 1;
    always_comb begin
        if(mode8_8==1'b1)begin
            if(Y>=data_y && Y<data_y+8) valid_y= 1;
            else valid_y= 0;
        end
        else begin
            if(Y>=data_y && Y<data_y+16) valid_y= 1;
            else valid_y= 0;
        end
    end
    
    bit [12:0] page ;
    assign page =(data_index&1)? 13'h1000:0;
    bit [12:0] t_index;
    assign t_index =(data_index >> 1);
//    always_ff @(negedge clk)begin
//        if(state == OAM_A)begin
//            if(mode8_8==1'b1)vrom_index <= (data_index<<4) + Y-data_y;
//            else begin
//                if(Y<data_y+8) vrom_index <= page +(t_index << 5) + Y-data_y;
//                else  vrom_index <= page +(t_index << 5) +16 + (Y-(data_y+8));
//            end
//        end
//    end
    always_comb begin
            if(mode8_8==1'b1)vrom_index = (data_index<<4) + Y-data_y;
            else begin
                if(Y<data_y+8) vrom_index = page +(t_index << 5) + Y-data_y;
                else  vrom_index = page +(t_index << 5) +16 + (Y-(data_y+8));
            end
    end  
    ///////////////////////////
    bit sp_cnt_start;
    bit [7:0] wait_sp_q;
    bit done_one_sprite;
    counter #(8) sp_time
    (
         .P(8'd64),//nfxz
         .Q(wait_sp_q),
         .reset(reset),
         .load(sp_cnt_start),
         .en(done_one_sprite),//next_state == DONE_ONE),
         .clk(~clk)
     );
     
    assign done_4_sp = (wait_sp_q == 8'b0);
    
    bit [7:0] sp_index ;
    assign sp_index = wait_sp_q-1;
    
    
    
   // nextstate  
    always_comb begin
        next_state = WAIT;
        case(state) 
            WAIT: if(start_sp==1'b1)next_state = OAM_Y; 
            OAM_Y: if(valid_y==1'b1)next_state = OAM_V; else next_state=DONE_ONE;
            OAM_V: next_state = OAM_A; 
            OAM_A: next_state = OAM_X; 
            OAM_X: next_state = WAIT_LOW; 
            WAIT_LOW: if(end_palette)next_state = DONE_ONE; else next_state = WAIT_LOW;
            DONE_ONE: if(done_4_sp)next_state = WAIT;  else next_state = OAM_Y;
            default: next_state = WAIT;
        endcase
       end
   
   
   
       
    always_comb begin
        end_sp = 0;
        sp_cnt_start = 0;
        start_palette = 0;
        case(state)
            WAIT: sp_cnt_start = 1;
            OAM_V:start_palette = 1;
            DONE_ONE: if(next_state == WAIT) end_sp = 1;
        endcase 
    end
    
   // operation
    always_comb begin
        //OAM_addr = 0;
        OAM_read = 0;
        done_one_sprite = 0;
        case(state)  
            OAM_Y: begin OAM_addr = sp_index * 4 ; OAM_read = 1; end
            OAM_V: begin OAM_addr = sp_index * 4 +1;OAM_read = 1; end
            OAM_A: begin OAM_addr = sp_index * 4 + 2;OAM_read = 1; end
            OAM_X: begin OAM_addr = sp_index * 4 + 3;OAM_read = 1; end
            DONE_ONE :done_one_sprite = 1;
            //WAIT_LOW:
            default: OAM_addr = 0;
        endcase
    end
    //assign data_index = 126<<1+1;
    
    always_ff @(negedge clk) begin
        if(state == WAIT)begin
            data_y <= 0;
            data_index <= 0;
            data_attr <= 0;
            data_x <= 0;
        end
        else if(state == OAM_Y)data_y <= OAM_data;
        else if(state == OAM_V)data_index <= OAM_data;
        else if(state == OAM_A)data_attr <= OAM_data;
        else if(state == OAM_X)data_x <= OAM_data; 
        else begin end
    end
endmodule





