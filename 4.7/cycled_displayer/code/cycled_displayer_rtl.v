module cycled_displayer_rtl #(
    parameter FREQ = 2_000_000     //current one is 25 frames per sec.  0.5s: 25_000_000Hz
)(
    input clk,
    input rst,
    input en,

    output reg [55: 0] digits,
    output reg [7: 0] led
);
    localparam char_B = 7'b0000000;
    localparam char_U = 7'b1000001;
    localparam char_A = 7'b0001000;
    localparam char_2 = 7'b0100100;
    localparam char_0 = 7'b1000000;
    localparam char_5 = 7'b0010010;
    localparam char_1 = 7'b1111001;
    localparam char_9 = 7'b0010000;
    localparam space  = 7'b1111111;
    localparam dash   = 7'b0111111;

    wire real_clk;
    reg [104: 0] cur_disp;
    reg [14: 0] cur_led;
    clk_div #(
        .N(FREQ)
    ) u_clk(
        .clk(clk),
        .en(en),
        .rstn(~rst),
        .clk_out(real_clk)
    );
    
    always @(posedge real_clk or posedge rst) begin
        if(rst) begin
            digits <= 56'hFF_FF_FF_FF_FF_FF_FF;     //digits off
            led <= 0;
            //display: BUAA 1952-2025 
            cur_disp <= {char_B, char_U, char_A, char_A, space, char_1, char_9, char_5, char_2, dash, char_2, char_0, char_2, char_5, space};
            cur_led <= 15'b1111_00000000000;
        end
        else if(en) begin
            digits <= {digits[48: 0], cur_disp[104: 98]};
            led <= {led[6: 0], cur_led[14]};
            cur_disp <= {cur_disp[97: 0], cur_disp[104: 98]};
            cur_led <= {cur_led[13: 0], cur_led[14]};
        end
        else begin
            digits <= digits;
            led <= led;
        end
    end
endmodule