module clock #(
    parameter CLK_FREQ  = 25_000_000,   //frequency of second
    parameter HOUR      = 5,
    parameter MINUTE    = 3,
    parameter SECOND    = 21
)(
    input clk,
    input rst,
    input en,
    input [2: 0] signal_increase, //signal to decrease the time
    input [2: 0] signal_decrease, //signal to increase the time
    output [7: 0] cur_second,
    output [7: 0] cur_minute,
    output [7: 0] cur_hour
);
    wire clk_out;
    wire sec_sign, min_sign, hour_sign;
    wire [23: 0] cur_time;              // {hour, minute, second};
    //TODO clock: try to move the divider to the top module for performance concerns
    // clk_div #(
    //     .N      (CLK_FREQ)
    // ) u_clk_div (
    //     .clk    (clk),
    //     .rstn   (~rst),
    //     .clk_out(clk_out)
    // );

    counter_M #(
        .M      (SECOND)
    ) u_second (
        .clk    (clk),
        .rst    (rst),
        .en     (en),
        .signal_increase(signal_increase[0]),
        .signal_decrease(signal_decrease[0]),
        .sign   (sec_sign),
        .counter(cur_time[7: 0])
    );

    counter_M #(
        .M      (MINUTE)
    ) u_minute (
        .clk    (sec_sign),
        .rst    (rst),
        .en     (en),
        .signal_increase(signal_increase[1]),
        .signal_decrease(signal_decrease[1]),
        .sign   (min_sign),
        .counter(cur_time[15: 8])
    );

    counter_M #(
        .M      (HOUR),
        .RESET_VALUE (8)        //reset to time: 08:00:00
    ) u_hour (
        .clk    (min_sign),
        .rst    (rst),
        .en     (en),
        .signal_increase(signal_increase[2]),
        .signal_decrease(signal_decrease[2]),
        .sign   (hour_sign),
        .counter(cur_time[23: 16])
    );
    assign {cur_hour, cur_minute, cur_second} = cur_time;
//TODO way to display: whether to display here or in the top module  
    // generate
    //     genvar gen_i;
    //     for(gen_i = 0; gen_i < 3; gen_i = gen_i + 1) begin: gen_display
    //         bcd_displayer #(
    //             .BIN_WIDTH  (8),
    //             .BCD_CNT    (2)
    //         ) u_displayer (
    //             .bin_cod    (cur_time[gen_i*8 +: 8]),
    //             .disp_result(time_display[gen_i*14 +: 14])
    //         );
    //     end
    // endgenerate


endmodule