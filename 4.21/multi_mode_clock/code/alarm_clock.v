module alarm_clock #(
    parameter HOUR = 5,
    parameter MINUTE = 3,
    parameter SECOND = 21
)(
    input clk,
    input rst,
    input en,
    input dis_alarm, //turn it off!
    input [2: 0] signal_increase,
    input [2: 0] signal_decrease,

    input [7: 0] cur_second,
    input [7: 0] cur_minute,
    input [7: 0] cur_hour,

    output reg [7: 0] set_second,
    output reg [7: 0] set_minute,
    output reg [7: 0] set_hour,
    output reg        alarming
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            set_second <= 0;
            set_minute <= 0;
            set_hour <= 8'd2; //reset to time: 02:00:00
            alarming <= 0;
        end
        else begin
            if(en) begin
                if({cur_hour, cur_minute, cur_second} == {set_hour, set_minute, set_second}) begin
                    alarming <= 1;
                end
                else if(dis_alarm) begin
                    alarming <= 0;
                end
            end
            else begin
                alarming <= 0;
            end
            if(|signal_increase) begin
                set_second <= signal_increase[0]? ((set_second == SECOND - 1)? 0: set_second + 1): set_second;
                set_minute <= signal_increase[1]? ((set_minute == MINUTE - 1)? 0: set_minute + 1): set_minute;
                set_hour   <= signal_increase[2]? ((set_hour   == HOUR   - 1)? 0: set_hour   + 1): set_hour;
            end
            else if(|signal_decrease) begin
                set_second <= signal_decrease[0]? ((set_second == 0)? SECOND - 1: set_second - 1): set_second;
                set_minute <= signal_decrease[1]? ((set_minute == 0)? MINUTE - 1: set_minute - 1): set_minute;
                set_hour   <= signal_decrease[2]? ((set_hour   == 0)? HOUR   - 1: set_hour   - 1): set_hour;
            end
        end
    end
endmodule