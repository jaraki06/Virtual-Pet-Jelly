module fsm_mm_interface (

    // clock domain (must be SAME clock as Nios CPU later)
    input  logic        clk,
    input  logic        reset_n,

    // Avalon-MM slave signals (THIS is what lets C read it)
    input  logic        read,
    input  logic        chipselect,
    output logic [31:0] readdata,

    // signals coming FROM your FSM
    input  logic [2:0]  hunger,
    input  logic [2:0]  happiness
);

    // This is the hardware register the CPU will read
    logic [31:0] status_reg;

    // Register updated by the FSM every clock cycle
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            status_reg <= 32'd0;
        else begin
            // pack FSM outputs into register
            status_reg[2:0] <= hunger;     // bits 0–2
            status_reg[5:3] <= happiness;  // bits 3–5

            // (rest of bits unused for now)
            status_reg[31:6] <= 26'd0;
        end
    end

    // When CPU reads our address, it receives this data
    always_comb begin
        if (chipselect && read)
            readdata = status_reg;
        else
            readdata = 32'd0;
    end

endmodule
