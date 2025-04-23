//input a binary code, output a 7-segment display code
//step1: convert binary to bcd code
//step2: convert bcd code to 7-segment display code
module bcd_displayer #(
    parameter BIN_WIDTH = 8,//original binary code width
    parameter BCD_CNT = 3   //number of bcd code to be displayed
)(
    input   [BIN_WIDTH - 1: 0] bin_code,
    output  [BCD_CNT*7 - 1: 0] disp_result
);
    //to bcd
    wire [BCD_CNT*4-1:0] bcd_code;
    bin2bcd #(
        .BIN_WIDTH 	(BIN_WIDTH  ),
        .BCD_CNT   	(BCD_CNT    )
        ) u_bin2bcd(
        .bin_code 	(bin_code  ),
        .bcd_code 	(bcd_code  )
    );
    
    //to display
    generate
        genvar i;
        for(i = 0; i < BCD_CNT; i = i + 1) begin: gen_display
            number_display u_number_display(
                .sel    (1'b0                   ),
                .in     (bcd_code[i*4 +: 4]     ),
                .out    (disp_result[i*7 +: 7]  )
            );
        end
    endgenerate

endmodule