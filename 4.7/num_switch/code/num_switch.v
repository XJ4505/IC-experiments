module num_switch (
    input [17: 0] SW,
    output [6: 0] HEX0
);
    num_switch_rtl num_switch_rtl_0 (
        .sel(SW[17]),
        .in(SW[3: 0]),
        .out(HEX0)
    );
endmodule