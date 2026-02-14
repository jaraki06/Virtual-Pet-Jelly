module shaker(
    input  logic signed [15:0] data_x, // 'signed' is critical for < -THRESHOLD to work
    input  logic               reset,  // Assuming active high reset from top level
    input  logic               clk,
    output logic               shake_event
);

    typedef enum logic [2:0] {IDLE, POS, NEG, SHAKEPOS, SHAKENEG, BIGSHAKE} state_t;
    state_t present_state, next_state;
    
    localparam signed THRESHOLD = 16'd50; 
    localparam int    TIME_LIMIT = 25_000_000; 
    
    int timer;
    logic [2:0] swap_count;
	 
	 // 1. Next State Logic (Combinational)
    always_comb begin
        next_state = present_state; 
		  
		  case (present_state)

				SHAKEPOS: begin
					  if (data_x < -THRESHOLD) next_state = SHAKENEG;
					  else if (timer > TIME_LIMIT)       next_state = IDLE;

				end 
				
				SHAKENEG: begin
					  if (data_x > THRESHOLD)  next_state = SHAKEPOS;
					  else if (timer > TIME_LIMIT)       next_state = IDLE;

				end 

			
			default: begin
			  // If the count is reached, go to shake
			  if (swap_count >= 3'd4) begin
					next_state = SHAKEPOS;
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
				endcase
				end
			end
		  endcase
    end
	 
	 always_comb begin
		case (present_state)
			SHAKEPOS: begin
				shake_event = 1'b1;
			end
			
			SHAKENEG: begin
				shake_event = 1'b1;
			end
			
			BIGSHAKE: begin
				shake_event = 1'b0;
			end
			
			default begin
				shake_event = 1'b0;
			end
			endcase
	 end
	 
	 // 2. Sequential Logic (Counters and State Update)
    always_ff @(posedge clk) begin
			// Reset all counters
        if (reset) begin 
            present_state <= IDLE;
			  timer         <= 0;
			  swap_count    <= 0;
        end else begin
		  
         present_state <= next_state;
				
			// State transition -> reset threshold timer
			if (present_state != next_state) begin
				 timer <= 0; 
				 // increment swap count if shake is not yet detected
				 if (next_state == POS || next_state == NEG)
					swap_count <= swap_count + 1'b1;
			
            // Reset shake timer on shake entry
            if (next_state == SHAKEPOS || next_state == SHAKENEG) begin
					 swap_count <= 0;
				end

			end
			
			
			// no transition
			else begin
			
			// Counter Logic reset. No shaking.
			case (present_state)
				IDLE: begin
					 timer <= 0;
					 swap_count <= 0;
				end 
				
				SHAKEPOS, SHAKENEG: begin
					timer <= timer + 1;
				end
				
				default: timer <= timer + 1;
			endcase

			end 
			end
    end
	 
endmodule