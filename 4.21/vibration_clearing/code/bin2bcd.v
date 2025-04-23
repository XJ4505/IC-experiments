module bin2bcd #(
    parameter BIN_WIDTH = 8,
    parameter BCD_CNT = 3
)(
    input [BIN_WIDTH - 1: 0] bin_code,
    output [BCD_CNT*4 - 1: 0] bcd_code
);
    reg [BIN_WIDTH + BCD_CNT*4: 0] temp_bcd;
    integer i, j;

    always @(*) begin
        temp_bcd = {{(BCD_CNT*4){1'b0}}, bin_code};
        for(j = 0; j < BIN_WIDTH; j = j + 1) begin
            for(i = 1; i <= BCD_CNT; i = i + 1) begin
                if(temp_bcd[(BIN_WIDTH + 4*i - 1) -: 4] >= 5) begin
                    temp_bcd[(BIN_WIDTH + 4*i - 1) -: 4] = temp_bcd[(BIN_WIDTH + 4*i - 1) -: 4] + 5'b00011;
                end
                else begin
                    temp_bcd[(BIN_WIDTH + 4*i - 1) -: 4] = temp_bcd[(BIN_WIDTH + 4*i - 1) -: 4];
                end
            end
            temp_bcd = temp_bcd << 1;
        end
    end
    assign bcd_code = temp_bcd[BIN_WIDTH + BCD_CNT*4 - 1: BIN_WIDTH];
endmodule