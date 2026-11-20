`timescale 1ns / 1ps

module Digital_Lock_tb;

    reg clk;
    reg reset;
    reg [3:0] password;
    reg enter;

    wire unlock;
    wire lockout;
    wire [1:0] attempt_count;

    Digital_Lock uut (
        .clk(clk),
        .reset(reset),
        .password(password),
        .enter(enter),
        .unlock(unlock),
        .lockout(lockout),
        .attempt_count(attempt_count)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        password = 4'b0000;
        enter = 0;

        #10;
        reset = 0;

        // Correct password
        password = 4'b1011;
        enter = 1;
        #10;
        enter = 0;

        #10;

        // Reset before testing wrong attempts
        reset = 1;
        #10;
        reset = 0;

        // Wrong attempt 1
        password = 4'b0001;
        enter = 1;
        #10;
        enter = 0;

        #10;

        // Wrong attempt 2
        password = 4'b0010;
        enter = 1;
        #10;
        enter = 0;

        #10;

        // Wrong attempt 3
        password = 4'b0100;
        enter = 1;
        #10;
        enter = 0;

        #20;

        $finish;
    end

endmodule