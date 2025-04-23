module multi_clock_top #(
    parameter ORI_CLK_FREQ = 50_000_000,//1s = 50MHz
    parameter HOUR = 5,     //5 hours a day
    parameter MINUTE = 3,   //3 minutes an hour
    parameter SECOND = 21   //21 seconds a minute
)(
    input CLOCK_50,
    input [3: 0] KEY,
    input [17: 0] SW,
/*
    SW[17] top reset
    SW[16] clock reset
    SW[15] alarm reset
    SW[14] stop watch reset

    SW[2] clock enable
    SW[1] alarm enable
    SW[0] stop watch enable
*/
    output [3: 0] LEDG,
    output [6: 0] HEX0,
    output [6: 0] HEX1,
    output [6: 0] HEX2,
    output [6: 0] HEX3,
    output [6: 0] HEX4,
    output [6: 0] HEX5,
    output [6: 0] HEX6,
    output [6: 0] HEX7
);
    
    localparam CLOCK            = 4'd0;
    localparam TIMESET          = 4'd1;
    localparam TIMESET_second   = 4'd2;
    localparam TIMESET_minute   = 4'd3;
    localparam TIMESET_hour     = 4'd4;
    localparam STOPWATCH        = 4'd5;
    localparam ALARM            = 4'd6;
    localparam ALARM_second     = 4'd7;
    localparam ALARM_minute     = 4'd8;
    localparam ALARM_hour       = 4'd9;
    wire clk_out;
    reg [1: 0] cur_state, next_state;
    
    //reset and enable signals
    wire top_rst        = SW[17];
    wire clock_rst      = SW[16];
    wire alarm_rst      = SW[15];
    wire stopwatch_rst  = SW[14];
    wire clock_en       = SW[2];
    wire alarm_en       = SW[1];
    reg stopwatch_en;
    /*
        reset and enable logic:
        (all of them are active high)
        1. top_rst: reset all modules and change to CLOCK state
        2. the enable of stopwatch can only be done when FSM is in STOPWATCH state
        3. other signals are not restricted by FSM state
    */
    
    reg [23: 0] time_display;   //time displayed on digits
    reg [2: 0]  clock_increase, clock_decrease, alarm_increase, alarm_decrease;//adjustment signals
    reg second_flash, minute_flash, hour_flash;//when set time, the corresponding digit will flash
    
    //time of different modules
    wire [7: 0] clock_second, clock_minute, clock_hour;
    wire [7: 0] stopwatch_second, stopwatch_minute, stopwatch_hour;
    wire [7: 0] alarm_second, alarm_minute, alarm_hour;

    wire alarm_signal;      //alarm signal: when time is up, put to high
    wire dis_alarm = ~KEY[1];//press to disable alarm

//real clock
    clk_div #(
        .N 	        (ORI_CLK_FREQ)  
    ) u_clk_div (
        .clk     	(CLOCK_50 ),
        .rstn    	(1'b1     ),
        .clk_out 	(clk_out  )
    );

//FSM
    always @(posedge clk_out or posedge top_rst) begin
        if(SW[17]) begin
            cur_state <= CLOCK;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        case(cur_state)
            CLOCK: begin
                if(!KEY[0]) begin
                    next_state = TIMESET; 
                end
            end
            TIMESET: begin
                if(!KEY[0]) begin
                    next_state = STOPWATCH;
                end
                else if(!KEY[1]) begin
                    next_state = TIMESET_hour;
                end
            end
            TIMESET_hour: begin
                if(!KEY[0]) begin
                    next_state = STOPWATCH;
                end
                else if(!KEY[1]) begin
                    next_state = TIMESET_minute;
                end
            end
            TIMESET_minute: begin
                if(!KEY[0]) begin
                    next_state = STOPWATCH;
                end
                else if(!KEY[1]) begin
                    next_state = TIMESET_second;
                end
            end
            TIMESET_second: begin
                if(!KEY[0]) begin
                    next_state = STOPWATCH;
                end
                else if(!KEY[1]) begin
                    next_state = TIMESET_hour;
                end
            end
            STOPWATCH: begin
                if(!KEY[0]) begin
                    next_state = ALARM;
                end
            end
            ALARM: begin
                if(!KEY[0]) begin
                    next_state = CLOCK;
                end
                else if(!KEY[1]) begin
                    next_state = ALARM_hour;
                end
            end
            ALARM_hour: begin
                if(!KEY[0]) begin
                    next_state = CLOCK;
                end
                else if(!KEY[1]) begin
                    next_state = ALARM_minute;
                end
            end
            ALARM_minute: begin
                if(!KEY[0]) begin
                    next_state = CLOCK;
                end
                else if(!KEY[1]) begin
                    next_state = ALARM_second;
                end
            end
            ALARM_second: begin
                if(!KEY[0]) begin
                    next_state = CLOCK;
                end
                else if(!KEY[1]) begin
                    next_state = ALARM_hour;
                end
            end
            default: begin
                next_state = CLOCK;
            end
        endcase
    end
    always @(posedge clk_out or posedge top_rst) begin
        if(top_rst) begin
            clock_increase <= 3'b000;
            clock_decrease <= 3'b000;
            alarm_increase <= 3'b000;
            alarm_decrease <= 3'b000;
            stopwatch_en <= 1'b0;
            time_display <= {clock_hour, clock_minute, clock_second};
            {second_flash, minute_flash, hour_flash} <= 3'b000;
        end
        else begin
            case(cur_state)
            CLOCK: begin
                time_display <= {clock_hour, clock_minute, clock_second};
            end
            TIMESET_hour: begin
                time_display <= {clock_hour, clock_minute, clock_second};
                hour_flash <= 1'b1;
                if(!KEY[2]) begin
                    clock_increase <= 3'b100;
                end
                else if(!KEY[3]) begin
                    clock_decrease <= 3'b100;
                end
            end
            TIMESET_minute: begin
                time_display <= {clock_hour, clock_minute, clock_second};
                minute_flash <= 1'b1;
                if(!KEY[2]) begin
                    clock_increase <= 3'b010;
                end
                else if(!KEY[3]) begin
                    clock_decrease <=3'b010;
                end
            end
            TIMESET_second: begin
                time_display <= {clock_hour, clock_minute, clock_second};
                second_flash <= 1'b1;
                if(!KEY[2]) begin
                    clock_increase <= 3'b001;
                end
                else if(!KEY[3]) begin
                    clock_decrease <=3'b001;
                end
            end
            STOPWATCH: begin
                time_display <= {stopwatch_hour, stopwatch_minute, stopwatch_second};
                stopwatch_en <= SW[0];
                {second_flash, minute_flash, hour_flash} <= 3'b000;
            end
            ALARM: begin
                time_display <= {alarm_hour, alarm_minute, alarm_second};
            end
            ALARM_hour: begin
                time_display <= {alarm_hour, alarm_minute, alarm_second};
                hour_flash <= 1'b1;
                if(!KEY[2]) begin
                    alarm_increase <= 3'b100;
                end
                else if(!KEY[3]) begin
                    alarm_decrease <= 3'b100;
                end
            end
            ALARM_minute: begin
                time_display <= {alarm_hour, alarm_minute, alarm_second};
                minute_flash <= 1'b1;
                if(!KEY[2]) begin
                    alarm_increase <= 3'b010;
                end
                else if(!KEY[3]) begin
                    alarm_decrease <=3'b010;
                end
            end
            ALARM_second: begin
                time_display <= {alarm_hour, alarm_minute, alarm_second};
                second_flash <= 1'b1;
                if(!KEY[2]) begin
                    alarm_increase <= 3'b001;
                end
                else if(!KEY[3]) begin
                    alarm_decrease <=3'b001;
                end
            end
            endcase
        end
    end
//FSM end

//module clock
    
    clock #(
        .HOUR           (HOUR),
        .MINUTE         (MINUTE),
        .SECOND         (SECOND)
    ) u_clock (
        .clk            (clk_out),
        .rst            (top_rst | clock_rst),
        .en             (clock_en),
        .signal_increase(clock_increase),
        .signal_decrease(clock_decrease),
        .cur_second     (clock_second),
        .cur_minute     (clock_minute),
        .cur_hour       (clock_hour)
    );

//module stop-watch
    stop_watch #(
        .HOUR           (HOUR),
        .MINUTE         (MINUTE),
        .SECOND         (SECOND)
    ) u_stop_watch (
        .clk            (clk_out),
        .rst            (top_rst | stopwatch_rst),
        .start          (stopwatch_en),
        .cur_second     (stopwatch_second),
        .cur_minute     (stopwatch_minute),
        .cur_hour       (stopwatch_hour)
    );

//module alarm-clock
    alarm_clock #(
        .HOUR           (HOUR),
        .MINUTE         (MINUTE),
        .SECOND         (SECOND)
    ) u_alarm_clock (
        .clk            (clk_out),
        .rst            (top_rst | alarm_rst),
        .en             (alarm_en),
        .dis_alarm      (dis_alarm),
        .signal_increase(alarm_increase),
        .signal_decrease(alarm_decrease),
        .cur_second     (clock_second),
        .cur_minute     (clock_minute),
        .cur_hour       (clock_hour),
        .set_second     (alarm_second),
        .set_minute     (alarm_minute),
        .set_hour       (alarm_hour),
        .alarming       (alarm_signal)
    );

//module displayer
    wire led_signal;
    displayer u_displayer (
        .clk            (clk_out),
        .alarming       (alarm_signal),
        .second_flash   (second_flash),
        .minute_flash   (minute_flash),
        .hour_flash     (hour_flash),
        .cur_time       (time_display),
        .led_signal     (led_signal),
        .digits         ({HEX7, HEX6, HEX5, HEX4, HEX3, HEX2})
    );
    assign HEX0 = alarm_en? 7'b0100011: 7'b1111111; //when alarm is on, show:  o
    assign LEDG = {4{led_signal}};
endmodule