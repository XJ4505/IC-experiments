module counter_M #(
    parameter M = 8
)(
    input clk,
    input rst,
    input en,
    output reg sign,         //sign = 1 when the time is up
    output reg [ $clog2(M)-1:0] counter     //ouput the result of current count(should work together with a displayer)
);  
    // add 1 when posedege clk comes
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            counter <= 0;
        end
        else if(en) begin
            if(counter == M - 1) begin
                counter <= 0;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule