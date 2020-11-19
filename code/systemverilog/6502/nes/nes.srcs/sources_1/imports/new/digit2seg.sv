

module digit2seg(
input bit [3:0] __digit,
output bit [6:0] __seg
);
always_comb
unique case (__digit)  
 0: __seg[6:0] = 7'b1000_000;
 1: __seg[6:0] = 7'b1111_001;
 2: __seg[6:0] = 7'b0100_100;
 3: __seg[6:0] = 7'b0110_000;
 4: __seg[6:0] = 7'b0011_001;
 5: __seg[6:0] = 7'b0010_010;
 6: __seg[6:0] = 7'b0000_010;
 7: __seg[6:0] = 7'b1111_000;
 8: __seg[6:0] = 7'b0000_000;
 9: __seg[6:0] = 7'b0010_000;
 endcase
 
endmodule: digit2seg


module hex2seg(
input bit [3:0] __hex,
output bit [6:0] __seg
);
always_comb
unique case (__hex)  
 0: __seg[6:0] = 7'b1000_000;
 1: __seg[6:0] = 7'b1111_001;
 2: __seg[6:0] = 7'b0100_100;
 3: __seg[6:0] = 7'b0110_000;
 4: __seg[6:0] = 7'b0011_001;
 5: __seg[6:0] = 7'b0010_010;
 6: __seg[6:0] = 7'b0000_010;
 7: __seg[6:0] = 7'b1111_000;
 8: __seg[6:0] = 7'b0000_000;
 9: __seg[6:0] = 7'b0010_000;
 
 10: __seg[6:0] = 7'b0001_000;
 11: __seg[6:0] = 7'b0000_011;
 12: __seg[6:0] = 7'b1000_110;
 13: __seg[6:0] = 7'b0100_001;
 14: __seg[6:0] = 7'b0000_110;
 15: __seg[6:0] = 7'b0001_110;
 endcase
 
endmodule