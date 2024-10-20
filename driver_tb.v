`include "driver.v"
`timescale 1ns/10ps

module driver_tb;
    reg clk, reset;
    wire an7, an6, an5, an4, an3, an2, an1, an0;
    wire a, b, c, d, e, f, g, dp;

    EightDigitLEDdriver driver_inst(
    .clk(clk),
    .reset(reset),
    .an7(an7),
    .an6(an6),
    .an5(an5),
    .an4(an4),
    .an3(an3),
    .an2(an2),
    .an1(an1),
    .an0(an0),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .dp(dp)
    );

    always
        begin
        #5 clk=~clk;
        end
        
    initial
        begin
        reset=1'b0;
        clk=1'b0;
//        step_button=1'b0;
        #520 reset=1'b1;
        #4500 reset=1'b0;
//        #20000 step_button=1'b1;
//        #4500 step_button=1'b0;
//        #20000 step_button=1'b1;
//        #4500 step_button=1'b0;       
//        #20000 step_button=1'b1;
//        #4500 step_button=1'b0;
//        #20
//        driver_inst.char=5'b00000;
//        for(i=1; i<5'b11111; i=i+1)
//        begin
//        //change the char every 600ns one clock before the anode driven to low
//        #600 driver_inst.char=i;
//        end
        
        #50000 $finish;
        end
        
   
        
endmodule