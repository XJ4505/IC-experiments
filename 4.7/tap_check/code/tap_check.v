module tap_check (
    input [3: 0] KEY,
    output [7: 0] LEDG
);
    tap_check_rtl u_tap(
        .taps(KEY),
        .led(LEDG[3:0])
    );
endmodule