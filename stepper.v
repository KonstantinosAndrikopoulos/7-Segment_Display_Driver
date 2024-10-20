/*a module to handle correctly the push button*/
module stepper(clock, step_button, reset, address);
input clock, step_button, reset;
output [2:0]address;

reg button_pressed, prev_step_button;
reg [2:0]address;
reg [2:0]step_counter;

/*an always block that assures that when we press the button
it's read only one time instead of multiple by having a
signal that is on when a button press needs to go through*/
always@(posedge clock or posedge reset)
begin
    if (reset)
        begin
            button_pressed=1'b0;
            prev_step_button=1'b0;
        end
    else
        begin
            if(step_button && !prev_step_button) begin
                button_pressed=1'b1;
            end
            else if(step_button==prev_step_button) begin
                button_pressed=1'b0;
            end

            prev_step_button<=step_button;
        end
end

endmodule
