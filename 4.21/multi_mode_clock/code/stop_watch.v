module stop_watch #(
    parameter HOUR      = 5,
    parameter MINUTE    = 3,
    parameter SECOND    = 21
)(
    input clk,
    input rst,
    input start,
    output reg [7: 0] cur_second,
    output reg [7: 0] cur_minute,
    output reg [7: 0] cur_hour
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cur_second <= 0;
            cur_minute <= 0;
            cur_hour <= 0;
        end
        else if(start) begin
            if(cur_second == SECOND - 1) begin
                cur_second <= 0;
                if(cur_minute == MINUTE - 1) begin
                    cur_minute <= 0;
                    if(cur_hour == HOUR - 1) begin
                        cur_hour <= 0;
                    end
                    else begin
                        cur_hour <= cur_hour + 1;
                    end
                end
                else begin
                    cur_minute <= cur_minute + 1;
                end
            end
            else begin
                cur_second <= cur_second + 1;
            end
        end
    end
//TODO way to display: whether to display here or in the top module(prefered: to display in the top module)

endmodule