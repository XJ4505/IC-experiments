module counter_M #(
    parameter M = 8
)(
    input [3: 0] KEY,
    input [17: 0] SW,
    output [6: 0] HEX0,
    output [6: 0] HEX1
);
    wire [7: 0 ] counter;
    counter_rtl #(
        .M(M)
    )u_counter(
        .clk(|(~KEY)),
        .rst(SW[0]),
        .en(SW[1]),
        .counter(counter)
    );

    bcd_displayer #(
        .BIN_WIDTH 	(8  ),
        .BCD_CNT   	(2  )
        )u_bcd_displayer(
        .bin_code    	(counter    ),
        .disp_result 	({HEX1, HEX0}  )
    );
    
endmodule