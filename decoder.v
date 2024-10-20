/*An LED decoder the character that we want to display it
and outputs the segments that need to light up*/
/*LED[0]=CA
  LED[1]=CB
  LED[2]=CC
  LED[3]=CD
  LED[4]=CE
  LED[5]=CF
  LED[6]=CG
*/
module LEDdecoder(char, LED);
    input [4:0] char;
    output [6:0] LED;

    reg [6:0] LED;

    always@(char)
        begin
            case(char)
                5'b00000: LED = 7'b1000000; //0
                5'b00001: LED = 7'b1111001; //1
                5'b00010: LED = 7'b0100100; //2
                5'b00011: LED = 7'b0110000; //3
                5'b00100: LED = 7'b0011001; //4
                5'b00101: LED = 7'b0010010; //5
                5'b00110: LED = 7'b0000011; //6
                5'b00111: LED = 7'b1111000; //7
                5'b01000: LED = 7'b0000000; //8
                5'b01001: LED = 7'b0011000; //9
                5'b01010: LED = 7'b0001000; //A
                5'b01011: LED = 7'b0000000; //B
                5'b01100: LED = 7'b1000110; //C
                5'b01101: LED = 7'b1000000; //D
                5'b01110: LED = 7'b0000110; //E
                5'b01111: LED = 7'b0001110; //F
                5'b10000: LED = 7'b0000010; //G
                5'b10001: LED = 7'b0001001; //H
                5'b10010: LED = 7'b1111001; //I
                5'b10011: LED = 7'b1110000; //J
                5'b10100: LED = 7'b0001001; //K
                5'b10101: LED = 7'b1000111; //L
                5'b10110: LED = 7'b0001001; //M
                5'b10111: LED = 7'b0001001; //N
                5'b11000: LED = 7'b1000000; //O
                5'b11001: LED = 7'b0001100; //P
                5'b11010: LED = 7'b1000000; //Q
                5'b11011: LED = 7'b0001000; //R
                5'b11100: LED = 7'b0010010; //S
                5'b11101: LED = 7'b1111000; //T
                5'b11110: LED = 7'b1000001; //U
                5'b11111: LED = 7'b1000001; //V

                default: LED=7'b0000000; //default all the segments are off
            endcase
        end

endmodule

