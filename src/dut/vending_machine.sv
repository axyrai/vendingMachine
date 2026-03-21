module vending_machine (
    input clk,
    input reset,
    input [1:0] coin, // 2'b01 for Nickel (5c), 2'b10 for Dime (10c)
    output reg dispense,
    output reg [1:0] change
);

    // State Encoding
    parameter S0  = 3'b000; // 0 cents
    parameter S5  = 3'b001; // 5 cents
    parameter S10 = 3'b010; // 10 cents
    parameter S15 = 3'b011; // 15 cents
    parameter S20 = 3'b100; // 20 cents
    parameter S25 = 3'b101; // 25 cents (Dispense)

    reg [2:0] current_state, next_state;

    // State Register
    always @(posedpge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (coin == 2'b01) next_state = S5;
                else if (coin == 2'b10) next_state = S10;
                else next_state = S0;
            end
            S5: begin
                if (coin == 2'b01) next_state = S10;
                else if (coin == 2'b10) next_state = S15;
                else next_state = S5;
            end
            S10: begin
                if (coin == 2'b01) next_state = S15;
                else if (coin == 2'b10) next_state = S20;
                else next_state = S10;
            end
            S15: begin
                if (coin == 2'b01) next_state = S20;
                else if (coin == 2'b10) next_state = S25;
                else next_state = S15;
            end
            S20: begin
                if (coin == 2'b01) next_state = S25;
                else if (coin == 2'b10) next_state = S25; // Simple design: no change for 30c
                else next_state = S20;
            end
            S25: next_state = S0; // Reset after dispensing
            default: next_state = S0;
        endcase
    end

    // Output Logic
    always @(*) begin
        if (current_state == S25)
            dispense = 1'b1;
        else
            dispense = 1'b0;
    end

endmodule: vending_machine
