/*
    to display the time on 7-segment digits
    
    extra function:
    1. flash the corresponding digit when setting the time
    2. flash the corresponding digit whhen alarm clock is alarming
*/
module displayer (
    input clk,
    input alarming,
    input second_flash,
    input minute_flash,
    input hour_flash,
    input [23: 0] cur_time,

    output [41: 0]     digits
);
    reg [2: 0] digits_en; // 0: second, 1: minute, 2: hour
    always @(posedge clk) begin
        if(second_flash || alarming) begin
            digits_en[0] <= ~digits_en[0]; 
        end
        else begin
            digits_en[0] <= 1;
        end
        if(minute_flash || alarming) begin
            digits_en[1] <= ~digits_en[1]; 
        end
        else begin
            digits_en[1] <= 1;
        end
        if(hour_flash || alarming) begin
            digits_en[2] <= ~digits_en[2]; 
        end
        else begin
            digits_en[2] <= 1;
        end
    end

    generate
        genvar gen_i;
        for(gen_i = 0; gen_i < 3; gen_i = gen_i + 1) begin: gen_display
            bcd_displayer #(
                .BIN_WIDTH  (8),
                .BCD_CNT    (2)
            ) u_displayer (
                .en         (digits_en[gen_i]),
                .bin_code   (cur_time[gen_i*8 +: 8]),
                .disp_result(digits[gen_i*14 +: 14])
            );
        end
    endgenerate
endmodule