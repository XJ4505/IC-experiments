module buaa_rtl(
input [8: 0] ctrl,
output [6:0] dev0, 
output [6:0] dev1,
output [6:0] dev2,
output [6:0] dev3,
output [6:0] dev4,
output [6:0] dev5,
output [6:0] dev6,
output [6:0] dev7
);    
parameter CHAR_B = 7'b0000000; 
parameter CHAR_U = 7'b1000001; 
parameter CHAR_A = 7'b0001000;  
parameter NUM_2 = 7'b0100100; 
parameter NUM_5 = 7'b0010010; 
parameter OFF = 7'b1111111;
assign dev0 = ctrl[7] ? CHAR_A : OFF; 
assign dev1 = ctrl[6] ? CHAR_A : OFF; 
assign dev2 = ctrl[5] ? CHAR_U : OFF; 
assign dev3 = ctrl[4] ? CHAR_B : OFF; 
assign dev4 = ctrl[3] ? NUM_2  : OFF; 
assign dev5 = ctrl[2] ? NUM_2  : OFF; 
assign dev6 = ctrl[1] ? NUM_2  : OFF; 
assign dev7 = ctrl[0] ? NUM_5  : OFF; 
endmodule 