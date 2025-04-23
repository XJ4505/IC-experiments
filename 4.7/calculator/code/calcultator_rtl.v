module calculator_rtl (
    input cal_mode,             //1：+ 0：-
    input disp_mode,            //1：num2 0：num1
    input [6: 0] num1,
    input [6: 0] num2,
    output [20: 0] disp_num,
    output [20: 0] disp_result  //7 bits for each digit, 3 digits in total
);
    wire [7: 0] result;
    wire [11: 0] bcd_num1, bcd_num2, bcd_result, bcd_display;
    assign result = cal_mode? (num1 + num2): (num1 - num2);
    
    bin2bcd bcd1(
        .bin_code(num1),
        .bcd_code(bcd_num1)
    );
    bin2bcd bcd2(
        .bin_code(num2),
        .bcd_code(bcd_num2)
    );
    bin2bcd bcd3(
        .bin_code(result),
        .bcd_code(bcd_result)
    );

    assign bcd_display = disp_mode? bcd_num2: bcd_num1;

    generate
        genvar i;
        for(i = 0; i < 3; i = i + 1) begin:display
            number_display disp1(
                .sel(0),
                .in(bcd_display[4*i +: 4]),
                .out(disp_num[7*i +: 7])
            );
            number_display disp2(
                .sel(0),
                .in(bcd_result[4*i +: 4]),
                .out(disp_result[7*i +: 7])
            );
        end
    endgenerate

endmodule