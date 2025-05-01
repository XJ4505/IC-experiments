module multi_clock_top #(
    parameter REAL_CLK = 25_000_000,//1s = 50M cycles
    parameter HOUR = 5,     //5 hours a day
    parameter MINUTE = 3,   //3 minutes an hour
    parameter SECOND = 21   //21 seconds a minute
)(
    input CLOCK_50,//50MHz clock
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

    KEY[0]: mode switch (clock->time set->stop watch->alarm->clock)
    KEY[1]: time set switch (hour->minute->second->hour)
    KEY[2]: increase
    KEY[3]: decrease
    all the KEY are low when pressed
*/
    output [3: 0] LEDG,
    output [6: 0] HEX0,
    output [6: 0] HEX2,
    output [6: 0] HEX3,
    output [6: 0] HEX4,
    output [6: 0] HEX5,
    output [6: 0] HEX6,
    output [6: 0] HEX7,
    
    output reg [6: 0] HEX1//for debugging for now
);
    
    localparam CLOCK            = 4'b0000;//4'd0;
    localparam TIMESET          = 4'b0001;//4'd1;
    localparam TIMESET_second   = 4'b0011;//4'd2;
    localparam TIMESET_minute   = 4'b0010;//4'd3;
    localparam TIMESET_hour     = 4'b0110;//4'd4;
    localparam STOPWATCH        = 4'b0111;//4'd5;
    localparam ALARM            = 4'b0101;//4'd6;
    localparam ALARM_second     = 4'b0100;//4'd7;
    localparam ALARM_minute     = 4'b1100;//4'd8;
    localparam ALARM_hour       = 4'b1101;//4'd9;
    
    wire clk_out;
    reg [3: 0] cur_state, next_state;
    
    //reset and enable signals
    wire top_rst        = SW[17];
    wire clock_rst      = SW[16];
    wire alarm_rst      = SW[15];
    wire stopwatch_rst  = SW[14];
    wire clock_en       = SW[2];
    wire alarm_en       = SW[1];
    wire stopwatch_en   = SW[0];
    wire dis_alarm      = SW[3];//switch to disable alarm
    wire [3: 0] vb_key;
    /*
        reset and enable logic:
        (all of them are active high)
        1. top_rst: reset all modules and change to CLOCK state
        2. other signals are not restricted by FSM state
    */
    
    reg [23: 0] time_display;   //time displayed on digits
    reg [2: 0]  clock_increase, clock_decrease, alarm_increase, alarm_decrease;//adjustment signals
    reg [2: 0]  flash_sign;//when set time, the corresponding digit will flash: [hour, minute, second]
    
    //time of different modules
    wire [7: 0] clock_second, clock_minute, clock_hour;
    wire [7: 0] set_second, set_minute, set_hour;
    wire [7: 0] stopwatch_second, stopwatch_minute, stopwatch_hour;
    wire [7: 0] alarm_second, alarm_minute, alarm_hour;
    wire [7: 0] cur_hour_modified, cur_minute_modified, cur_second_modified;

    reg set_sign;// when FSM change frim CLOCK to TIMESET, set_sign = 1, otherwise = 0
    reg en_settime;//enabled when in TIMESET_. state
    reg leave;//when leaving TIMESET_. , set to 1
    
    wire modify;
    wire alarm_signal;      //alarm signal: when time is up, put to high
    
//real clock
    clk_div #(
        .N 	        (REAL_CLK)  
    ) u_clk_div (
        .clk     	(CLOCK_50 ),
        .en     	(1'b1     ),
        .rstn    	(1'b1     ),
        .clk_out 	(clk_out  )
    );
//vibration clear
    generate
        genvar i;
        for(i = 0; i < 4; i = i + 1) begin: gen_vb
            vibration_clearing u_vb (
                .clk        (CLOCK_50),
                .rstn       (~top_rst),
                .tap        (KEY[i]),
                .key_out1   (vb_key[i])
            );
        end
    endgenerate

//FSM
    always @(posedge CLOCK_50 or posedge top_rst) begin
        if(top_rst) begin
            cur_state <= CLOCK;
        end
        else begin
            cur_state <= next_state;
        end
    end

    always @(*) begin
        case(cur_state)
            CLOCK: begin
                if(~vb_key[0]) begin
                    next_state = TIMESET; 
                end
                else begin
                    next_state = CLOCK;
                end
            end
            TIMESET: begin
                if(~vb_key[0]) begin
                    next_state = STOPWATCH;
                end
                else if(~vb_key[1]) begin
                    next_state = TIMESET_hour;
                end
                else begin
                    next_state = TIMESET;
                end
            end
            TIMESET_hour: begin
                if(~vb_key[0]) begin
                    next_state = STOPWATCH;
                end
                else if(~vb_key[1]) begin
                    next_state = TIMESET_minute;
                end
                else begin
                    next_state = TIMESET_hour;
                end
            end
            TIMESET_minute: begin
                if(~vb_key[0]) begin
                    next_state = STOPWATCH;
                end
                else if(~vb_key[1]) begin
                    next_state = TIMESET_second;
                end
                else begin
                    next_state = TIMESET_minute;
                end
            end
            TIMESET_second: begin
                if(~vb_key[0]) begin
                    next_state = STOPWATCH;
                end
                else if(~vb_key[1]) begin
                    next_state = TIMESET_hour;
                end
                else begin
                    next_state = TIMESET_second;
                end
            end
            STOPWATCH: begin
                if(~vb_key[0]) begin
                    next_state = ALARM;
                end
                else begin
                    next_state = STOPWATCH;
                end
            end
            ALARM: begin
                if(~vb_key[0]) begin
                    next_state = CLOCK;
                end
                else if(~vb_key[1]) begin
                    next_state = ALARM_hour;
                end
                else begin
                    next_state = ALARM;
                end
            end
            ALARM_hour: begin
                if(~vb_key[0]) begin
                    next_state = CLOCK;
                end
                else if(~vb_key[1]) begin
                    next_state = ALARM_minute;
                end
                else begin
                    next_state = ALARM_hour;
                end
            end
            ALARM_minute: begin
                if(~vb_key[0]) begin
                    next_state = CLOCK;
                end
                else if(~vb_key[1]) begin
                    next_state = ALARM_second;
                end
                else begin
                    next_state = ALARM_minute;
                end
            end
            ALARM_second: begin
                if(~vb_key[0]) begin
                    next_state = CLOCK;
                end
                else if(~vb_key[1]) begin
                    next_state = ALARM_hour;
                end
                else begin
                    next_state = ALARM_second;
                end
            end
            default: begin
                next_state = CLOCK;
            end
        endcase
    end

//FSM check --temporarily (for debugging)
    //keep it to indicate the current state
    always @(*) begin
        case(cur_state)
            CLOCK:          HEX1 = 7'b1000000;
            TIMESET:        HEX1 = 7'b1111001;
            TIMESET_hour:   HEX1 = 7'b0100100;
            TIMESET_minute: HEX1 = 7'b0110000;
            TIMESET_second: HEX1 = 7'b0011001;
            STOPWATCH:      HEX1 = 7'b0010010;
            ALARM:          HEX1 = 7'b0000010;
            ALARM_hour:     HEX1 = 7'b1111000;
            ALARM_minute:   HEX1 = 7'b0000000;
            ALARM_second:   HEX1 = 7'b0010000;
            default:        HEX1 = 7'b1111111;
        endcase
    end

//display time
    always @(*) begin
        case(cur_state)
            CLOCK: time_display = {clock_hour, clock_minute, clock_second};
            TIMESET,
            TIMESET_hour,
            TIMESET_minute,
            TIMESET_second: time_display = {set_hour, set_minute, set_second};
            
            STOPWATCH: time_display = {stopwatch_hour, stopwatch_minute, stopwatch_second};
            
            ALARM,
            ALARM_hour,
            ALARM_minute,
            ALARM_second: time_display = {alarm_hour, alarm_minute, alarm_second};

            default: time_display = {clock_hour, clock_minute, clock_second};
        endcase
    end

//increase and decrease
    //(mealy)time set logic: 
    always @(*) begin
        //CLOCK->TIMESET: cur_time ===> set_time
        if(cur_state == CLOCK && ~vb_key[0]) begin
            set_sign = 1;
        end
        else begin
            set_sign = 0;
        end
        //TIMESET->CLOCK: set_time ===> cur_time
        if(~vb_key[0] && (cur_state == TIMESET || cur_state == TIMESET_hour || cur_state == TIMESET_minute || cur_state == TIMESET_second)) begin
            leave = 1;
        end
        else begin
            leave = 0;
        end
        case(cur_state)
            TIMESET,
            TIMESET_hour,
            TIMESET_minute,
            TIMESET_second: en_settime = 1;
            default: en_settime = 0;
        endcase
    end
    //increase and decrease signals:
    always @(*) begin
        case(cur_state)
            TIMESET_hour: begin
                clock_increase = {~vb_key[2], 1'b0, 1'b0};
                clock_decrease = {~vb_key[3], 1'b0, 1'b0};
                alarm_increase = 3'b0;
                alarm_decrease = 3'b0;
                flash_sign = 3'b100;
            end
            TIMESET_minute: begin
                clock_increase = {1'b0, ~vb_key[2], 1'b0};
                clock_decrease = {1'b0, ~vb_key[3], 1'b0};
                alarm_increase = 3'b0;
                alarm_decrease = 3'b0;
                flash_sign = 3'b010;
            end
            TIMESET_second: begin
                clock_increase = {1'b0, 1'b0, ~vb_key[2]};
                clock_decrease = {1'b0, 1'b0, ~vb_key[3]};
                alarm_increase = 3'b0;
                alarm_decrease = 3'b0;
                flash_sign = 3'b001;
            end
            ALARM_hour: begin
                alarm_increase = {~vb_key[2], 1'b0, 1'b0};
                alarm_decrease = {~vb_key[3], 1'b0, 1'b0};
                clock_increase = 3'b0;
                clock_decrease = 3'b0;
                flash_sign = 3'b100;
            end
            ALARM_minute: begin
                alarm_increase = {1'b0, ~vb_key[2], 1'b0};
                alarm_decrease = {1'b0, ~vb_key[3], 1'b0};
                clock_increase = 3'b0;
                clock_decrease = 3'b0;
                flash_sign = 3'b010;
            end
            ALARM_second: begin
                alarm_increase = {1'b0, 1'b0, ~vb_key[2]};
                alarm_decrease = {1'b0, 1'b0, ~vb_key[3]};
                clock_increase = 3'b0;
                clock_decrease = 3'b0;
                flash_sign = 3'b001;
            end
            default: begin
                clock_increase = 3'b000;
                clock_decrease = 3'b000;
                alarm_increase = 3'b000;
                alarm_decrease = 3'b000;
                flash_sign = 3'b000;
            end
        endcase
    end

//end of FSM

//module clock
    clock #(
        .HOUR           (HOUR),
        .MINUTE         (MINUTE),
        .SECOND         (SECOND)
    ) u_clock (
        .clk            (clk_out),
        .rst            (top_rst | clock_rst),
        .en             (clock_en),
        .modify         (modify),
        .cur_hour_modified (cur_hour_modified),
        .cur_minute_modified(cur_minute_modified),
        .cur_second_modified(cur_second_modified),
        .cur_second     (clock_second),
        .cur_minute     (clock_minute),
        .cur_hour       (clock_hour)
    );

//module set-time
    time_set #(
        .HOUR(HOUR),
        .MINUTE(MINUTE),
        .SECOND(SECOND)
    ) u_time_set (
        .clk                (CLOCK_50),
        .set_sign           (set_sign),
        .en                 (en_settime),
        .leave              (leave),
        .cur_hour           (clock_hour),
        .cur_minute         (clock_minute),
        .cur_second         (clock_second),
        .signal_increase    (clock_increase),
        .signal_decrease    (clock_decrease),
        .set_hour           (set_hour),
        .set_minute         (set_minute),
        .set_second         (set_second),
        .cur_hour_modified  (cur_hour_modified),
        .cur_minute_modified(cur_minute_modified),
        .cur_second_modified(cur_second_modified),
        .modify             (modify)
    );

//module stop-watch
    stop_watch #(
        .HOUR           (HOUR),
        .MINUTE         (MINUTE),
        .SECOND         (SECOND),
        .N              (REAL_CLK)
    ) u_stop_watch (
        .clk            (CLOCK_50),
        .rst            (top_rst | stopwatch_rst),
        .cur_state      (cur_state),
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
        .clk            (CLOCK_50),
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
        .second_flash   (flash_sign[0]),
        .minute_flash   (flash_sign[1]),
        .hour_flash     (flash_sign[2]),
        .cur_time       (time_display),
        .digits         ({HEX7, HEX6, HEX5, HEX4, HEX3, HEX2})
    );
    assign HEX0 = alarm_en? 7'b0100011: 7'b1111111; //when alarm is on, show:  o
    //assign LEDG = {4{led_signal}};
    assign LEDG[0] = modify;//to show if the time is modified
    assign LEDG[1] = stopwatch_en;//if the stopwatch is on

endmodule