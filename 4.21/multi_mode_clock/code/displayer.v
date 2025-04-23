module displayer (
    input clk,
    input alarming,
    input second_flash,
    input minute_flash,
    input hour_flash,
    input [23: 0] cur_time,

    output reg         led_signal,
    output reg [41: 0] digits
);
    reg display_en;
    reg [2: 0] digits_en; // 0: second, 1: minute, 2: hour
    always @(posedge clk) begin
        if(second_flash) begin
            digits_en[0] <= ~digits_en[0]; 
        end
        else begin
            digits_en[0] <= 1;
        end
        if(minute_flash) begin
            digits_en[1] <= ~digits_en[1]; 
        end
        else begin
            digits_en[1] <= 1;
        end
        if(hour_flash) begin
            digits_en[2] <= ~digits_en[2]; 
        end
        else begin
            digits_en[2] <= 1;
        end
        if(alarming) begin
            display_en <= ~display_en;
            led_signal <= ~led_signal;
        end
        else begin
            display_en <= 1;
            led_signal <= 0;
        end
    end

    generate
        genvar gen_i;
        for(gen_i = 0; gen_i < 3; gen_i = gen_i + 1) begin: gen_display
            bcd_displayer #(
                .BIN_WIDTH  (8),
                .BCD_CNT    (2)
            ) u_displayer (
                .en         (display_en | digits_en[gen_i]),
                .bin_code   (cur_time[gen_i*8 +: 8]),
                .disp_result(digits[gen_i*14 +: 14])
            );
        end
    endgenerate
endmodule