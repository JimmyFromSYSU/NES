//////////////////////////////////////////////////////////////////////////////////// BG
module PPU_BG_FSM(
    input bit clk,
    input bit reset,
    
    input bit start_bg,
    output bit end_bg,
    // get vram data
    output bit [11:0] vram_addr,
    input bit [7:0] vram_data,
    output bit [1:0] palette_index,
    
    // for palette
    output bit [12:0] vrom_index,
    output bit start_palette,
    output bit [7:0] line_X,
    input bit end_palette,
    output bit [2:0] state,
    input bit [7:0] Y,
    input bit [7:0] scroll_y,
    input bit [1:0] name_table_index,
    output bit test
);
    bit [1:0] final_name_table_index;
    bit [7:0] final_Y;
    bit [15:0] tmp_c;
    
    always_comb begin
        if(Y+scroll_y<240)begin
            final_name_table_index = name_table_index;
            final_Y = scroll_y+Y;
        end
        else begin
            final_name_table_index = name_table_index+2;
            final_Y = Y+scroll_y-16'd240;
        end
        
        
    end
    
    enum bit [2:0] {WAIT,ATTR_READ,NAME_READ,WAIT_LOW} next_state;
    bit [1:0] nt_index;
    always_ff @(posedge clk)begin
        if(reset==1'b1) state <= WAIT;
        else state <= next_state;
    end
    
    bit [12:0] vrom_index_tmp;
    bit [7:0] vrom_color_tmp;
    always_ff @(negedge clk)begin
        if(state == NAME_READ)vrom_index_tmp <= vram_data;
        else if(state == ATTR_READ)vrom_color_tmp <= vram_data;
    end
    
    always_comb begin
        vrom_index = 13'h1000+(vrom_index_tmp << 4) + final_Y[2:0]; //////////////////////////////////////////////////////////////
    end
    
    bit [4:0] b_col;
    assign b_col = (wait_name_q)+(wait_attr_q)*4;
    assign line_X = 8*b_col;
    //assign vrom_index = 13'b1000;
    always_comb begin
        if(b_col [1] == 0)begin
            if(final_Y[4] == 0) palette_index = vrom_color_tmp[1:0];
            else palette_index = vrom_color_tmp[5:4];
        end
        else begin
            if(final_Y[4] == 0) palette_index = vrom_color_tmp[3:2];
            else palette_index = vrom_color_tmp[7:6];
        end
    end
    //assign palette_index = 2'b00;
    
    

    bit name_cnt_start;
    bit finish_one_name;
    bit [7:0] wait_name_q;
    counter #(8) name_time
    (
         .P(8'd3),
         .Q(wait_name_q),
         .reset(reset),
         .load(name_cnt_start),
         .en(next_state == NAME_READ),
         .clk(clk)
     );
    assign done_4_name = (wait_name_q == 8'b0);
    
    bit attr_cnt_start;
    bit finish_one_attr;
    bit [7:0] wait_attr_q;
    counter #(8) attr_time
    (
         .P(8'd7),
         .Q(wait_attr_q),
         .reset(reset),
         .load(attr_cnt_start),
         .en(next_state == ATTR_READ),
         .clk(clk)
     );
     assign done_8_attr = (wait_attr_q == 8'b0);
    always_ff @(posedge clk)begin
        if(state == WAIT) nt_index[1:0] <= final_name_table_index[1:0];
    end
   // nextstate  
    always_comb begin
        next_state = WAIT;
        case(state) 
            WAIT: if(start_bg==1'b1) next_state = ATTR_READ; else next_state = WAIT;
            ATTR_READ : next_state = NAME_READ; 
            NAME_READ : next_state = WAIT_LOW; 
            
            WAIT_LOW ://011 
            begin
                if(end_palette == 1'b1) begin
                    if((done_8_attr==1'b1) && (done_4_name==1'b1)) 
                        next_state = WAIT; //
                    else if(done_4_name==1'b1) 
                        next_state = ATTR_READ; // 01
                    else 
                        next_state = NAME_READ; //   02  
                end
                else next_state = WAIT_LOW;
            end
            
            default: next_state = WAIT;
        endcase
       end
   
   // operation
    always_comb begin
        end_bg = 0;
        start_palette = 0;
 
        attr_cnt_start = 0;
        name_cnt_start = 0;

        vram_addr = 0;
        case(state) 
            WAIT: begin
                attr_cnt_start = 1;
            end
            
            WAIT_LOW : begin
                if(next_state == WAIT) begin 
                    end_bg = 1;
                end
            end
            ATTR_READ: begin
                name_cnt_start = 1;
                vram_addr = nt_index[1:0]*12'h400+12'h3C0+final_Y[7:5]*8 + wait_attr_q;
            end             
            NAME_READ: begin
            
            ///////
                
                vram_addr = nt_index[1:0]*12'h400 + (final_Y[7:3]<<5)+b_col;
                start_palette = 1;
            end  
        endcase
    end
    
endmodule
