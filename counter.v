module counter(clock, reset, shift_signal);
    input clock, reset;
    output shift_signal;

    reg shift_signal;
    reg [21:0]counter;

    always@(posedge clock or posedge reset)
        begin
            if(reset)
                counter=22'b0;
            else
                begin
                    if(counter==22'b1111111111111111111111)
                        begin
                            shift_signal=1'b1;
                            counter=0;
                        end
                    else
                        begin
                            shift_signal=1'b0;
                            counter=counter+1;
                        end

                end
        end
endmodule