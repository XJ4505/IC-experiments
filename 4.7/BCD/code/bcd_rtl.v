module bcd_rtl #(
    parameter BIN_WIDTH = 8,
    parameter BCD_CNT = 3
)(
    input [BIN_WIDTH - 1: 0] bin_in,
    output [20: 0] num_out
);
    wire [BCD_CNT*4 - 1: 0] bcd_code;
    
    bin2bcd #(
        .BIN_WIDTH 	(8),
        .BCD_CNT   	(3)
    )u_bin2bcd(
        .bin_code 	(bin_in),
        .bcd_code 	(bcd_code)
    );

    generate
        genvar i;
        for(i = 0; i < BCD_CNT; i = i + 1) begin: num_gen
            num_switch_rtl u_num_switch_rtl(
                .sel(0),
                .in(bcd_code[(4*i + 3) -: 4]),
                .out(num_out[(7*i + 6) -: 7])
            );
        end
    endgenerate
endmodule
    