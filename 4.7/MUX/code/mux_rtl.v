module mux_21_rtl (
    input sel,
    input [7: 0] data1,
    input [7: 0] data2,
    output [7: 0] out
);
    assign out = sel? data2: data1;
endmodule