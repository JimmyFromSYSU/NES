`timescale 1ns / 1ps
//`include "DataType.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2015 03:08:43 PM
// Design Name: 
// Module Name: CPU6502
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
module CPU_chip_test(
    input bit clk,
    output bit [15:0] led,
    input bit [15:0] sw,
    output bit [6:0] seg,
    output bit [7:0] an, 
    output bit dp
);
    

    //A,STATUS,PC,
    bit [31:0] count;
    
    assign led[15:0] = count[15:0];
    
    bit [15:0] addr;
    bit nclk;
    bit [4:0] state;
    bit [7:0] din;
    bit fetch;
    bit [7:0] INS;
    bit [5:0] ins_name;
    bit [3:0] addr_mode;
    bit nmi_status;
    
    
    //test
    bit [7:0] A,X,Y;
    bit [7:0]SP;
    bit [15:0] PC;
    bit [7:0] STATUS;
    bit write;
    bit [7:0] dout;
    
    bit [7:0] din_prom,din_pram;//,din_ppu_reg;
    bit nmi, reset, en;
    bit tclk;
    divide_16 div16(clk,tclk);
    always_comb begin
        if(sw[0] == 0)nclk = tclk;
    end
    assign nmi = 0;
    //assign nclk = sw[0];
    assign reset = sw[15];
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
    
    //assign en = 1;
    show_num sn(
        .clk(clk),
        .seg(seg),
        .an(an), 
        .dp(dp),
        .show(show)
    );  
    
    
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
            else if( (addr[15:13]==3'b000)&&en) din = din_pram;
            else din = 8'b0;
        end
        always_ff @(posedge fetch, posedge reset)    
            if(reset) count <= 0;
            else count <= count + 1;  
        
//        always_ff @(negedge nclk)begin
//            if(count == 20) nmi <= 1;
//            else nmi <= 0;
//        end
        
endmodule





module CPU6502(
    input bit nmi,
    input bit reset,
    input bit clk,
    output bit en,
    output bit write,
    
    input bit [7:0] din,
    output bit [7:0] dout,
    output bit [15:0] addr
    ,output bit fetch
    ,output bit [7:0] INS
    ,output bit [5:0] ins_name
    ,output bit [3:0] addr_mode
    ,output bit [7:0] STATUS 
    ,output bit [7:0] A
    ,output bit [15:0] PC
    ,output bit [4:0] state
    ,output bit nmi_status
    ,output bit [7:0] X,Y
    ,output bit [7:0]SP 
    ,output bit read
    
);
    //bit [7:0] INS;
    
    //bit [7:0] STATUS , A;
    //bit [7:0] X,Y,SP;
    
    //bit [5:0] ins_name;
    //bit [3:0] addr_mode;


    INS_DECODER ins_decoder(
        .INS(INS),
        .ins_name(ins_name),
        .addr_mode(addr_mode)
    );

    bit [7:0] alu_in_1,alu_in_2, alu_out;

    bit addr_done,alu_done;

    //assign read = 1;
    //assign write = 0;
    
    MAIN_LOOP_FSM m_fsm(
            .en(en),
            .read(read),
            .write(write),
            .din(din),
            .dout(dout),
            .reset(reset),
            .nmi(nmi),
            .nmi_status(nmi_status),
            .nmi_start(nmi_start),
            .clk(clk),
            .addr_done(addr_done),
            .alu_done(alu_done),
            .jmp(jmp),
            .jsr(jsr),
            .fetch(fetch),
            .INS(INS),
            .ins_name(ins_name),
            .PC(PC),
            .addr_mode(addr_mode)
            ,.STATUS(STATUS)
            ,.A(A),.X(X),.Y(Y),.SP(SP)
            ,.state(state)
    );  
    

            ADDR_FSM a_fsm(
                    .jmp(jmp),
                    .jsr(jsr),
                    .reset(reset),
                    .nmi_start(nmi_start),
                    .clk(clk),
                    .addr_mode(addr_mode),
                    .fetch(fetch),
                    .addr_done(addr_done),
                    .X(X),
                    .Y(Y),
                    .SP(SP),
                    .PC(PC),
                    .din(din),
                    .ADDR(addr)
                    //,.state(state)
            );
   

endmodule


