module jelly_FSM ( input logic [2:0] 	HUNGER,
						 input logic [2:0] 	HAPPINESS,
						 input logic [1:0] 	KEY,
						 input logic			MAX10_CLK1_50,
						 input logic [9:0] 	SW,
						 input logic			shake_small,
						 input logic			shake_hard,
						 //output logic [9:0] 	LEDR,
						 output logic [7:0] 	HEX5,
						 output logic [7:0] 	HEX4,
						 output logic [7:0] 	HEX3,
						 output logic [7:0] 	HEX2,
						 output logic [7:0] 	HEX1,
						 output logic [7:0] 	HEX0,
						 output logic [2:0] 	NEWHUNGER,
						 output logic [2:0] 	NEWHAPPINESS,
						 output logic [2:0] 	STATE );		
						 
	enum int unsigned {IDLE = 0, BLINK = 1, EATING = 2, PLAYING = 3, DIZZY = 4, DEAD = 5} presentState = 0, nextState = 0;
	
	//inputs:
	//feed
	logic FEED = 1'b0;
	assign FEED = ~KEY[0];
	//assign LEDR[2] = FEED;
	//play
	logic PLAY = 1'b0;
	assign PLAY = ~KEY[1];
	//assign LEDR[1] = PLAY;
	//on/off
	logic RESETOFF = 1'b0;
	assign RESETOFF = SW[0];
	/////////////////////////assign LEDR[9] = RESETOFF;
	
	
	//accel
	/////////////////////////assign LEDR[2] = shake_small;
	/////////////////////////assign LEDR[1] = shake_hard;	
	//clock
	logic [25:0] TICKER = 26'b0;
	logic TICK = 1'b0;
	/////////////////////////assign LEDR[0] = TICK;
	int tickCount = 0;
	int hungerTick = 0;
	int happyTick = 0;
	
	//a clock that will change values every 1 second (posedge every 1 second)
	always_ff @(posedge MAX10_CLK1_50) begin
		//we need a 1 second clock
		//so toggle TICK every 25,000,000 cycles
		TICKER = TICKER + 1'b1;
		if (TICKER >= 26'd50_000_000) begin
			TICK = ~TICK;
			TICKER = 26'b0;
			tickCount <= tickCount + 1;
			hungerTick <= hungerTick + 1;
		end
		
		if (nextState != presentState) begin
			tickCount <= 0;
		end
		
		if (hungerTick > 30) begin
			hungerTick <= 0;
			NEWHUNGER <= HUNGER - 1'b1;
		end
		else begin
			NEWHUNGER <= HUNGER;
		end
		
		if (happyTick > 30) begin
			happyTick <= 0;
			NEWHAPPINESS <= HAPPINESS - 1'b1;
		end
		else begin
			NEWHAPPINESS <= HAPPINESS;
		end
		
		presentState <= nextState;
		
	end
	
	
	//FSM LOGIC
	always_comb begin
	//output logic
		case (presentState)
		
			IDLE: begin
			//display neutral face
				///////////////////////////////////LEDR[8:6] = 3'b000;
				STATE = 3'b000;
			end
		
			BLINK: begin
			//display blink face
				if (HUNGER < 2'b11) begin
					//display hungry
				end
				else if (HAPPINESS < 2'b11) begin
					//display sad
				end
				else if (HAPPINESS == 3'b111) begin
					//display happy
				end
				else begin
					//display blink
				end
				///////////////////////////////////LEDR[8:6] = 3'b001;
				STATE = 3'b001;
			end
			
			EATING: begin
			//display eating face
			///////////////////////////////////LEDR[8:6] = 3'b010;
			STATE = 3'b010;
			end
		
			PLAYING: begin
			//display playing face
			///////////////////////////////////LEDR[8:6] = 3'b011;
			STATE = 3'b011;
			end
		
			DIZZY: begin
			//display dizzy face
			///////////////////////////////////LEDR[8:6] = 3'b100;
			STATE = 3'b100;
			end
		
			DEAD: begin
			//display dead face
			///////////////////////////////////LEDR[8:6] = 3'b101;
			STATE = 3'b101;
			end

			default: begin
			//display neutral face
			///////////////////////////////////LEDR[8:6] = 3'b000;
			STATE = 3'b000;
			end
		
		endcase
	
	end
	
	//nextState logic
	always_comb begin
		case (presentState)
		
			IDLE: begin
			
				if (FEED) begin
					nextState = EATING;
				end 
				else if (PLAY) begin
					nextState = PLAYING;
				end
				else if (shake_hard) begin
					nextState = DIZZY;
				end
				else if (shake_small) begin
					nextState = PLAYING;
				end
				else if (HUNGER == 0) begin
					nextState = DEAD;
				end
				else if (tickCount >= 5) begin
					nextState = BLINK;
				end
				else begin
					nextState = IDLE;
				end
				
			end
		
			BLINK: begin
			
				if (FEED) begin
					nextState = EATING;
				end 
				else if (PLAY) begin
					nextState = PLAYING;
				end 
				else if (shake_hard) begin
					nextState = DIZZY;
				end
				else if (shake_small) begin
					nextState = PLAYING;
				end
				else if (HUNGER == 0) begin
					nextState = DEAD;
				end
				else if (tickCount >= 1) begin
					nextState = IDLE;
				end
				else begin
					nextState = BLINK;
				end
				
			end
			
			EATING: begin
				if (tickCount >= 5) begin
					nextState = IDLE;
				end
				else begin
					nextState = EATING;
				end
			end
		
			PLAYING: begin
				if (tickCount >= 5) begin
					nextState = IDLE;
				end
				else begin
					nextState = PLAYING;
				end
			end
		
			DIZZY: begin
				if (tickCount >= 5) begin
					nextState = IDLE;
				end
				else begin
					nextState = DIZZY;
				end
			end
		
			DEAD: begin
				nextState = DEAD;
			end

			default: begin
				nextState = IDLE;
			end
		
		endcase
	end
	
	
						
endmodule