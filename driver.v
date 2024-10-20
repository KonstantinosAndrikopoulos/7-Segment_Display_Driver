`include "decoder.v"
`include "debounce.v"
`include "counter.v"

module EightDigitLEDdriver(reset, clk, an7, an6, an5, an4, an3, an2, an1, an0,
a, b, c, d, e, f, g, dp);

input clk, reset;
output an7, an6, an5, an4, an3, an2, an1, an0;
output a, b, c, d, e, f, g;
output dp=1'b1;

reg an7, an6, an5, an4, an3, an2, an1, an0;

reg [4:0] counter, next_counter;

reg a, b, c, d, e, f, g, dp;

reg [4:0] char;
wire [6:0] LED;

wire reset_to_debounce, synced_reset;

reg reset_mid_ff, sync_out; // flip flops to sychronize reset

/*wires for the MMCM module*/
wire CLKIN1=clk;
wire CLKOUT0, CLKOUT0B, CLKOUT1, CLKOUT1B, CLKOUT2, CLKOUT2B;
wire CLKOUT3, CLKOUT3B, CLKOUT4, CLKOUT5, CLKOUT6, CLKFBOUT, CLKFBOUTB;
wire LOCKED;
wire PWRDWN =1'b0;
wire CLKFBIN;
wire RST=1'b0;

wire clock=CLKOUT1;


wire [4:0] char0;
wire [4:0] char1;
wire [4:0] char2;
wire [4:0] char3;
wire [4:0] char4;
wire [4:0] char5;
wire [4:0] char6;
wire [4:0] char7;

reg [3:0]address;

wire shift_signal;

reg [4:0] message [15:0];

always @(posedge reset) begin
    message[0]  <= 5'b00000; // 0
    message[1]  <= 5'b00001; // 1
    message[2]  <= 5'b00010; // 2
    message[3]  <= 5'b00011; // 3
    message[4]  <= 5'b00100; // 4
    message[5]  <= 5'b00101; // 5
    message[6]  <= 5'b00110; // 6
    message[7]  <= 5'b00111; // 7
    message[8]  <= 5'b01000; // 8
    message[9]  <= 5'b01001; // 9
    message[10] <= 5'b01010; // A
    message[11] <= 5'b01011; // B
    message[12] <= 5'b01100; // C
    message[13] <= 5'b01101; // D
    message[14] <= 5'b01110; // E
    message[15] <= 5'b01111; // F
end



counter counter_inst(.clock(clock), .reset(synced_reset), .shift_signal(shift_signal));

/*the 5 least significant bits of the memory bus get assigned to
data0 and then the next data get assigned the following way*/
assign {char7,char6, char5, char4, char3, char2, char1, char0} = {message[address], message[address+1], message[address+2], message[address+3], message[address+4], message[address+5], message[address+6], message[address+7]};

/*an always that sychronizes the reset from the reset button through two flip flops
to avoid possible metastabiliy*/
always@(posedge clock)
    begin
        reset_mid_ff<=reset;
        sync_out<=reset_mid_ff;
    end 
    
assign reset_to_debounce=sync_out;
    
debounce debounce_inst(
.clock(clock),
.reset_in(reset_to_debounce),
.reset_out(synced_reset)
);  

/*a counter that drives each anode every three counts so the anodes don't overlap
and we don't have irregular LEDs light up. Also it drives the correct segments one
or more counts before the respective anode is driven to low.*/
always@(posedge clock or posedge synced_reset)
    begin
        if(shift_signal) begin
                {an0,an1,an2,an3,an4,an5,an6,an7}=8'b11111111;
                {g,f,e,d,c,b,a}=7'b1111111;
                counter=5'b00000;
           if(address!=16)
                address=address+1;
           else
                address=4'b0000;
        end
        
        if(synced_reset)
            begin
                {an0,an1,an2,an3,an4,an5,an6,an7}=8'b11111111;
                {g,f,e,d,c,b,a}=8'b11111111;
                counter=5'b00000;
                address=3'b000;
            end
        else
            begin
                case(counter)
                    5'b00000: begin
                        an7=1'b1;
                        char=char0;
                        counter=5'b00001;
                    end
                    5'b00001: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b00010;
                    end
                    5'b00010: begin
                        an0=1'b0;
                        counter=5'b00011;
                    end
                    5'b00011: begin
                        an0=1'b1;
                        counter=5'b00100;
                    end
                    5'b00100: begin
                        counter=5'b00101;
                        char=char1;
                        end
                    5'b00101: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b00110;
                    end
                    5'b00110: begin
                        an1=1'b0;
                        counter=5'b00111;   
                    end
                    5'b00111: begin
                        an1=1'b1;
                        counter=5'b01000;
                    end
                    5'b01000: begin
                        counter=5'b01001;
                        char=char2;
                        end
                    5'b01001: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b01010;
                    end
                    5'b01010: begin
                        an2=1'b0;
                        counter=5'b01011;
                    end
                    5'b01011: begin
                        an2=1'b1;
                        counter=5'b01100;
                    end
                    5'b01100: begin
                        counter=5'b01101;
                        char=char3;
                        end
                    5'b01101: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b01110;
                    end
                    5'b01110: begin
                        an3=1'b0;
                        counter=5'b01111;
                    end
                    5'b01111: begin
                        an3=1'b1;
                        counter=5'b10000;
                    end
                    5'b10000:begin
                        counter=5'b10001;
                        char=char4;
                        end
                    5'b10001: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b10010;
                    end
                    5'b10010: begin
                        an4=1'b0;
                        counter=5'b10011;
                    end
                    5'b10011: begin
                        an4=1'b1;
                        counter=5'b10100;
                    end
                    5'b10100: begin
                        counter=5'b10101;
                        char=char5;
                        end
                    5'b10101: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b10110;
                    end
                    5'b10110: begin
                        an5=1'b0;
                        counter=5'b10111;
                    end
                    5'b10111: begin
                        an5=1'b1;
                        counter=5'b11000;
                    end
                    5'b11000: begin
                        counter=5'b11001;
                        char=char6;
                    end
                    5'b11001: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b11010;
                    end
                    5'b11010: begin
                        an6=1'b0;
                        counter=5'b11011;
                    end
                    5'b11011: begin
                        an6=1'b1;
                        counter=5'b11100;
                    end
                    5'b11100: begin
                        counter=5'b11101;
                        char=char7;
                        end
                    5'b11101: begin
                        {g,f,e,d,c,b,a}=LED;
                        counter=5'b11110;
                    end
                    5'b11110: begin
                        an7=1'b0;
                        counter=5'b00000;
                    end
                endcase
            end
    end
    
assign CLKFBIN = CLKFBOUT;

MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKFBOUT_MULT_F(6.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(10.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      // CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      .CLKOUT1_DIVIDE(120),
      .CLKOUT2_DIVIDE(1),
      .CLKOUT3_DIVIDE(1),
      .CLKOUT4_DIVIDE(1),
      .CLKOUT5_DIVIDE(1),
      .CLKOUT6_DIVIDE(1),
      .CLKOUT0_DIVIDE_F(1.0),    // Divide amount for CLKOUT0 (1.000-128.000).
      // CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT5_DUTY_CYCLE(0.5),
      .CLKOUT6_DUTY_CYCLE(0.5),
      // CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      .CLKOUT0_PHASE(0.0),
      .CLKOUT1_PHASE(0.0),
      .CLKOUT2_PHASE(0.0),
      .CLKOUT3_PHASE(0.0),
      .CLKOUT4_PHASE(0.0),
      .CLKOUT5_PHASE(0.0),
      .CLKOUT6_PHASE(0.0),
      .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .DIVCLK_DIVIDE(1),         // Master division value (1-106)
      .REF_JITTER1(0.0),         // Reference input jitter in UI (0.000-0.999).
      .STARTUP_WAIT("FALSE")     // Delays DONE until MMCM is locked (FALSE, TRUE)
   )
   MMCME2_BASE_inst (
      // Clock Outputs: 1-bit (each) output: User configurable clock outputs
      .CLKOUT0(CLKOUT0),     // 1-bit output: CLKOUT0
      .CLKOUT0B(CLKOUT0B),   // 1-bit output: Inverted CLKOUT0
      .CLKOUT1(CLKOUT1),     // 1-bit output: CLKOUT1
      .CLKOUT1B(CLKOUT1B),   // 1-bit output: Inverted CLKOUT1
      .CLKOUT2(CLKOUT2),     // 1-bit output: CLKOUT2
      .CLKOUT2B(CLKOUT2B),   // 1-bit output: Inverted CLKOUT2
      .CLKOUT3(CLKOUT3),     // 1-bit output: CLKOUT3
      .CLKOUT3B(CLKOUT3B),   // 1-bit output: Inverted CLKOUT3
      .CLKOUT4(CLKOUT4),     // 1-bit output: CLKOUT4
      .CLKOUT5(CLKOUT5),     // 1-bit output: CLKOUT5
      .CLKOUT6(CLKOUT6),     // 1-bit output: CLKOUT6
      // Feedback Clocks: 1-bit (each) output: Clock feedback ports
      .CLKFBOUT(CLKFBOUT),   // 1-bit output: Feedback clock
      .CLKFBOUTB(CLKFBOUTB), // 1-bit output: Inverted CLKFBOUT
      // Status Ports: 1-bit (each) output: MMCM status ports
      .LOCKED(LOCKED),       // 1-bit output: LOCK
      // Clock Inputs: 1-bit (each) input: Clock input
      .CLKIN1(CLKIN1),       // 1-bit input: Clock
      // Control Ports: 1-bit (each) input: MMCM control ports
      .PWRDWN(PWRDWN),       // 1-bit input: Power-down
      .RST(RST),             // 1-bit input: Reset
      // Feedback Clocks: 1-bit (each) input: Clock feedback ports
      .CLKFBIN(CLKFBIN)      // 1-bit input: Feedback clock
   );

LEDdecoder LEDdecoder_inst(.char(char), .LED(LED));

endmodule