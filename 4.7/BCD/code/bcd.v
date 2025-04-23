module bcd (
    input [7: 0] SW,
    output [6: 0] HEX0,
    output [6: 0] HEX1,
    output [6: 0] HEX2
);
    
    bcd_rtl #(
        .BIN_WIDTH 	(8  ),
        .BCD_CNT   	(3  )
    )u_bcd_rtl(
        .bin_in  	(SW   ),
        .num_out 	({HEX2, HEX1, HEX0}  )
    );
    
endmodule