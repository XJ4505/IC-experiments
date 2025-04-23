module tap_check_rtl (
    input [3: 0] taps,
    output [3: 0] led
);
    assign led = taps;
endmodule