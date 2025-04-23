//to realise a 50% clock divider
module clk_div #(
    parameter N = 2     //represent how many clk cycles the new clk takes in one clk cycle
    )(
    input       clk,
    input       en,        
    input       rstn,      
    output      clk_out
);
    reg [$clog2(N) - 1: 0] cnt;
    reg pos_clk, neg_clk;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt <= 0;
        end
        else if(en) begin
            if(cnt < N - 1) begin
                cnt <= cnt + 1'b1;
            end 
            else begin
                cnt <= 0;
            end
        end
        else begin 
            cnt <= cnt;
        end
    end
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            pos_clk <= 1'b0;
        end
        else if(en) begin
            if(cnt < ((N + 1)>> 1)) begin
                pos_clk <= 1'b1;
            end
            else begin
                pos_clk <= 1'b0;
            end
        end    
        else begin
            pos_clk <= pos_clk;
        end
        
    end

    always @(negedge clk or negedge rstn) begin
        if(!rstn) begin
            neg_clk <= 1'b0;
        end
        else if(en) begin 
            if(N[0] ^ 1'b1) begin         
                neg_clk <= 1'b1;        //don't need it when N is odd
            end
            else if(cnt < ((N + 1)>> 1)) begin
                neg_clk <= 1'b1;
            end
            else begin
                neg_clk <= 1'b0;
            end
        end
        else begin
            neg_clk <= neg_clk;
        end
    end

    assign clk_out = pos_clk & neg_clk;
endmodule