/*
    set the time of the clock, if user did not modify the time, the clock will keep the
    original time, otherwise, the clock will use the modified time.
    
    the modification will only happen in corresponding digit, and there won't be a carry
*/
module time_set #(
    parameter HOUR = 5,
    parameter MINUTE = 3,
    parameter SECOND = 21
)(
    input clk,         //should use the fast clock
    input set_sign,
    input en,
    input rst,
    input leave,
    input [7: 0] cur_hour,
    input [7: 0] cur_minute,
    input [7: 0] cur_second,
    input [2: 0] signal_increase, //signal to increase the time  [hour, minute, second]
    input [2: 0] signal_decrease, //signal to decrease the time
    output     [7: 0] set_hour,
    output     [7: 0] set_minute,
    output     [7: 0] set_second,
    output     [7: 0] cur_hour_modified,
    output     [7: 0] cur_minute_modified,
    output     [7: 0] cur_second_modified,
    output            modify
);
    reg modified;
    reg [7: 0] set_hour_tmp, set_minute_tmp, set_second_tmp;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            set_hour_tmp   <= 8'd2; //reset to time: 08:00:00
            set_minute_tmp <= 0;
            set_second_tmp <= 0;
            modified <= 0;
        end
        else if(set_sign) begin
            {set_hour_tmp, set_minute_tmp, set_second_tmp} <= {cur_hour, cur_minute, cur_second};
            modified <= 0;
        end
        else if(leave) begin
            modified <= 0;
        end
        else if(en) begin
            if(|signal_increase) begin
                modified <= 1;
                set_second_tmp <= signal_increase[0]? ((set_second_tmp == SECOND - 1)? 0: set_second_tmp + 1): set_second_tmp;
                set_minute_tmp <= signal_increase[1]? ((set_minute_tmp == MINUTE - 1)? 0: set_minute_tmp + 1): set_minute_tmp;
                set_hour_tmp   <= signal_increase[2]? ((set_hour_tmp   == HOUR   - 1)? 0: set_hour_tmp   + 1): set_hour_tmp;
            end
            else if(|signal_decrease) begin
                modified <= 1;
                set_second_tmp <= signal_decrease[0]? ((set_second_tmp == 0)? SECOND - 1: set_second_tmp - 1): set_second_tmp;
                set_minute_tmp <= signal_decrease[1]? ((set_minute_tmp == 0)? MINUTE - 1: set_minute_tmp - 1): set_minute_tmp;
                set_hour_tmp   <= signal_decrease[2]? ((set_hour_tmp   == 0)? HOUR   - 1: set_hour_tmp   - 1): set_hour_tmp;
            end
        end
        
    end
    assign modify = modified;//(modified & leave);
    assign {set_hour, set_minute, set_second} = {set_hour_tmp, set_minute_tmp, set_second_tmp};
    assign {cur_hour_modified, cur_minute_modified, cur_second_modified} = {set_hour_tmp, set_minute_tmp, set_second_tmp};
endmodule