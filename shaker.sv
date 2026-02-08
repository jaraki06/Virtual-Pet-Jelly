module shaker(
    input  logic signed [15:0] data_x, // 'signed' is critical for < -THRESHOLD to work
    input  logic               reset,  // Assuming active high reset from top level
    input  logic               clk,
    output logic               shake_event,
	 output logic					 shake
);

    typedef enum logic [1:0] {IDLE, POS, NEG, SHAKE} state_t;
    state_t present_state, next_state;
    
    localparam signed THRESHOLD = 16'd10; 
    localparam int    TIME_LIMIT = 25_000_000; 
    
    int timer;
    logic [2:0] swap_count;
	 
	 always_comb begin
		//debug
		if (data_x > 0) begin
			shake = 1;
		end else begin
			shake = 0;
		end
	 end

    // 1. Next State Logic (Combinational)
// 1. Next State Logic (Combinational)
    always_comb begin
        next_state = present_state; 
        
        // Priority Jump: If we hit the count, go to SHAKE immediately
        if (swap_count >= 3'd4) begin
            next_state = SHAKE;
        end else begin
            case (present_state)
                IDLE: begin
                    if (data_x > THRESHOLD)       next_state = POS;
                    else if (data_x < -THRESHOLD) next_state = NEG;
                end
                
                POS: begin
                    if (timer > TIME_LIMIT)       next_state = IDLE;
                    else if (data_x < -THRESHOLD) next_state = NEG;
                end
                
                NEG: begin
                    if (timer > TIME_LIMIT)       next_state = IDLE;
                    else if (data_x > THRESHOLD)  next_state = POS;
                end
                
                SHAKE: begin
                    // Stay in shake for a moment then go to IDLE
                    if (data_x < THRESHOLD && data_x > -THRESHOLD)
                        next_state = IDLE;
                end
                default: next_state = IDLE;
            endcase
        end
    end

    // 2. Sequential Logic (Counters and State Update)
    always_ff @(posedge clk) begin
        if (reset) begin // Using 'reset' as active high based on your input
            present_state <= IDLE;
            timer         <= 0;
            swap_count    <= 0;
            shake_event   <= 0;
        end else begin
            present_state <= next_state;

            // Handle Shake Event Output
            shake_event <= (next_state == SHAKE);

            // Counter Logic
            if (present_state == IDLE) begin
                timer <= 0;
                //swap_count <= 0;
            end else if (present_state != next_state) begin
                // We swapped directions!
                timer <= 0; 
                if (next_state != IDLE && next_state != SHAKE)
                    swap_count <= swap_count + 1'b1;
            end else begin
                timer <= timer + 1;
            end
        end
    end
endmodule