module stop_watch #(
    parameter HOUR      = 5,
    parameter MINUTE    = 3,
    parameter SECOND    = 21,
    parameter N         = 25_000_000
)(
    input clk,
    input rst,
    input start,
    input [3: 0] cur_state,
    output reg [7: 0] cur_second,
    output reg [7: 0] cur_minute,
    output reg [7: 0] cur_hour
);
    wire clk_out;//clock of the stop watch (real time)
    //to seperate the clock of the stop watch and the clock of the system
    //make sure the stop watch start or stop immediately when start signal changes
    clk_div #(
        .N 	(N  )
        ) u_clk_div (
        .clk     	(clk),
        .en     	(start),
        .rstn    	(~rst),
        .clk_out 	(clk_out)
    );
    
    always @(posedge clk_out or posedge rst) begin
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

endmodule