module jelly_FSM_top ( input logic [2:1]	GSENSOR_INT,
							  //input logic [2:0] 	HUNGER,
							  //input logic [2:0] 	HAPPINESS,
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
							  output logic [15:0] ARDUINO_IO,
							  inout 		       	GSENSOR_SDI,
							  inout 		        	GSENSOR_SDO );	


logic shake;
logic [2:0] STATE;



assign ARDUINO_IO[2:0] = NEWHAPPINESS[2:0];
assign ARDUINO_IO[5:3] = NEWHUNGER[2:0];
assign ARDUINO_IO[8:6] = STATE[2:0];

// connection to memory-mapped interface
				
jelly_FSM dut(KEY, MAX10_CLK1_50, SW, shake, LEDR, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, NEWHUNGER, NEWHAPPINESS, STATE);




//ACCELEROMETER STUFF

wire	        dly_rst;
wire	        spi_clk, spi_clk_out;
wire	[15:0]  data_x;




//	Reset
reset_delay	u_reset_delay	(	
            .iRSTN(KEY[0]),
            .iCLK(MAX10_CLK1_50),
            .oRST(dly_rst));

//  PLL            
spi_pll     u_spi_pll	(
            .areset(dly_rst),
            .inclk0(MAX10_CLK1_50),
            .c0(spi_clk),      // 2MHz
            .c1(spi_clk_out)); // 2MHz phase shift 

//  Initial Setting and Data Read Back
spi_ee_config u_spi_ee_config (			
						.iRSTN(!dly_rst),															
						.iSPI_CLK(spi_clk),								
						.iSPI_CLK_OUT(spi_clk_out),								
						.iG_INT2(GSENSOR_INT[1]),            
						.oDATA_L(data_x[7:0]),
						.oDATA_H(data_x[15:8]),
						.SPI_SDIO(GSENSOR_SDI),
						.oSPI_CSN(GSENSOR_CS_N),
						.oSPI_CLK(GSENSOR_SCLK));
			
//	LED
shaker test(.clk(MAX10_CLK1_50), .reset(dly_rst), .data_x(data_x), .shake_event(shake));
				
endmodule


