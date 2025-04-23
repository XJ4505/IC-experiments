module cycled_displayer (
    input CLOCK_50,
    input [17: 0] SW,

    output [14: 0] LEDR,
    output [6: 0] HEX0,
    output [6: 0] HEX1,
    output [6: 0] HEX2,
    output [6: 0] HEX3,
    output [6: 0] HEX4,
    output [6: 0] HEX5,
    output [6: 0] HEX6,
    output [6: 0] HEX7
);
    cycled_displayer_rtl #(
        .FREQ 	(25_000_000  )
    )   u_cycled_displayer_rtl(
        .clk    	(CLOCK_50   ),
        .rst    	(SW[17]     ),
        .en     	(SW[0]      ),
        .digits 	({HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0}  ),
        .led    	(LEDR[14: 7])
    );
    
endmodule