module counter_M #(
    parameter M = 8,
    parameter RESET_VALUE = 0
)(
    input clk,
    input rst,
    input en,
    input signal_increase,
    input signal_decrease,
    output reg sign,         //sign = 1 when the time is up
    output reg [ $clog2(M)-1:0] counter     //ouput the result of current count(should work together with a displayer)
);  
    // add 1 when posedege clk comes
    always @(posedge clk or posedge rst or negedge signal_increase or negedge signal_decrease) begin
        if(rst) begin
            counter <= RESET_VALUE;
        end
        else if(en || signal_increase) begin
            if(counter == M - 1) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
        else if(signal_decrease) begin
            if(counter == 0) begin
                counter <= M - 1;
            end
            else begin
                counter <= counter - 1;
            end
        end
    end

endmodule