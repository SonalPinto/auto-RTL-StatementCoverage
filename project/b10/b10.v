/***********************************************************************
        Copyright (C) 2012,
        Virginia Polytechnic Institute & State University
        
        This verilog file is transformed from ITC 99 benchmark
        which is available from:
        http://www.cad.polito.it/downloads/tools/itc99.html.
        This verilog file was originally coverted by Mr. Min Li
        under the supervision of Dr. Michael S. Hsiao, in the
        Bradley Department of Electrical Engineering, VPI&SU, in
        2012. We made the conversion manually and verified it by 
        random simulation.

        This verilog file is released for research use only. This
        verilog file, or any derivative thereof, may not be
        reproduced nor used for any commercial product without the
        written permission of the authors.

        Mr. Min Li
        Research Assistant
        Bradley Department of Electrical Engineering
        Virginia Polytechnic Institute & State University
        Blacksburg, VA 24061

        Ph.: (540) 808-8129
        Fax: (540) 231-3362
        E-Mail: min.li@vt.edu
        Web: http://www.ece.vt.edu/mhsiao

***********************************************************************/

module b10 (	
				r_button		,
				g_button        ,
				key  			,
				start  			,
				reset  			,
				test			,
				cts				,
				ctr				,
				rts				,	
				rtr				,
				clock			,	
				v_in			,
				v_out			
				);
				
				
				
input r_button;
input g_button;
input key;
input start;
input reset;
input test;
input rts;
input rtr;
input clock;
input [3:0] v_in;

output reg cts;
output reg ctr;
output reg [3:0] v_out;
	
	
	
	
	//State Declerations
	`define STARTUP		4'b0000
	`define	STANDBY		4'b0001
	`define GET_IN		4'b0010
	`define	START_TX	4'b0011
	`define SEND		4'b0100
	`define TX_2_RX		4'b0101
	`define RECEIVE		4'b0110
	`define	RX_2_TX		4'b0111
	`define	END_TX		4'b1000
	`define	TEST_1		4'b1001
	`define	TEST_2		4'b1010
	
	
	reg [3:0] stato;
	reg voto0;
	reg voto1;
	reg voto2;
	reg voto3;
	reg [3:0] sign;
	reg last_g;
	reg last_r;
	
	
 
  //Sync-Reset
  always @(posedge clock )
	  begin
			if (reset == 1'b1) //instpt 0
				begin
					stato <= `STARTUP;
					voto0 <= 1'b0;
					voto1 <= 1'b0;
					voto2 <= 1'b0;
					voto3 <= 1'b0;
					sign <= 4'b0000;
					last_g <= 1'b0;
					last_r <= 1'b0;
					cts <= 1'b0;
					ctr <= 1'b0;
					v_out <= 4'b0000;
				end
			else //instpt 31
				begin
					case (stato)
						`STARTUP: //instpt 3
							begin
								voto0 <= 1'b0;
								voto1 <= 1'b0;
								voto2 <= 1'b0;
								voto3 <= 1'b0;
								cts <= 1'b0;
								ctr <= 1'b0;
								if ( test == 1'b0)//instpt 1
									begin
										sign <= 4'b0000;
										stato <= `TEST_1;
									end
								else //instpt 2
									begin
									voto0 <= 1'b0;
									voto1 <= 1'b0;
									voto2 <= 1'b0;
									voto3 <= 1'b0;
									stato <= `STANDBY;
									end
							end
						`STANDBY: //instpt 7
							begin
								if (start == 1'b1)//instpt 4
									begin
										voto0 <= 1'b0;
										voto1 <= 1'b0;
										voto2 <= 1'b0;
										voto3 <= 1'b0;
										stato <= `GET_IN;
									end
								if (rtr == 1'b1) //instpt 5
									cts <= 1'b1;
								if (rtr == 1'b0) //instpt 6
									cts <= 1'b0;
							end
						`GET_IN: //instpt 13
							begin
								if (start == 1'b0) //instpt 8
									begin
										stato <= `START_TX;
									end
								else if (key == 1'b1) //instpt 11
									begin
										voto0 <= key;
										if ( (g_button ^ last_g) && ( g_button == 1'b1) ) //instpt 9
											begin
												voto1 <= ~voto1;
											end
										if (( r_button ^ last_r ) && ( r_button == 1'b1) ) //instpt 10
											begin
												voto2 <= ~voto2;
											end
										last_g <= g_button;
										last_r <= r_button;
									end
								else //instpt 12
									begin
										voto0 <= 1'b0;
										voto1 <= 1'b0;
										voto2 <= 1'b0;
										voto3 <= 1'b0;
									end
							end
						`START_TX: //instpt 14
							begin
								voto3 <= voto0 ^ (voto1 ^ voto2);
								stato <= `SEND;
								voto0 <= 1'b0;
							end
						`SEND:	//instpt 18
							begin
								if (rtr == 1'b1)//instpt 17
									begin
										v_out[0] <= voto0;
										v_out[1] <= voto1;
										v_out[2] <= voto2;
										v_out[3] <= voto3;
										cts <= 1'b1;
										if ( (voto0 == 1'b0) && (voto1 == 1'b1) && (voto2 == 1'b1) && (voto3 == 1'b0)) //instpt 15
											begin
												stato <= `END_TX;
											end
										else//instpt 16
											begin
												stato <= `TX_2_RX;
											end
									end
							end
						`TX_2_RX: // instpt 20
							begin
								if (rts == 1'b0) //instpt 19
								begin
									ctr <= 1'b1;
									stato <= `RECEIVE;
								end
							end
						`RECEIVE: //instpt 22
							begin
								if (rts == 1'b1) //instpt 21
									begin
										voto0 <= v_in[0];
										voto1 <= v_in[1];
										voto2 <= v_in[2];
										voto3 <= v_in[3];
										ctr <= 1'b0;
										stato <= `RX_2_TX;
									end
							end
						`RX_2_TX: //instpt 24
							begin
								if (rtr == 1'b0) //instpt 23
									begin
										cts <= 1'b0;
										stato <= `SEND;
									end
							end
						`END_TX: //instpt 26
							begin
								if (rtr == 1'b0) //instpt 25
									begin
										cts <= 1'b0;
										stato <= `STANDBY;
									end
							end
						`TEST_1: //instpt 28
							begin
								voto0 <= v_in[0];
								voto1 <= v_in[1];
								voto2 <= v_in[2];
								voto3 <= v_in[3];
								sign <= 4'b1000;
								if ( (voto0 == 1'b1) && (voto1 == 1'b1) && (voto2 == 1'b1) && (voto3 == 1'b1) )
									begin //instpt 27
										stato <= `TEST_2;
									end
								
							end
						`TEST_2: //instpt 29
							begin
								voto0 <= 1 ^ sign[0];
								voto0 <= 0 ^ sign[1];
								voto0 <= 0 ^ sign[2];
								voto0 <= 1 ^ sign[3];
								stato <= `SEND;
									
							end
							
							
						default //instpt 30
							stato <= `STARTUP;
						endcase
				
				end
	  end
	  
	
endmodule
  
  
  
	
