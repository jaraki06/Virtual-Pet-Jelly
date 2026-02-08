module jelly_FSM_top ( input logic 			GSENSOR_SDO,
							  input logic 			GSENSOR_INT1,
							  input logic [2:0] 	HUNGER,
							  input logic [2:0] 	HAPPINESS,
							  input logic [1:0] 	KEY,
							  input logic			MAX10_CLK1_50,
							  input logic [9:0] 	SW,
							  output logic [9:0] LEDR,
							  output logic [7:0] HEX5,
							  output logic [7:0] HEX4,
							  output logic [7:0] HEX3,
							  output logic [7:0] HEX2,
							  output logic [7:0] HEX1,
							  output logic [7:0] HEX0,
							  output logic [2:0] NEWHUNGER,
							  output logic [2:0] NEWHAPPINESS,
							  output logic 		GSENSOR_CS_N,
							  output logic 		GSENSOR_SCLK,
							  output logic 		GSENSOR_SDI );	


logic shake_small, shake_hard, sample_valid;

// connection to memory-mapped interface
				
jelly_FSM dut(HUNGER, HAPPINESS, KEY, MAX10_CLK1_50, SW, shake_small, shake_hard, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, NEWHUNGER, NEWHAPPINESS);
				
endmodule


