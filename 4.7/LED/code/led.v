module led (
input [17:0] SW, output [17:0] LEDR );
led_rtl #(5) led_inst( .in(SW[4:0]), .dev(LEDR[4:0])
);
endmodule