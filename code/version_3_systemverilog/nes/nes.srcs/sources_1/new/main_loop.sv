`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2015 08:55:40 PM
// Design Name: 
// Module Name: main_loop
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


//////////////////////////////////////////////////////////////////////////////////
// Data Define
//////////////////////////////////////////////////////////////////////////////////

typedef enum bit [5:0] {
        ADC,AND,BIT,EOR,ORA,SBC,//5 
        ASL,LSR,ROL,ROR,//9
        DEC,DEX,DEY,INC,INX,INY,//15_f
        CMP,CPX,CPY,//18_12
        BCC, BCS,BEQ, BMI, BNE,BPL,BVC,BVS,//26_1a
        JMP,JSR,//28_1c
        BRK,//29_1d
        RTI,//30_1e
        RTS,//31_1f
        CLC,CLD,CLI,CLV,SED,SEI,SEC, //38_26
        LDA,LDX,LDY,STA,STX,STY,//44_2c
        TAX,TAY,TSX,TXA,TXS,TYA,//50_32
        PHA,PHP,PLA,PLP,//54_36
        NOP//55_37
} INSTRUCTION_NAME;

typedef enum bit [3:0]{
      NONE,IMEDIATE,//1
      ZERO_PAGE,ZERO_PAGE_X,ZERO_PAGE_Y,//4
      ABSOLUTE, ABSOLUTE_X, ABSOLUTE_Y,//7
      INDIRECT, INDIRECT_X, INDIRECT_Y,//10_a
      RELATIVE, JMP_ABSOLUTE, PULL_PC,STACK_MODE,STACK_PULL_MODE//15
      
}ADDRESS_MODE;

//////////////////////////////////////////////////////////////////////////////////
// INS Decoder
//////////////////////////////////////////////////////////////////////////////////

module INS_DECODER(
    input bit [7:0] INS,
    output bit [5:0] ins_name,
    output bit [3:0] addr_mode
);

    // ins_name
    always_comb begin
        if     (INS == 8'h78)               ins_name = SEI;
        else if(INS == 8'h38)               ins_name = SEC;
        else if(INS == 8'hF8)               ins_name = SED;
        else if(INS == 8'hD8)               ins_name = CLD;
        else if(INS == 8'h18)               ins_name = CLC;
        else if(INS == 8'hB8)               ins_name = CLI;
        else if(INS == 8'hD8)               ins_name = CLV;
        
        //else if(INS == 8'h89)ins_name = NOP; // must before STA //should not happen

        else if(INS == 8'hA2 || INS == 8'hA6 || INS == 8'hAE 
             || INS == 8'hB6 || INS == 8'hBE)                   ins_name = LDX;
        else if(INS == 8'hA0 || INS == 8'hA4 || INS == 8'hAC 
                 || INS == 8'hB4 || INS == 8'hBC)               ins_name = LDY;
        else if(INS == 8'h86 || INS == 8'h8E || INS == 8'h96)   ins_name = STX;
        else if(INS == 8'h84 || INS == 8'h8C || INS == 8'h94)   ins_name = STY;
        
        // ORA AND EOR ADC STA LDA CMP SBC
        else if((INS & 8'b111_000_11)==8'b000_000_01)         ins_name = ORA;
        else if((INS & 8'b111_000_11)==8'b001_000_01)         ins_name = AND;
        else if((INS & 8'b111_000_11)==8'b010_000_01)           ins_name = EOR;
        else if((INS & 8'b111_000_11)==8'b011_000_01)           ins_name = ADC;
        else if((INS & 8'b111_000_11)==8'b100_000_01)           ins_name = STA;
        else if((INS & 8'b111_000_11)==8'b101_000_01)           ins_name = LDA;
        else if((INS & 8'b111_000_11)==8'b110_000_01)           ins_name = CMP;
        else if((INS & 8'b111_000_11)==8'b111_000_01)         ins_name = SBC;
        
        else if(INS == 8'h10) ins_name = BPL; 
        else if(INS == 8'h30) ins_name = BMI; 
        else if(INS == 8'h50) ins_name = BVC; 
        else if(INS == 8'h70) ins_name = BVS; 
        else if(INS == 8'h90) ins_name = BCC; 
        else if(INS == 8'hb0) ins_name = BCS; 
        else if(INS == 8'hd0) ins_name = BNE;
        else if(INS == 8'hf0) ins_name = BEQ;
        //DEC,DEX,DEY,INC,INX,INY,
        else if(INS == 8'hca) ins_name = DEX;
        else if(INS == 8'h88) ins_name = DEY;
        else if(INS == 8'he8) ins_name = INX;
        else if(INS == 8'hc8) ins_name = INY;
        //TAX,TAY,TSX,TXA,TXS,TYA,
        else if(INS == 8'ha8) ins_name = TAY;
        else if(INS == 8'h98) ins_name = TYA;
        else if(INS == 8'h8A) ins_name = TXA;
        else if(INS == 8'hAA) ins_name = TAX;
        else if(INS == 8'h9A) ins_name = TXS;
        else if(INS == 8'hBA) ins_name = TSX;
        
        //JSR JMP
        else if(INS == 8'h20) ins_name = JSR;
        else if(INS == 8'h4C) ins_name = JMP;
        else if(INS == 8'h6C) ins_name = JMP;
        
        //BRK 
        //else if(INS == 8'h00) ins_name = BRK; // no
        //BIT
        else if(INS == 8'h2C) ins_name = BIT;
        //PHP PLP PHA PLA
        else if(INS == 8'h08) ins_name = PHP;
        else if(INS == 8'h28) ins_name = PLP;
        else if(INS == 8'h48) ins_name = PHA;
        else if(INS == 8'h68) ins_name = PLA;
        
        //RTI RTS
        else if(INS == 8'h40) ins_name = RTI;
        
        else if(INS == 8'h60) ins_name = RTS;
        //CPX CPY
        else if((INS & 8'b111_000_11)==8'b110_000_00) ins_name = CPY;
        else if((INS & 8'b111_000_11)==8'b111_000_00) ins_name = CPX;
        
        //ASL ROL LSR ROR DEC INC
        else if((INS & 8'b111_000_11)==8'b000_000_10)         ins_name = ASL;
        else if((INS & 8'b111_000_11)==8'b001_000_10)         ins_name = ROL;
        else if((INS & 8'b111_000_11)==8'b010_000_10)         ins_name = LSR;
        else if((INS & 8'b111_000_11)==8'b011_000_10)         ins_name = ROR;
        else if((INS & 8'b111_000_11)==8'b110_000_10)         ins_name = DEC;
        else if((INS & 8'b111_000_11)==8'b111_000_10)         ins_name = INC;
        else ins_name = NOP;
    end
    
    // addr_mode
    always_comb begin
        //if(INS == 8'h78)addr_mode = NONE;
        //else if(INS == 8'hD8)addr_mode = NONE;
        if(INS == 8'h60) addr_mode = PULL_PC;//ins_name = RTS;
        else if(INS == 8'h4C)addr_mode = ABSOLUTE; //JMP absolute/
        else if(  INS == 8'h6C) addr_mode = INDIRECT;
        
        else if(INS == 8'h40 )addr_mode = PULL_PC;//RTI
        else if(INS == 8'h08) addr_mode = STACK_MODE; //PHP PLP PHA PLA
        else if(INS == 8'h48) addr_mode = STACK_MODE;
        else if(INS == 8'h28) addr_mode = STACK_PULL_MODE;
        else if(INS == 8'h68) addr_mode = STACK_PULL_MODE;
        //STACK_MODE
        //8'bxxx_010_x_1
        else if( (INS & 8'b000_111_0_1) == 8'b000_010_0_1) addr_mode = IMEDIATE;
        else if( (INS & 8'b1_00_111_0_1) == 8'b1_00_000_0_0) addr_mode = IMEDIATE;
        
        else if(INS == 8'h20)addr_mode = ABSOLUTE;
        else if( (INS & 8'b000_111_00) == 8'b000_011_00) addr_mode = ABSOLUTE;
        else if( (INS & 8'b000_111_0_1) == 8'b000_110_0_1) addr_mode = ABSOLUTE_Y;
        else if( INS == 8'h99 || INS == 8'hB9 || INS == 8'h9F || INS == 8'hBF  ) addr_mode = ABSOLUTE_Y;
        else if( (INS & 8'b000_111_00) == 8'b000_111_00) addr_mode = ABSOLUTE_X;
        
        else if((INS & 8'b000_111_00) == 8'b000_001_00) addr_mode = ZERO_PAGE;
        else if(INS == 8'h96 || INS == 8'hB6 || INS == 8'h97 || INS == 8'hB7  ) addr_mode = ZERO_PAGE_Y;
        else if((INS & 8'b000_111_00) == 8'b000_101_00) addr_mode = ZERO_PAGE_X;
        
        //else if(INS == 8'h6C) addr_mode = INDERICT;
        else if((INS & 8'b000_111_0_1) == 8'b000_000_0_1) addr_mode = INDIRECT_X;
        else if((INS & 8'b000_111_0_1) == 8'b000_100_0_1) addr_mode = INDIRECT_Y;
        
        else if( (INS & 8'b000_11111) == 8'b000_10000) addr_mode = RELATIVE;
        else addr_mode = NONE;
    end
endmodule

//s  should long enough to cover 3 clk period
// nothing special ?
module NMI_PULSE (input bit clk,input bit s,output bit p);
    bit t; 
    always_ff @(posedge clk)begin
        if(s==1'b0) t<=1;
        else if(s==1 && t==1) begin
            p<=1;
            t<=0;
        end
        else p <= 0;
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Main
//////////////////////////////////////////////////////////////////////////////////

// The main process of fetching and execute an instruction
module MAIN_LOOP_FSM(
    input bit reset,
    //input bit start_dma,
    //input bit end_dma,
    input bit nmi,
    output bit nmi_status,
    output bit nmi_start,
    input bit clk,
    output bit en,write,
    output bit read,
    input bit addr_done,
    input bit alu_done,
    output bit jmp,
    output bit jsr,
    input bit [7:0] din,
    output bit [7:0] dout,
    output bit fetch,
    output bit [7:0] INS,
    input bit [5:0] ins_name,
    input bit [3:0] addr_mode,
    input bit [15:0] PC
    ,output bit [7:0] X,Y,A,SP, STATUS
    ,output logic [4:0] state
);
    //bit [7:0] X,Y,A,SP, STATUS;
    //bit [15:0] PC;
    
    bit S,V,B,D;
    bit I;
    bit Z,C;
    assign STATUS = {S,V,1'b0,B,D,I,Z,C};
    bit finsh_nmi_status;
    bit start_nmi;
    bit [7:0] TMP;
    bit [7:0] R_TMP;
    bit TMP_C;
    bit nmi_p;
    bit[31:0] NUM;

    
 //   bit [7:0] PCH,PCL;
//    assign PCH = PC[15:8];
//    assign PCL = PC[7:0];
    NMI_PULSE nmi_pulse (.clk(clk),.s(nmi),.p(nmi_p));
    //bit nmi_status = 0;
    always_ff @(posedge nmi_p , posedge finsh_nmi_status)
        if(nmi_p)  nmi_status <= 1; 
        else nmi_status <= 0;
    
    //state 
    enum logic [4:0] {RESET_PRE,RESET,RESET_ADDR,
        FETCH_INS,LOAD_DATA,EXEC_INS,SAVE_DATA,//5
        JMP_1,JMP_2,JMP_3,//8
        JSR_1,JSR_2,PUSH_PC_1,PUSH_PC_2,JSR_WAIT, //13 // PULL done by address
        NMI_1,NMI_2,NMI_PUSH_PC_1,NMI_PUSH_PC_2,NMI_WAIT, //13 // PULL done by address
        PULL_PC_1,RTS_WAIT_1,PULL_PC_2,RTS_WAIT_2,RTS_WAIT_3,
        DMA_WAIT
    } next_state;
    
    //logic [4:0] state;
    
    //state,
    //posedge: change state
    always_ff @(posedge clk)begin
        if(reset == 1'b1) state <= RESET_PRE;
        else state <= next_state;
    end

    // fsm state transform
    always_comb begin
        next_state = RESET_PRE;
        nmi_start = 0;
        case(state)
            RESET_PRE : next_state = RESET;
            RESET: next_state = RESET_ADDR;
            RESET_ADDR: next_state = FETCH_INS;
            
            FETCH_INS:  begin
            
//                if(nmi_status)begin
//                     nmi_start = 1;
//                     next_state = NMI_1;
//                end 
//                else 
                if(ins_name == NOP)next_state = EXEC_INS;
                else if(ins_name == STA || ins_name == STX || ins_name == STY)
                    case(addr_mode)
                        IMEDIATE: next_state = SAVE_DATA;
                        default : next_state = LOAD_DATA;
                    endcase
                else if(ins_name == LDA || ins_name == LDX || ins_name == LDY)
                    case(addr_mode)
                        IMEDIATE: next_state = EXEC_INS;
                        default : next_state = LOAD_DATA;
                    endcase
                else if(ins_name == CMP || ins_name == CPX || ins_name == CPY)
                    case(addr_mode)
                         IMEDIATE: next_state = EXEC_INS;
                         default : next_state = LOAD_DATA;
                    endcase
                                                         
                else if(ins_name == CLC || ins_name == CLD || ins_name == CLI || ins_name == CLV
                    ||  ins_name == SED || ins_name == SEI || ins_name == SEC) 
                        next_state = EXEC_INS;
                else if(ins_name == BPL || ins_name == BMI || ins_name == BVC || ins_name == BVS 
                     || ins_name == BCC || ins_name == BCS || ins_name == BNE || ins_name == BEQ) 
                        next_state = JMP_1;
                else if(ins_name == DEX || ins_name == DEY || ins_name == INX || ins_name == INY)
                        next_state = EXEC_INS;
                else if(ins_name == TYA || ins_name == TAY || ins_name == TXA || ins_name == TAX
                    ||  ins_name == TXS || ins_name == TSX)
                        next_state = EXEC_INS;
                else if(ins_name == ORA || ins_name == AND || ins_name == EOR || ins_name == ADC
                    ||  ins_name == CMP || ins_name == SBC)
                        case(addr_mode)
                            IMEDIATE: next_state = EXEC_INS;
                            default : next_state = LOAD_DATA;
                        endcase
                else if(ins_name == PHP || ins_name == PHA )
                    next_state = SAVE_DATA;
                else if(ins_name == PLP || ins_name == PLA )
                    next_state = EXEC_INS;
                else if(ins_name == ASL || ins_name == ROL || ins_name == LSR || ins_name == ROR
                     ||  ins_name == DEC || ins_name == INC)
                        case(addr_mode)
                             NONE: next_state = EXEC_INS;
                        default : next_state = LOAD_DATA;
                endcase

                else if(ins_name == JSR)
                        next_state = JSR_1;
                else if(ins_name == RTS)
                        next_state = PULL_PC_1;
                else if(ins_name == RTI)
                        next_state = PULL_PC_1;
                else next_state = LOAD_DATA;
            end
            
            LOAD_DATA:
                if(addr_done)begin 
                    if(ins_name == LDA || ins_name == LDX || ins_name == LDY)
                        next_state = EXEC_INS;
                    else if(ins_name == STA || ins_name == STX || ins_name == STY) 
                        next_state = SAVE_DATA; 
                    else if(ins_name == JMP) next_state = FETCH_INS;
                    else  next_state = EXEC_INS;   
                end
                else next_state = LOAD_DATA;
           
            EXEC_INS:
                if(ins_name == NOP) begin if(nmi_status) begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                //FETCH_INS;                                ///////////////////////////////////////////////////////////////
                else if(ins_name == LDA || ins_name == LDX || ins_name == LDY)next_state = FETCH_INS;
                else if(ins_name == CLC || ins_name == CLD || ins_name == CLI || ins_name == CLV
                    ||  ins_name == SED || ins_name == SEI || ins_name == SEC) 
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                               ///////////////////////////////////////////////////////////////
                else if(ins_name == CMP || ins_name == CPX || ins_name == CPY)
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                ///////////////////////////////////////////////////////////////
                else if(ins_name == BPL || ins_name == BMI || ins_name == BVC || ins_name == BVS 
                    || ins_name == BCC || ins_name == BCS || ins_name == BNE || ins_name == BEQ) 
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                    /////////////////////////////////////////////////////////////// 
                else if(ins_name == DEX || ins_name == DEY || ins_name == INX || ins_name == INY)
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                 ///////////////////////////////////////////////////////////////
                else if(ins_name == TYA || ins_name == TAY || ins_name == TXA || ins_name == TAX
                    ||  ins_name == TXS || ins_name == TSX)
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                ///////////////////////////////////////////////////////////////
                else if(ins_name == ORA || ins_name == AND || ins_name == EOR || ins_name == ADC
                    ||  ins_name == CMP || ins_name == SBC || ins_name == BIT)
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                 ///////////////////////////////////////////////////////////////
                else if(ins_name == PHP || ins_name == PLP || ins_name == PHA ||ins_name == PLA)
                    begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                    //FETCH_INS;                                                  ///////////////////////////////////////////////////////////////
                else if(ins_name == ASL || ins_name == ROL || ins_name == LSR || ins_name == ROR
                     ||  ins_name == DEC || ins_name == INC)
                    case(addr_mode)
                        NONE: begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
                        //FETCH_INS;                                     ///////////////////////////////////////////////////////////////
                        default : next_state = SAVE_DATA;
                    endcase 
                else next_state = SAVE_DATA;     
            SAVE_DATA: 
                begin 
                    if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  
                    //else if(start_dma)next_state = DMA_WAIT;
                    else next_state = FETCH_INS; 
                end
            //DMA_WAIT: if(end_dma)next_state = FETCH_INS;  else next_state = DMA_WAIT; 
            //FETCH_INS;                                             ///////////////////////////////////////////////////////////////
            
            JMP_1: if(jmp) next_state = JMP_2; else begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
            // FETCH_INS;             ///////////////////////////////////////////////////////////////
            //JMP_ADDR_2: if(addr_done)next_state = FETCH_INS;else next_state = JMP_ADDR_3;
            JMP_2: begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
            //FETCH_INS;                                                 ///////////////////////////////////////////////////////////////
            
            NMI_1: next_state = NMI_2;
            NMI_2: next_state = NMI_PUSH_PC_1;
            NMI_PUSH_PC_1: next_state = NMI_PUSH_PC_2;
            NMI_PUSH_PC_2: next_state = NMI_WAIT ;
            NMI_WAIT:  begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
            // FETCH_INS;                                          ///////////////////////////////////////////////////////////////
            //JSR_1,JSR_2,PUSH_PC_1,PUSH_PC_2,JSR_WAIT                        
            JSR_1: next_state = JSR_2;
            JSR_2: next_state = PUSH_PC_1;
            PUSH_PC_1: next_state = PUSH_PC_2;
            PUSH_PC_2: next_state = JSR_WAIT ;
            JSR_WAIT:  begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
            //next_state = FETCH_INS;                                         ///////////////////////////////////////////////////////////////
            
            PULL_PC_1: next_state = RTS_WAIT_1;
            RTS_WAIT_1:next_state = PULL_PC_2;
            PULL_PC_2: next_state = RTS_WAIT_2;
            RTS_WAIT_2: next_state = RTS_WAIT_3;
            RTS_WAIT_3:begin if(nmi_status)begin nmi_start = 1; next_state = NMI_1; end  else next_state = FETCH_INS; end
            //next_state = FETCH_INS; 
            //default : next_state = RESET_PRE;                                        ///////////////////////////////////////////////////////////////
        endcase
    end

    //  write and fetch
    //assign en = 1;
    always_comb begin
        fetch = 1'b0;
        write = 1'b0;
        en = 1'b1;
        read=1'b0;
        case(state)
            FETCH_INS:begin fetch = 1'b1; end//if(nmi_status==1'b1)fetch = 1'b0;else fetch = 1'b1;
            SAVE_DATA:write = 1'b1;
            PUSH_PC_1:write = 1'b1;
            PUSH_PC_2:write = 1'b1;
            NMI_PUSH_PC_1:write = 1'b1;
            NMI_PUSH_PC_2:write = 1'b1;
            EXEC_INS:if(ins_name == LDX ||ins_name == LDA ||ins_name == LDY)read=1'b1;
        endcase
    end

    ////////////////////////////nfxz_error
    // dout
    always_comb begin
        case(state)
            SAVE_DATA: 
                if(ins_name == STA) dout = A;
                else if(ins_name == STX) dout = X;
                else if(ins_name == STY) dout = Y;
                else if(ins_name == ASL || ins_name == LSR 
                ||  ins_name == DEC || ins_name == INC) dout = TMP;
                else if(ins_name == ROL || ins_name == ROR) dout = R_TMP;
                else if(ins_name == PHP) dout = STATUS;
                else if(ins_name == PHA) dout = A;
            PUSH_PC_1: dout = PC[15:8];
            PUSH_PC_2: dout = PC[7:0];
            NMI_PUSH_PC_1: dout = ((PC-1)>>8);
            NMI_PUSH_PC_2: dout = ((PC-1)&16'hff);
            default: dout = 0;
        endcase
    end
    

    //jmp jsr
    always_comb begin
        jmp = 1'b0;
        jsr = 1'b0;
        if(     (ins_name == BPL) && (S == 1'b0))jmp = 1'b1; //
        else if((ins_name == BMI) && (S == 1'b1))jmp = 1'b1; 
        else if((ins_name == BVC) && (V == 1'b0))jmp = 1'b1; 
        else if((ins_name == BVS) && (V == 1'b1))jmp = 1'b1; 
        else if((ins_name == BCC) && (C == 1'b0))jmp = 1'b1; 
        else if((ins_name == BCS) && (C == 1'b1))jmp = 1'b1; 
        else if((ins_name == BNE) && (Z == 1'b0))jmp = 1'b1; 
        else if((ins_name == BEQ) && (Z == 1'b1))jmp = 1'b1; 
        else if(ins_name == JSR)jsr = 1'b1; 
        else if(ins_name == JMP)jmp = 1'b1;  // how about RTS?
    end
    
    
    //before execute (posedge)
    always_ff @(posedge clk)begin
        if(ins_name == DEX)TMP <= X;
        else if(ins_name == DEY)TMP <= Y;
        else if(ins_name == INX)TMP <= X;
        else if(ins_name == INY)TMP <= Y;
        else if(ins_name == EOR || ins_name == AND || ins_name == ORA)TMP <= A;
        else if(ins_name == ADC)begin 
            TMP <= A ;
            NUM <= (A + ((C == 1'b1)? 32'b1:32'b0));
        end
        else if(ins_name == SBC)begin 
            TMP <= A ;
            NUM <= (A - ((C == 1'b1)? 32'b0:32'b1));
        end
        
        else if(ins_name == INC)TMP <= din + 8'b1 ; //
        else if(ins_name == DEC)TMP <= din - 8'b1 ; //
        
        
        else if(ins_name == ASL) begin
            if(addr_mode == NONE) begin TMP <= (A<<1);TMP_C <= (A>>7);end
            else begin TMP <= (din<<1);TMP_C <= (din>>7);  end
        end // risk din

        else if(ins_name == LSR) begin
            if(addr_mode == NONE)  begin TMP <= (A>>1);TMP_C <= (A&8'b1);end
            else  begin TMP <= (din>>1);TMP_C <= (din&8'b1);  end
        end// risk din
        
        
        else if(ins_name == ROL) begin
            if(addr_mode == NONE) begin TMP <= ((A<<1)|C);TMP_C <= (A>>7);end
            else  begin TMP_C <= C;  end
        end
        else if(ins_name == ROR) begin
            if(addr_mode == NONE)  begin TMP <= ((A>>1)|(C<<7));TMP_C <= (A&8'b1);end
            else  begin TMP_C <= C;  end
        end
      //  else TMP <= TMP;
    end
    
    // execute (negedge)
    always_ff @(negedge clk)begin
        case(state)
            RESET: begin
                X <= 8'h0;
                Y <= 8'h0;
                SP<= 8'h0;
                A <= 8'h0;
                //assign STATUS = {S,V,1'b0,B,D,I,Z,C};
                S <= 1'b0;
                V <= 1'b0;
                //0 <= 0;
                B <= 1'b0;
                
                D <= 1'b0;
                I <= 1'b0;
                Z <= 1'b0;
                C <= 1'b0;
            end
            FETCH_INS:begin
                INS <= din;   // ins_name and addr mode are no fetch right now !
            end
            
            EXEC_INS: begin
                if(ins_name == SEI )        I <= 1'b1;
                else if(ins_name == CLI)    I <= 1'b0;
                else if(ins_name == SEC)    C <= 1'b1;
                else if(ins_name == CLC)    C <= 1'b0;
                else if(ins_name == SED)    D <= 1'b1;
                else if(ins_name == CLD)    D <= 1'b0;
                else if(ins_name == CLV)    V <= 1'b0;
                //TXA change sign and zero flag or not
                else if(ins_name == TAY)    Y <= A;
                else if(ins_name == TYA)    A <= Y;
                else if(ins_name == TAX)    X <= A;
                else if(ins_name == TXA)    A <= X;
                else if(ins_name == TXS)    SP <= X;
                else if(ins_name == TSX)    X <= SP;
                
                else if(ins_name == LDA)begin
                     A <= din;
                     S <= (din>>7);
                     Z <= ((din == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == LDX) begin
                    X <= din;
                    S <= (din>>7);
                    Z <= ((din == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == LDY) begin
                    Y <= din;
                    S <= (din>>7);
                    Z <= ((din == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == DEX)begin
                    X <= TMP-8'b1;
                    S <= ((TMP-1)>>7);
                    Z <= (((TMP-1) == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == DEY)begin
                    Y <= TMP-8'b1;
                    S <= ((TMP-8'b1)>>7);
                    Z <= (((TMP-8'b1) == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == INX)begin
                    X <= TMP+8'b1;
                    S <= ((TMP+8'b1)>>7);
                    Z <= (((TMP+8'b1) == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == INY)begin
                    Y <= TMP+8'b1;
                    S <= ((TMP+8'b1)>>7);
                    Z <= (((TMP+8'b1) == 8'b0)?1'b1:1'b0);
                end
                else if(ins_name == BIT)begin 
                    S <= (din)>>7;
                    Z <= ((din & A) == 32'b0)?1'b1:1'b0; 
                    V <= ((din&8'h40)==1)?1'b1:1'b0;
                end
                else if(ins_name == ORA)begin
                    A <= (TMP)|din;
                    S <= (TMP|din)>>7;
                    Z <= (((TMP|din) == 8'b0)?1'b1:1'b0); 
                end
                else if(ins_name == AND)begin
                    A <= (TMP)&din;
                    S <= (TMP&din)>>7;
                    Z <= (((TMP&din) == 8'b0)?1'b1:1'b0); 
                end
                else if(ins_name == EOR)begin
                   A <= (TMP)^din;
                   S <= (TMP^din)>>7;
                   Z <= (((TMP^din) == 8'b0)?1'b1:1'b0); 
                end
               else if(ins_name == ADC)begin 
                    S <= (((NUM + din)&32'hff)>>7);
                    Z <= ((((NUM + din)&32'hff) == 32'b0)?1'b1:1'b0); 
                    C <= (((NUM + din) > 32'hff)?1'b1:1'b0);
                    
                   // V <= (((( !((NUM + din)^TMP & 32'h80) && ((din^TMP)& 32'h80)))==1)?1'b1:1'b0);
                    V <= (((( (!((din^TMP) & 32'h80)) && (((NUM+din)^TMP)& 32'h80)))==1)?1'b1:1'b0);
                                       
                    A <= ((NUM + din) & 8'hff);
               end
               else if(ins_name == SBC)begin 
                    S <= ((((NUM - din)&32'hff)>>7));
                    Z <= ((((NUM - din)&32'hff) == 32'b0)?1'b1:1'b0); 
                    C <= (((NUM - din) < 32'h100)?1'b1:1'b0);
                    V <= (((( (((din^TMP) & 32'h80)) && (((NUM-din)^TMP)& 32'h80)))==1)?1'b1:1'b0);
                    //V <= (((( ((NUM - din)^TMP & 32'h80) && ((din^TMP)& 32'h80)))==1)?1'b1:1'b0);
                    
                    //A <= NUM - din;
                    A <= ((NUM - din) & 8'hff);
               end
               else if(ins_name == CMP)begin
                    S <= (A - din)>>7;
                    Z <= ((A- din) == 8'b0)?1'b1:1'b0; 
                    C <= (({8'b0,A}- {8'b0,din}) < 16'h100)?1'b1:1'b0; 
               end
               else if(ins_name == CPX)begin
                    S <= (X - din)>>7;
                    Z <= ((X- din) == 8'b0)?1'b1:1'b0; 
                    C <= (({8'b0,X}- {8'b0,din}) < 16'h100)?1'b1:1'b0; 
               end
               else if(ins_name == CPY)begin
                    S <= (Y - din)>>7;
                    Z <= ((Y- din) == 8'b0)?1'b1:1'b0; 
                    C <= (({8'b0,Y}- {8'b0,din}) < 16'h100)?1'b1:1'b0; 
               end
                else if(ins_name == DEC)begin
                    S <= (din-8'b1)>>7;
                    Z <= ((din-8'b1) == 8'b0)?1'b1:1'b0; 
                end
                else if(ins_name == INC)begin
                    S <= (din+8'b1)>>7;
                    Z <= ((din+8'b1) == 8'b0)?1'b1:1'b0; 
                end
                
                else if(ins_name == ASL) begin
                    if(addr_mode == NONE) begin
                        A <= TMP; // without din
                        S <= (TMP)>>7;
                        Z <= (TMP == 8'b0)?1'b1:1'b0; 
                        C <= TMP_C;
                    end
                    else begin
                        S <= ((din<<1))>>7;
                        Z <= ((din<<1) == 8'b0)?1'b1:1'b0; 
                        C <= (din>>7);
                    end
                end
                else if(ins_name == LSR) begin
                    if(addr_mode == NONE) begin
                         A <= TMP;
                         S <= (TMP)>>7;
                         Z <= (TMP == 8'b0)?1'b1:1'b0; 
                         C <= TMP_C;
                    end
                    else begin
                        S <= ((din>>1))>>7;
                        Z <= ((din>>1) == 8'b0)?1'b1:1'b0; 
                        C <= (din&8'b1);
                    end
                end
                
//                else if(ins_name == ROL) begin
//                    if(addr_mode == NONE) begin TMP <= ((A<<1)&C);TMP_C <= (A>>7);end
//                    else  begin TMP <= ((din<<1)&C);TMP_C <= (din>>7);  end
//                end
//                else if(ins_name == ROR) begin
//                    if(addr_mode == NONE)  begin TMP <= ((A>>1)&(C<<7));TMP_C <= (A&8'b1);end
//                    else  begin TMP <= ((din>>1)&(C<<7));TMP_C <= (din&8'b1);  end
//                end
                
                else if(ins_name == ROL) begin
                    if(addr_mode == NONE)begin 
                        A <= TMP;
                        S <= ((TMP)>>7);
                        Z <= (TMP == 8'b0)?1'b1:1'b0; 
                        C <= TMP_C;
                    end
                    else begin 
                        S <= ((((din<<1)|TMP_C))>>7);
                        Z <= (((din<<1)|TMP_C) == 8'b0)?1'b1:1'b0; 
                        C <= (din>>7);
                        R_TMP <= ((din<<1)|TMP_C);
                    end
                end
                else if(ins_name == ROR) begin
                    if(addr_mode == NONE) begin 
                        A <= TMP;
                        S <= ((TMP)>>7);
                        Z <= (TMP == 8'b0)?1'b1:1'b0; 
                        C <= TMP_C;
                    end
                    else begin
                        S <= (((din>>1)|(TMP_C<<7))>>7);
                        Z <= ( ( (din>>1)|(TMP_C<<7) ) == 8'b0 )?1'b1:1'b0; 
                        C <= (din&8'b1);
                        R_TMP <= ( (din>>1)|(TMP_C<<7) );
                    end
                end
                
                else if(ins_name == PLP) begin
                    S <= din[7];
                    V <= din[6];
                    //0 <= din[5];
                    B <= din[4];
                    D <= din[3];
                    I <= din[2];
                    Z <= din[1];
                    C <= din[0];
                    SP <= SP + 8'b1;  
                end
                else if(ins_name == PLA)begin
                     A <= din;
                     SP <= SP + 8'b1;  
                end
            end
            SAVE_DATA:begin
                if(ins_name == PHP || ins_name == PHA) SP <= SP - 8'b1;  
            end
                
            PUSH_PC_1: SP <= SP - 8'b1;  
            PUSH_PC_2: SP <= SP - 8'b1;
            NMI_PUSH_PC_1: SP <= SP - 8'b1;  
            NMI_PUSH_PC_2: SP <= SP - 8'b1;
            PULL_PC_1: SP <= SP + 8'b1;  
            PULL_PC_2: SP <= SP + 8'b1;
            //else if(ins_name == ASL || ins_name == ROL || ins_name == LSR || ins_name == ROR
            //     ||  ins_name == DEC || ins_name == INC)
            
//            ASL: dout = TMP;
//            ROL: dout = TMP;
//            LSR: dout = TMP;
//            ROR: dout = TMP;
//            DEC: dout = TMP;
//            INC: dout = TMP;            
            
        endcase
    end
 
    //finsh_nmi_status
    always_comb begin
        finsh_nmi_status = 0;
        if(nmi_status)
            case(state)
                NMI_PUSH_PC_1 : finsh_nmi_status = 1;
                default: finsh_nmi_status = 0;
            endcase
        else finsh_nmi_status = 0;
    end
    
endmodule



//////////////////////////////////////////////////////////////////////////////////
// Addr
//////////////////////////////////////////////////////////////////////////////////


module ADDR_FSM(
    input bit jmp,
    input bit jsr,
    input bit reset,
    input bit nmi_start,
    input bit clk,
    input bit [3:0] addr_mode,
    input bit fetch,
    output bit addr_done,
    input bit [7:0] X,Y,SP,din,
    output bit [15:0] PC,
    output bit [15:0] ADDR // addr bus of 6502 
    ,output bit [5:0] state
);
    enum bit [5:0] {RESET_PRE,RESET,RESET_ADDR,WAITING,//2
        ABSOLUTE_1,ABSOLUTE_2,ABSOLUTE_ADD_X,ABSOLUTE_ADD_Y,//6
        ZERO_PAGE_1,ZERO_PAGE_ADD_X,ZERO_PAGE_ADD_Y,//9
        RELATIVE_1,RELATIVE_2,//11
        PUSH_PC_1,PUSH_PC_2,LOAD_TADDR2PC,//14
        WAIT_SP_1,PULL_PC_1,WAIT_SP_2,PULL_PC_2,LOAD_RTS_PC,//19
        INDIRECT_FIND_ADDR_1,INDIRECT_FIND_ADDR_2,INDIRECT_FIND_ADDR_3,INDIRECT_LOAD_ADDR,//23
        INDIRECT_JMP_ADDR_1_1,INDIRECT_JMP_ADDR_1_2,INDIRECT_JMP_LOADPC_1,
        INDIRECT_JMP_ADDR_2_1,INDIRECT_JMP_ADDR_2_2,INDIRECT_JMP_LOADPC_2,
        NMI_1,NMI_2,
        STACK_ADDR,STACK_PULL_ADDR
        } next_state;
        
    bit [15:0] HOLD_PC;
    bit [7:0]  HOLD_SP;
    bit [15:0] HOLD_ADDR;
    bit [15:0] TMP_INDRECT_ADDR;
    bit [15:0] TMP_ADDR;
    
    
    always_ff @(posedge clk)begin
        if(reset == 1'b1) state <= RESET_PRE;
        else state <= next_state;
    end
   
    always_ff @(posedge clk) HOLD_PC<= PC;
    always_ff @(posedge clk) HOLD_SP <= SP;
    always_ff @(posedge clk) HOLD_ADDR <= TMP_ADDR;

    
    // next state
    always_comb begin
        next_state = RESET_PRE;
        case(state)
            RESET_PRE: next_state = RESET;
            RESET: next_state = RESET_ADDR;
            RESET_ADDR: next_state = WAITING;
            WAITING: begin 
                next_state = WAITING;
                if(fetch) 
                    // fetch is important, start of the instruction, 
                    //it's a different situation when addressing finish and return to state WAITING
                    case(addr_mode)
                        NONE:next_state = WAITING;
                        IMEDIATE:next_state = WAITING;
                        ABSOLUTE:next_state = ABSOLUTE_1;
                        ABSOLUTE_X:next_state = ABSOLUTE_1;
                        ABSOLUTE_Y:next_state = ABSOLUTE_1;
                        
                        ZERO_PAGE:next_state = ZERO_PAGE_1;
                        ZERO_PAGE_X:next_state = ZERO_PAGE_1;
                        ZERO_PAGE_Y:next_state = ZERO_PAGE_1;
                        
                        INDIRECT : next_state = INDIRECT_JMP_ADDR_1_1;
                        INDIRECT_X:next_state = INDIRECT_FIND_ADDR_1;
                        INDIRECT_Y:next_state = INDIRECT_FIND_ADDR_1;
                        
                        RELATIVE:next_state = RELATIVE_1;
                        PULL_PC:next_state = WAIT_SP_1;
                        //PULL_PC_RTI:next_state = WAIT_SP_1;
                        
                        STACK_MODE: next_state = STACK_ADDR;
                        STACK_PULL_MODE : next_state = STACK_PULL_ADDR;
                    endcase
                else if(nmi_start)next_state = NMI_1;
                else  next_state = WAITING;
            end
            NMI_1 : next_state = NMI_2;
            INDIRECT_JMP_ADDR_1_1: next_state =INDIRECT_JMP_ADDR_1_2;
            INDIRECT_JMP_ADDR_1_2: next_state =INDIRECT_JMP_LOADPC_1;
            INDIRECT_JMP_LOADPC_1: next_state =INDIRECT_JMP_ADDR_2_1;
            INDIRECT_JMP_ADDR_2_1: next_state =INDIRECT_JMP_ADDR_2_2;
            INDIRECT_JMP_ADDR_2_2: next_state =INDIRECT_JMP_LOADPC_2;
            INDIRECT_JMP_LOADPC_2: next_state =WAITING;
            
            NMI_2 : next_state = PUSH_PC_1;
            ABSOLUTE_1: next_state = ABSOLUTE_2;
            ABSOLUTE_2: 
                if(jmp)next_state = LOAD_TADDR2PC;
                else if(jsr)next_state = PUSH_PC_1;
                else  
                case(addr_mode)
                    ABSOLUTE: next_state = WAITING;
                    ABSOLUTE_X: next_state = ABSOLUTE_ADD_X;
                    ABSOLUTE_Y: next_state = ABSOLUTE_ADD_Y;
                endcase
            ABSOLUTE_ADD_X:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            ABSOLUTE_ADD_Y:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            
            ZERO_PAGE_1:
                case(addr_mode)
                    ZERO_PAGE: next_state = WAITING;
                    ZERO_PAGE_X: next_state = ZERO_PAGE_ADD_X;
                    ZERO_PAGE_Y: next_state = ZERO_PAGE_ADD_Y;
                endcase
            ZERO_PAGE_ADD_X:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            ZERO_PAGE_ADD_Y:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            
            RELATIVE_1:if(jmp)next_state = RELATIVE_2;else if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            RELATIVE_2:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            PUSH_PC_1: next_state = PUSH_PC_2;
            PUSH_PC_2: next_state = LOAD_TADDR2PC;
            LOAD_TADDR2PC: if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            
            //WAIT_SP_1,PULL_PC_1,WAIT_SP_2,PULL_PC_2,LOAD_TADDR2PC,
            WAIT_SP_1: next_state = PULL_PC_1;
            PULL_PC_1: next_state = WAIT_SP_2;
            WAIT_SP_2: next_state = PULL_PC_2;
            PULL_PC_2: next_state = LOAD_RTS_PC;
            LOAD_RTS_PC : if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            
            
            //INDIRECT_FIND_ADDR_1,INDIRECT_FIND_ADDR_2,INDIRECT_FIND_ADDR_3,INDIRECT_LOAD_ADDR,
            INDIRECT_FIND_ADDR_1:next_state = INDIRECT_FIND_ADDR_2;
            INDIRECT_FIND_ADDR_2:next_state = INDIRECT_FIND_ADDR_3;
            INDIRECT_FIND_ADDR_3:next_state = INDIRECT_LOAD_ADDR;
            INDIRECT_LOAD_ADDR:if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            
            STACK_ADDR: if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            STACK_PULL_ADDR: if(nmi_start)next_state = NMI_1; else next_state = WAITING;
            //DONE 
        endcase
    end
    
    bit [15:0] ADDR_HOLD_ON_WAIT;
    
    //always_ff @(clk)begin
    //    ADDR_HOLD_ON_WAIT <= ADDR;
    //end
    
    ////////////////////////////nfxz_error
    // output ADDR
    always_comb begin
        
        ADDR = 0;
        addr_done = 0;
        if(next_state == WAITING) addr_done = 1; 
        case(state)
            RESET: ADDR = 16'hFFFD;
            RESET_ADDR:ADDR = 16'hFFFC;
            WAITING:begin
                if(fetch) begin ADDR = HOLD_PC;end
                else begin
                    //addr_done = 1;                     //////////////////////////////////////////////addr_done = 1
                    if(addr_mode == NONE || addr_mode == IMEDIATE)ADDR = HOLD_PC;
//                    else if(addr_mode == ZERO_PAGE)ADDR = HOLD_PC-1;
//                    else if(addr_mode == ZERO_PAGE_X)ADDR = TMP_ADDR;
//                    else if(addr_mode == ZERO_PAGE_Y)ADDR = TMP_ADDR;
//                    else if(addr_mode == ABSOLUTE)ADDR = HOLD_PC-1;
//                    else if(addr_mode == ABSOLUTE_X)ADDR = TMP_ADDR;
//                    else if(addr_mode == ABSOLUTE_Y)ADDR = TMP_ADDR;
                    else if(addr_mode == INDIRECT_X || addr_mode == INDIRECT_Y)ADDR = TMP_INDRECT_ADDR;
                    else ADDR = TMP_ADDR;               //absolute, zeropage, set ADDR on wait state
                end
            end
            NMI_1:ADDR = HOLD_PC;
            NMI_2:ADDR = HOLD_PC;
            ABSOLUTE_1: ADDR = HOLD_PC;
            ABSOLUTE_2: begin 
                ADDR = HOLD_PC;
               // if(addr_mode == ABSOLUTE && )addr_done = 1;//////////////////////////////////////////////addr_done = 1
            end
            ABSOLUTE_ADD_X:begin ADDR = TMP_ADDR;// addr_done = 1;
            end//////////////////////////////////////////////addr_done = 1 //no excute with changing TMP_ADDR
            ABSOLUTE_ADD_Y:begin ADDR = TMP_ADDR;// addr_done = 1;
            end//////////////////////////////////////////////addr_done = 1 //no excute with changing TMP_ADDR
            
            ZERO_PAGE_1:  begin
                ADDR = HOLD_PC;
                //if(addr_mode == ZERO_PAGE)addr_done = 1;
            end
            ZERO_PAGE_ADD_X: begin ADDR = TMP_ADDR; //addr_done = 1;
            end //no excute with changing TMP_ADDR
            ZERO_PAGE_ADD_Y: begin ADDR = TMP_ADDR; //addr_done = 1;
            end //no excute with changing TMP_ADDR
            PULL_PC_1: ADDR = {8'h01,SP};
            
            PULL_PC_2: ADDR = {8'h01,SP};   
                     
            //WAIT_SP_1:ADDR = {8'h01,SP};
            //WAIT_SP_2:ADDR = {8'h01,SP};
            
            RELATIVE_1:ADDR = HOLD_PC;
            RELATIVE_2:ADDR = HOLD_PC-1;
            //RELATIVE_2:ADDR = ADDR;
            PUSH_PC_1:ADDR = {8'h01,HOLD_SP};
            PUSH_PC_2:ADDR = {8'h01,HOLD_SP};
            
            INDIRECT_FIND_ADDR_1:   ADDR = HOLD_PC;
            INDIRECT_FIND_ADDR_2:   ADDR = HOLD_ADDR;
            INDIRECT_FIND_ADDR_3:   ADDR = HOLD_ADDR;
            INDIRECT_LOAD_ADDR:     begin ADDR = TMP_INDRECT_ADDR; //addr_done = 1;
            end
            STACK_ADDR: ADDR = {8'h01,HOLD_SP};
            STACK_PULL_ADDR: ADDR = {8'h01,HOLD_SP+8'b1};
            INDIRECT_JMP_ADDR_1_1: ADDR = HOLD_PC;
            INDIRECT_JMP_ADDR_1_2: ADDR = HOLD_PC;
            INDIRECT_JMP_ADDR_2_1: ADDR = HOLD_PC;
            INDIRECT_JMP_ADDR_2_2: ADDR = HOLD_PC;
            
        endcase
    end
    
    //Negative edge 
    //change PC
    always_ff @(negedge clk)begin
        case(state)
                RESET: PC[15:8] <= din;
                RESET_ADDR: PC[7:0] <= din;
                WAITING: begin
                    if(fetch) PC <= PC+1;// in NMI ther is no fetch, so when RTI we need to add 1 to PC, just like RTS
                    else if(addr_mode == IMEDIATE) PC <= PC+1;
                end
                ABSOLUTE_1: PC <= PC+1;
                ABSOLUTE_2: if(!jsr)PC <= PC+1; // when jsr, we need to push the PC before add into stack
                
                ZERO_PAGE_1: PC <= PC+1;
                
                RELATIVE_1: PC <= PC+1;
                RELATIVE_2: if((din>>7)==1'b1)PC <= PC + {8'b1111_1111,din}; else PC <= (PC + din);
                LOAD_TADDR2PC: PC <= TMP_ADDR;
                LOAD_RTS_PC: 
                    //if(addr_mode == PULL_PC_RTI) PC <= TMP_ADDR+1; //RTI
                    //else PC <= TMP_ADDR + 1; //RTS 
                    PC <= TMP_ADDR + 1; //RTS //RTI
                INDIRECT_FIND_ADDR_1: PC <= PC+1;
              //  default : PC <= PC;
              
              INDIRECT_JMP_ADDR_1_1: PC <= PC +1;
              INDIRECT_JMP_LOADPC_1: PC <= TMP_ADDR;
              INDIRECT_JMP_ADDR_2_1: PC <= PC +1;
              INDIRECT_JMP_LOADPC_2: PC <= TMP_ADDR;
        endcase
    end


    //Negative edge 
    //change TMP_ADDR
    always_ff @(negedge clk)begin
        case(state)
                ABSOLUTE_1: TMP_ADDR [7:0] <= din;
                ABSOLUTE_2: TMP_ADDR [15:8] <= din;
                NMI_1: TMP_ADDR [7:0] <= 8'h00;
                NMI_2: TMP_ADDR [15:8] <= 8'hD4;
                ABSOLUTE_ADD_X: TMP_ADDR <= TMP_ADDR +X;
                ABSOLUTE_ADD_Y: TMP_ADDR <= TMP_ADDR +Y;
                PULL_PC_1: TMP_ADDR [7:0] <= din;
                PULL_PC_2: TMP_ADDR [15:8] <= din;      
                ZERO_PAGE_1: TMP_ADDR <= {8'b0000_0000,din};
                ZERO_PAGE_ADD_X: TMP_ADDR <= ((TMP_ADDR +X)&16'hff);
                ZERO_PAGE_ADD_Y: TMP_ADDR <= ((TMP_ADDR +Y)&16'hff);
                INDIRECT_FIND_ADDR_1:  begin
                    if(addr_mode == INDIRECT_X) TMP_ADDR <= ({8'b0,din} + {8'b0,X}); 
                    else    TMP_ADDR <= {8'b0,din};
                end
                
                INDIRECT_FIND_ADDR_2:TMP_ADDR <= TMP_ADDR + 16'b1; 
               // default: TMP_ADDR <= TMP_ADDR;
               
               INDIRECT_JMP_ADDR_1_1:TMP_ADDR[7:0] <= din;
               INDIRECT_JMP_ADDR_1_2:TMP_ADDR[15:8] <= din;
               INDIRECT_JMP_ADDR_2_1:TMP_ADDR[7:0] <= din;
               INDIRECT_JMP_ADDR_2_2:TMP_ADDR[15:8] <= din;
        endcase
    end
    
    //TMP_INDRECT_ADDR for indirect x y
    always_ff @(negedge clk)begin
        case(state)
            INDIRECT_FIND_ADDR_2:TMP_INDRECT_ADDR <= {8'b0,din};
            INDIRECT_FIND_ADDR_3:
                if(addr_mode == INDIRECT_Y)
                    TMP_INDRECT_ADDR <= TMP_INDRECT_ADDR + {din,8'b0} + {8'b0,Y};
                else 
                    TMP_INDRECT_ADDR <= TMP_INDRECT_ADDR + {din,8'b0};
        endcase
    end

    
endmodule
