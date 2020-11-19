
//module BIN_BCD_4 (
//input bit CLK,
//input bit  [16:0]A, 
//input bit [3:0] B [4:0]);

//    int I;
//    bit  [19:0]TEMP;
//    bit  [16:0]C;
//    always @ (posedge CLK)
//    begin
//       C=A;
//       TEMP=0;
//       for (I=1; I<17; I=I+1)
//           begin
//           {TEMP, C}={TEMP[18:0], C, 1'b0};//左移一位
//           if (TEMP[3:0]>4'b0100)
//              begin
//                TEMP[3:0]=TEMP[3:0]+3;	// >4则加3
//              end 
//           if (TEMP[7:4]>4'b0100)
//              begin
//                TEMP[7:4]=TEMP[7:4]+3;
//              end 
//           if (TEMP[11:8]>4'b0100)
//              begin
//                TEMP[11:8]=TEMP[11:8]+3;
//              end 
//           if (TEMP[15:12]>4'b0100)
//              begin
//                TEMP[15:12]=TEMP[15:12]+3;
//              end 
//           if (TEMP[19:16]>4'b0100)
//              begin
//                TEMP[19:16]=TEMP[19:16]+3;
//              end 
//           {BW, BQ, BB,  BS, BG}={TEMP[18:0], A[0]};
//        end
//     end
//endmodule

module selectDigit(
    input bit [3:0] show[8],
    input bit [2:0] select,
    output bit [3:0] out);
    
always_comb
    out[3:0] = show[select][3:0];
endmodule : selectDigit

module show_num(
    //input bit [15:0] SW,
    input bit clk,
    //output bit [15:0] LED,
    output bit [6:0] seg,
    output bit [7:0] an, 
    output bit dp,
    input bit [3:0] show [8]
);  
    
    //bit [3:0] show [8] = {1,4,2,8,3,8,4,1};
    //bit [3:0] show [8] = {1,3,5,7,9,4'hb,4'hd,4'hf};
    //CLK
    bit [25:0] tmp;
    
    always_ff @(posedge clk) begin
        tmp = tmp + 1;
        //LED[0] = tmp[24];
    end

     bit [3:0] __digit;
     bit [2:0] seg_selector;
        
     //always_comb begin  __digit[3:0] = show[seg_selector][3:0]; end
     selectDigit sd (show,seg_selector,__digit);
      //digit2seg(__digit, seg);
      hex2seg(__digit, seg);
      decoder3_8(seg_selector, an);
      always_ff @(posedge tmp[10]) begin
            seg_selector <= seg_selector + 1;
      end

endmodule : show_num