module vibration_clearing_rtl (
    input       clk,
    input       rstn,
    input       tap,
    output reg  key_out1
);
    localparam IDLE = 2'b00;
    localparam FALL = 2'b01;
    localparam HOLD = 2'b10;
    localparam RISE = 2'b11;
    reg [1: 0] cur_state, next_state;
    reg timer_en, timer_rst;
    reg timeup;
    wire clk_out;

    clk_div #(
        .N(50_000)
    ) u_clk_div(
        .clk(clk),
        .rstn(1'b1),
        .clk_out(clk_out)
    );
    reg [4: 0] time_cnt;
    always @(posedge clk_out or posedge timer_rst) begin
        if(timer_rst) begin
            time_cnt <= 0;
            timeup <= 1'b0;
        end
        else if(timer_en) begin
            if(time_cnt == 5'b10100) begin
                time_cnt <= 0;
                timeup <= 1'b1;
            end
            else begin
                time_cnt <= time_cnt + 1;
            end
        end
    end
    
    always @(posedge clk_out or negedge rstn) begin
        if(!rstn) begin
            cur_state <= IDLE;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        case(cur_state)
            IDLE: begin
                if(!tap) begin
                    next_state = FALL;
                end
                else begin
                    next_state = IDLE;
                end
            end
            FALL: begin
                if(!tap && timeup) begin
                    next_state  = HOLD;
                end
                else next_state = FALL;
            end
            HOLD: begin
                if(tap) begin
                    next_state = RISE;
                end
                else begin
                    next_state = HOLD;
                end
            end
            RISE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
    
    always @(*) begin
        if(cur_state == FALL) begin
            key_out1 = 0;
            if(!tap) begin
                timer_en = 1'b1;
                timer_rst = 1'b0;
            end
            else begin
                timer_en = 1'b0;
                timer_rst = 1'b1;
            end
        end
        else begin
            if(cur_state == HOLD) begin
                key_out1 = 1;
                timer_en = 1'b0;
                timer_rst = 1'b1;
            end
            else begin
                key_out1 = 0;
                timer_en = 1'b0;
                timer_rst = 1'b1;
            end
        end
    end

endmodule