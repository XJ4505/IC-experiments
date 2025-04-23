module vibration_clearing (
    input CLOCK_50,
    input [3: 0] KEY,
    input [17: 0] SW,
    output [7: 0] LEDG,
    output [6: 0] HEX0,
    output [6: 0] HEX1
);
    wire key_out;
    wire hold;
    vibration_clearing_rtl u_vc (
        .clk(CLOCK_50),
        .rstn(~SW[0]),
        .tap(KEY[3]),
        .key_out1(key_out)
    );

    // output declaration of module counter_M
    wire [7: 0] counter;
    
    counter_M #(
        .M 	(15  )
    ) u_counter_M(
        .clk     	(key_out      ),
        .rst     	(SW[0]      ),
        .en      	(1'b1       ),
        .counter 	(counter  )
    );
    
    bcd_displayer #(
        .BIN_WIDTH 	(8  ),
        .BCD_CNT   	(2  )
    ) u_bcd_displayer(
        .bin_code    	(counter        ),
        .disp_result 	({HEX1, HEX0}   )
    );
    assign LEDG[0] = KEY[3];
endmodule