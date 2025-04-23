module led_rtl
#(parameter WIDTH = 1)
(
input [WIDTH -1 : 0] in, output [WIDTH -1 : 0] dev );
assign dev = in;
endmodule