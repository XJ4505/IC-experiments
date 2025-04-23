module timer #(
    parameter TIME_SET = 99,        //total time(based on clk frequency)
    parameter CLK_SET = 50_000_000 //clk fraquency(50MHz = 1s etc.)
)(
    input clk,
    input rst,
    input en,
    output clk_out,
    output sign,
    output [13: 0] cur_time
);
    clk_div #(
        .N      (CLK_SET        )
    )u_clk_div(
        .clk    (clk    ),
        .en     (en),
        .rstn   (~rst   ),
        .clk_out(clk_out)
    );

    wire [7: 0] counter;
    counter_M #(
        .M(TIME_SET)
    ) u_counter(
        .clk(clk_out),
        .rst(rst),
        .en(en),
        .counter(counter)
    );
    bcd_displayer #(
        .BIN_WIDTH(8),
        .BCD_CNT(2)
    ) u_displayer(
        .bin_code(counter),
        .disp_result(cur_time)
    );
    assign sign = (counter == TIME_SET - 1) ? 1'b1 : 1'b0; //sign = 1 when the time is up

endmodule