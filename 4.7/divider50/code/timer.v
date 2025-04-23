module timer #(
    parameter TIME_SET = 30,        //total time(based on clk frequency)
    parameter CLK_SET = 5_000_000 //clk fraquency(50MHz = 1s etc.)
)(
    input CLOCK_50,
    input [17: 0] SW,
    output [6: 0] HEX0,
    output [6: 0] HEX1
);
    timer_rtl #(
        .TIME_SET(TIME_SET),
        .CLK_SET(CLK_SET)
    ) u_timer(
        .clk(CLOCK_50),
        .rst(SW[0]),
        .en(SW[1]),
        .cur_time({HEX1, HEX0})
    );
endmodule