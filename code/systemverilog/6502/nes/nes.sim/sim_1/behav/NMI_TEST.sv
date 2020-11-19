`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2015/03/19 16:14:13
// Design Name: 
// Module Name: NMI_TEST
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2015 08:23:19 PM
// Design Name: 
// Module Name: CPU_tb
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


module NMI_TEST(

);
    bit [31:0] count;
    logic [15:0] addr;
    logic nclk;
    logic [4:0] state;
    logic [7:0] din;
    logic fetch;
    logic [7:0] INS;
    logic [5:0] ins_name;
    logic [3:0] addr_mode;
    logic nmi_status;
    
    
    //test
    logic [7:0] A,X,Y;
    logic [7:0]SP;
    logic [15:0] PC;
    logic [7:0] STATUS;
    logic write;
    logic [7:0] dout;

    logic [7:0] din_prom,din_pram,din_ppu_reg;
    logic nmi, reset, clk, en;
    
    initial begin
        clk = 0;
       // $monitor("%h",addr);
        repeat (100000000) #5 clk = ~clk;
        //repeat (400000) #5 clk = ~clk;
    end
    
    divide_16 div16(clk,nclk);

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
        else if( (addr[15:0]==16'h2002)&&en) din = 8'h80;
        else if( (addr[15:13]==3'b000)&&en) din = din_pram;
        else din = 8'b0;
    end
    
    always_ff @(posedge fetch)
        count <= count + 1;  
    
    always_ff @(negedge nclk)begin
        if(count == 50000) nmi <= 1;
        else nmi <= 0;
    end
endmodule





