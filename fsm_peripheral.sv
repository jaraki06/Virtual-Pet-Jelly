module fsm_peripheral (
    input  logic        clk,
    input  logic        reset,

    // Avalon-MM slave interface
    input  logic        read,
    input  logic        write,
    input  logic [1:0]  address,
    input  logic [31:0] writedata,
    output logic [31:0] readdata
);

    typedef enum logic [1:0] {
        S0,
        S1,
        S2
    } state_t;

    state_t state;

    // FSM
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= state + 1;   // cycles through states automatically
    end

    // CPU read access
    always_comb begin
        if (read)
            readdata = state;
        else
            readdata = 32'h0;
    end

endmodule
