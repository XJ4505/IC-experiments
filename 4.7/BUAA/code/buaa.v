module buaa(
    input [17:0] SW, 
    output [6:0] HEX0, 
    output [6:0] HEX1, 
    output [6:0] HEX2, 
    output [6:0] HEX3, 
    output [6:0] HEX4, 
    output [6:0] HEX5, 
    output [6:0] HEX6, 
    output [6:0] HEX7 
    );

buaa_rtl inst1 ( 
    .ctrl(SW[17: 10]),
    .dev0(HEX0),  
    .dev1(HEX1), 
    .dev2(HEX2),  
    .dev3(HEX3), 
    .dev4(HEX4),  
    .dev5(HEX5), 
    .dev6(HEX6),  
    .dev7(HEX7) 
);
endmodule