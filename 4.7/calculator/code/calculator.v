module calculator(
    input [17: 0] SW,
    output [6: 0] HEX7,
    output [6: 0] HEX6,
    output [6: 0] HEX5,
    output [6: 0] HEX2,
    output [6: 0] HEX1,
    output [6: 0] HEX0
);
    
    calculator_rtl u_calculator_rtl(
        .cal_mode    	(SW[17]             ),
        .disp_mode   	(SW[16]             ),
        .num1        	(SW[14: 8]          ),
        .num2        	(SW[6: 0]           ),
        .disp_num    	({HEX7, HEX6, HEX5} ),
        .disp_result 	({HEX2, HEX1, HEX0} )
    );
    
endmodule