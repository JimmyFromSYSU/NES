`timescale 1ns / 1ps


module createHV(
    input bit clk,
    //input bit reset,
    output bit HS,
    output bit VS,
    output bit [11:0] hcounter,
    output bit [11:0] vcounter
);
    createH ch(.clk(clk),.HS(HS),.counter(hcounter));
    createV cv(.clk(clk),.CE(HS),.VS(VS),.counter(vcounter));
endmodule : createHV

module set_reset(
    input bit set,
    input bit reset,
    output bit sig
);

    always_ff @(posedge set, posedge reset)
        if(set == 1)
            sig <= 0;
        else
            sig <=1;

endmodule : set_reset


module createH(
    input bit clk,
    output bit HS,
    output bit [11:0] counter
);
//    bit [11:0] counter;
    bit set=0,rset=0;
    //bit [11:0] counter;
    set_reset h_s(set,rset,HS);
    assign c_zero = (counter == 12'd0);
    assign c_end = (counter == (12'd384));
    assign c_max = (counter == (12'd3200));
    
    always_ff @(posedge clk)begin
        if (c_max)
            counter <= 0;
        else 
            counter <= counter+1;
    end
    
    always_ff @(posedge clk)begin           
            if(c_zero) 
                set <= 1;
            else if (c_end)
                rset <= 1;
            else begin
                set <= 0;
                rset <= 0;
            end
    end
endmodule : createH


module createV(
    input bit clk,
    input bit CE,
    output bit VS,
    output bit [11:0] counter
);
//    bit [11:0] counter;
    
    bit set=0,rset=0;
   
    set_reset v_s(set,rset,VS);
    
    always_ff @(negedge CE)begin
    
            if (counter==12'd521)
                counter <= 0;
            else 
                counter <= counter+1;
     end   
     always_ff @(negedge CE)begin
            if(counter == 0)
                set <= 1;
            else if (counter == 2)
                rset <= 1;
            else begin
                set <= 0;
                rset <= 0;
            end
    end

endmodule : createV    
