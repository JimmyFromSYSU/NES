///////////////////////////////////////////////////////////////////////////// main
module PPU_MAIN_FSM( // ctrl
    input bit clk, // quick clock , to catch nmi
    input bit reset,
    input bit NMI,
    input bit Vsync, // longer than one clk at least
    input bit Hsync,// longer than one clk at least
    
    //
    output bit isBg, // to Palette
    output bit frame_index_fetch,
    //
    output bit start_bg,
    input bit end_bg,
    output bit start_sp,
    input bit end_sp,
    output bit [2:0] state
);
    enum bit [2:0] {WAIT_V,WAIT_CPU,BG,SPRITE,WAIT_H}  next_state;
    always_ff @(posedge clk)begin
        if(reset==1'b1) state <= WAIT_V;
        else state <= next_state;
    end
    //double stuff
    
    bit cpu_start;
    bit [31:0] wait_cpu_q;
    
    counter #(32) wait_cpu
    (
         .P(32'd10000),
         .Q(wait_cpu_q),
         .reset(reset),
         .load(cpu_start),
         .en(1),
         .clk(clk)
     );
     assign done_cpu = (wait_cpu_q == 0);
     
     
     bit frame_start,en_H;
     
     bit [7:0] wait_frame_q;
     
     counter #(8) wait_frame
     (
          .P(8'd240),
          .Q(wait_frame_q),
          .reset(reset),
          .load(frame_start),
          .en(en_H),
          .clk(clk)
      );
      assign done_frame = (wait_frame_q == 0);
      
    //next_state  
    always_comb begin
        next_state = WAIT_V;
        case(state) 
            WAIT_V: if(NMI==1'b1) next_state = WAIT_CPU;  //else if(~Vsync) next_state = BG;
            WAIT_CPU: if(done_cpu==1'b1) next_state = BG; else next_state = WAIT_CPU;
            //WAIT_CPU: if(done_cpu) next_state = SPRITE; else next_state = WAIT_CPU;
            BG:if(end_bg==1'b1)next_state = SPRITE; else next_state = BG;
            SPRITE:if(end_sp==1'b1) next_state = WAIT_H; else next_state = SPRITE;
            WAIT_H:
                if(done_frame==1'b1) next_state = WAIT_V; 
                else if((~Hsync)==1'b1) next_state = BG;
                
                else next_state = WAIT_H;
            default: next_state = WAIT_V;
        endcase
    end
    
    // operation
    always_comb begin
            frame_start=0;
          cpu_start = 0;
          start_bg = 0;
          start_sp = 0;
          en_H = 0; // count frame
          isBg=0;
          frame_index_fetch = 0;
          case(state) 
                WAIT_V: if(NMI==1'b1) begin
                    cpu_start = 1;
                    frame_start = 1;
                end
                WAIT_CPU: if(next_state == BG)  begin
                    start_bg = 1;
                    frame_index_fetch = 1;
                end
                BG: begin 
                    isBg = 1; 
                    if(next_state == SPRITE)  start_sp = 1;
                end
                SPRITE: begin 
                    isBg = 0;
                    if(next_state == WAIT_H) en_H  = 1;
                end
                WAIT_H:if(next_state == BG)  start_bg = 1;
                //default: ;
          endcase
    end

endmodule

