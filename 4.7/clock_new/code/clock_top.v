module clock_top #(
    parameter CLK_FREQ = 25_000_000,
    parameter HOUR = 5,
    parameter MINUTE = 3,
    parameter SECOND = 21
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
    clock #(
        .CLK_FREQ(CLK_FREQ),
        .HOUR(HOUR),
        .MINUTE(MINUTE),
        .SECOND(SECOND)
    ) u_clock (
        .clk(CLOCK_50),
        .rst(SW[0]),
        .en(SW[1]),
        .time_display({HEX7, HEX6, HEX5, HEX4, HEX1, HEX0})
    );

endmodule