module number_display (
    input sel,            //1: display in hexadecimal, 0: display in decimal
    input [3: 0] in,
    input en,
    output reg [6: 0] out
);
    reg [6: 0] out_tmp;
    parameter in0 = 7'b1000000;
    parameter in1 = 7'b1111001;
    parameter in2 = 7'b0100100;
    parameter in3 = 7'b0110000;
    parameter in4 = 7'b0011001;
    parameter in5 = 7'b0010010;
    parameter in6 = 7'b0000010;
    parameter in7 = 7'b1111000;
    parameter in8 = 7'b0000000;
    parameter in9 = 7'b0010000;
    parameter in10 =7'b0001000;
    parameter in11 =7'b0000011;
    parameter in12 =7'b1000110;
    parameter in13 =7'b0100001;
    parameter in14 =7'b0000110;
    parameter in15 =7'b0001110;
    always @(*) begin
        case(in)
            4'b0000: out_tmp = in0;
            4'b0001: out_tmp = in1;
            4'b0010: out_tmp = in2;
            4'b0011: out_tmp = in3;
            4'b0100: out_tmp = in4;
            4'b0101: out_tmp = in5;
            4'b0110: out_tmp = in6;
            4'b0111: out_tmp = in7;
            4'b1000: out_tmp = in8;
            4'b1001: out_tmp = in9;
            4'b1010: out_tmp = in10;
            4'b1011: out_tmp = in11;
            4'b1100: out_tmp = in12;
            4'b1101: out_tmp = in13;
            4'b1110: out_tmp = in14;
            4'b1111: out_tmp = in15;
            default: out_tmp = 7'b1111111;
        endcase
    end
    always @(*) begin
        if(en)begin
            if(sel || in < 10) begin
                out = out_tmp;
            end
            else begin
                out = 7'b1111111;
            end
        end
        else begin
            out = 7'b1111111;
        end
    end
endmodule