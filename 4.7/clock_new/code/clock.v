module clock #(
    parameter CLK_FREQ  = 25_000_000,   //frequency of second
    parameter HOUR      = 5,
    parameter MINUTE    = 3,
    parameter SECOND    = 21
)(
    input clk,
    input rst,
    input en,
    output [41: 0] time_display         //HH: MM: SS (7*2bits each)
);
    wire clk_out;
    wire sec_sign, min_sign, hour_sign;
    wire [23: 0] cur_time;              // {hour, minute, second};
    clk_div #(
        .N      (CLK_FREQ)
    ) u_clk_div (
        .clk    (clk),
        .rstn   (~rst),
        .clk_out(clk_out)
    );

    counter_M #(
        .M      (SECOND)
    ) u_second (
        .clk    (clk_out),
        .rst    (rst),
        .en     (en),
        .sign   (sec_sign),
        .counter(cur_time[7: 0])
    );

    counter_M #(
        .M      (MINUTE)
    ) u_minute (
        .clk    (sec_sign),
        .rst    (rst),
        .en     (en),
        .sign   (min_sign),
        .counter(cur_time[15: 8])
    );

    counter_M #(
        .M      (HOUR)
    ) u_hour (
        .clk    (min_sign),
        .rst    (rst),
        .en     (en),
        .sign   (hour_sign),
        .counter(cur_time[23: 16])
    );

    generate
        genvar gen_i;
        for(gen_i = 0; gen_i < 3; gen_i = gen_i + 1) begin: gen_display
            bcd_displayer #(
                .BIN_WIDTH  (8),
                .BCD_CNT    (2)
            ) u_displayer (
                .bin_cod    (cur_time[gen_i*8 +: 8]),
                .disp_result(time_display[gen_i*14 +: 14])
            );
        end
    endgenerate


endmodule