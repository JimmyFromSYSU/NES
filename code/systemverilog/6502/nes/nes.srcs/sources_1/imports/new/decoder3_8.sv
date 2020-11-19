module decoder3_8(
input logic [2:0] __selector,
output logic [7:0] __signal
);
always_comb 
__signal = ~( 1 << (__selector) );
 
 
endmodule: decoder3_8
