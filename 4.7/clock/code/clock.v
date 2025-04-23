module clock #(
    parameter CLK_FREQ = 25_000_000, // 50MHz
    parameter HOUR = 8,
    parameter MINUTE = 12,
    parameter SECOND = 17
)(
    input CLOCK_50,
    input [17: 0] SW,
    output [6: 0] HEX0,
    output [6: 0] HEX1,
    output [6: 0] HEX4,
    output [6: 0] HEX5,
    output [6: 0] HEX6,
    output [6: 0] HEX7
);
    wire sec_sign, min_sign;

    timer #(
        .TIME_SET(SECOND),
        .CLK_SET(CLK_FREQ)
    ) sec(
        .clk(CLOCK_50),
        .rst(SW[0]),
        .en(SW[1]),
        .sign(sec_sign),
        .cur_time({HEX1, HEX0})
    );

    timer #(
        .TIME_SET(MINUTE),
        .CLK_SET(SECOND)
    ) min(
        .clk(sec_sign),
        .rst(SW[0]),
        .en(SW[1]),
        .sign(min_sign),
        .cur_time({HEX5, HEX4})
    );

    timer #(
        .TIME_SET(HOUR),
        .CLK_SET(MINUTE)
    ) hour(
        .clk(min_sign),
        .rst(SW[0]),
        .en(SW[1]),
        .cur_time({HEX7, HEX6})
    );

endmodule