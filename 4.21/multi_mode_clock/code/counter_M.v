module counter_M #(
    parameter M = 8,
    parameter RESET_VALUE = 8'b0
)(
    input clk,
    input rst,
    input en,
    input modify,
    input [7: 0] modified_value,
    output reg sign,         //sign = 1 when the time is up
    output reg [7: 0] counter     //ouput the result of current count(should work together with a displayer)
);  
    // add 1 when posedege clk comes
    always @(posedge clk or posedge rst or posedge modify) begin
        if(rst) begin
            counter <= RESET_VALUE;
            sign <= 0;
        end
        else if(modify) begin
            counter <= modified_value;
            sign <= 0;
        end
        else if(en) begin
            if(counter == M - 1) begin
                counter <= 0;
                sign <= 1;
            end
            else begin
                counter <= counter + 1;
                sign <= 0;
            end
        end
    end
endmodule