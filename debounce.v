/*a debounce module to filter noise in the signal from the button
due to the mechanical nature of the button. The module checks the signal
every cycle and if it is stable for 20 cycles it then passes the
signal through. It also consists of two flip flops (like a sychronizer) to 
also prevent metastability*/

module debounce(clock, reset_in, reset_out);
    input reset_in, clock;
    output reset_out;
    reg [4:0] counter;
    reg reset_out;
    reg reset_hold=1'b0; //a reg to hold the previous value of the signal


    always@(posedge clock)
    begin
        if(reset_in==reset_hold) //keep counting while the signal is the same
        begin
            counter=counter+1;
            if(counter==5'd20) //count for 20 cycles to ensure that the signal is stable
            begin 
                reset_out<=reset_hold;
            end
        end
        else //if the signal changes start counting from 0 again
        begin
            counter=5'b00000;
            reset_hold=reset_in;        
        end
    end
    
endmodule