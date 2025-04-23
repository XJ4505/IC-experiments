module mux_21 (
    input [17: 0 ] SW,
    output [7: 0] LEDG
);  
    mux_21_rtl u_mux_21_rtl(
        .sel   	(SW[17]),
        .data1 	(SW[7: 0]),
        .data2 	(SW[15: 8]),
        .out   	(LEDG)
    );
    
endmodule