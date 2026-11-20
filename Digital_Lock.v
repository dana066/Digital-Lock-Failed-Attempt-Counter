module Digital_Lock (
    input  wire       clk,
    input  wire       reset,
    input  wire [3:0] password,
    input  wire       enter,
    output reg        unlock,
    output reg        lockout,
    output reg [1:0]  attempt_count
);

    // Correct password
    parameter [3:0] CORRECT_PASSWORD = 4'b1011;

    // FSM states
    parameter LOCKED   = 2'b00;
    parameter CHECK    = 2'b01;
    parameter UNLOCKED = 2'b10;
    parameter LOCKOUT  = 2'b11;

    reg [1:0] state;
    reg [1:0] next_state;

    // State register and failed-attempt counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state         <= LOCKED;
            attempt_count <= 2'b00;
        end
        else begin
            state <= next_state;

            // Count consecutive incorrect attempts
            if (state == CHECK && password != CORRECT_PASSWORD) begin
                if (attempt_count < 2'b11)
                    attempt_count <= attempt_count + 1'b1;
            end
            else if (state == CHECK && password == CORRECT_PASSWORD) begin
                attempt_count <= 2'b00;
            end
        end
    end

    // Next-state logic
    always @(*) begin

        next_state = state;

        case (state)

            LOCKED: begin
                if (enter)
                    next_state = CHECK;
            end

            CHECK: begin
                if (password == CORRECT_PASSWORD)
                    next_state = UNLOCKED;
                else if (attempt_count == 2)
                    next_state = LOCKOUT;
                else
                    next_state = LOCKED;
            end

            UNLOCKED: begin
                next_state = UNLOCKED;
            end

            LOCKOUT: begin
                next_state = LOCKOUT;
            end

            default: begin
                next_state = LOCKED;
            end

        endcase
    end

    // Output logic
    always @(*) begin

        unlock = 1'b0;
        lockout = 1'b0;

        case (state)

            UNLOCKED: begin
                unlock = 1'b1;
            end

            LOCKOUT: begin
                lockout = 1'b1;
            end

            default: begin
                unlock = 1'b0;
                lockout = 1'b0;
            end

        endcase
    end

endmodule