module b07 ( clock, reset, start, punti_retta);
	input clock, reset, start;
    	output reg [7:0] punti_retta;
	parameter [2:0] S_RESET=3'b000,
			S_START=3'b001,
			S_LOAD_X=3'b010,
			S_UPDATE_MAR=3'b011,
			S_LOAD_Y=3'b100,
			S_CALC_RETTA=3'b101,
			S_INCREMENTA=3'b110;
					
	reg [2:0] stato; 	
	reg [7:0]  cont, mar, x, y, t;
	reg [7:0] mem [0:15];
	
always @(posedge clock)
	begin
		if (reset == 1'b1) //instPt 0
		  begin
			punti_retta <= 0;
			cont <= 0;
			mar <= 0;
			x <= 0;
			y <= 0;
			t <= 0;

	        mem[0] <= 8'b00000001;
			mem[1] <= 8'b11111111;
			mem[2] <= 8'b00000000;
			mem[3] <= 8'b00000000;

			mem[4] <= 8'b00000000;
			mem[5] <= 8'b00000010;
			mem[6] <= 8'b00000000;
			mem[7] <= 8'b00000000;

			mem[8] <= 8'b00000000;
			mem[9] <= 8'b00000010;
			mem[10] <= 8'b11111111;
			mem[11] <= 8'b00000101;

			mem[12] <= 8'b00000000;
			mem[13] <= 8'b00000010;
			mem[14] <= 8'b00000001;
			// mem[14] <= 8'b00000000;
			mem[15] <= 8'b00000010;
			
			stato <= S_RESET;
		end
		else //instPt 19
		begin
			case (stato)
				S_RESET: //InstPt 1
				begin
					stato <= S_START;
				end
				S_START: //instpt 4
				begin
					if (start == 1) //instpt 2
					begin
						cont <= 0;
						mar <= 0;
						stato <= S_LOAD_X;
					end
					else //instpt 3
					begin
						punti_retta <= 0;
						stato <= S_START;
					end
				end
				S_LOAD_X: //instpt 5
				begin
					x <= mem[mar];
					stato <= S_UPDATE_MAR;
				end
				S_UPDATE_MAR://instpt 6
				begin
					mar <= mar + 1;
					t <= x + x;
					stato <= S_LOAD_Y;
				end
				S_LOAD_Y: //instpt 7
				begin
					y <= mem[mar];
					x <= x+t;
					stato <= S_CALC_RETTA;
				end
				S_CALC_RETTA: //instpt 8
				begin
					x<= x + y ;
					stato <= S_INCREMENTA;
				end
				S_INCREMENTA: //instpt 17
				begin
				   if (mar != {4'b0000, 4'b1111}) //instpt 11
					begin
						if ( x == 8'b00000010) //instpt 9
						begin
							cont <= cont +1;
							mar <= mar + 1;
							stato <= S_LOAD_X;							
						end
						else //instpt 10
						begin
							mar <= mar + 1;
							stato <= S_LOAD_X;
						end
					end
					else //instpt 16
					begin
						if (start == 0) //instpt 14
						begin
							if (x == 8'b00000010) //instpt 12
							begin
								punti_retta <= cont + 1;
								stato <= S_START;
							end
							else //instpt 13
							begin
								punti_retta <= cont;
								stato <= S_START;
							end
						end
						else //instpt 15
						begin
							stato <= S_INCREMENTA;
						end
					end
				end // case: S_INCREMENTA
			  default: //instpt 18
			    stato <= S_START; // min added! Should not reach!!
			endcase 
		end
	end
endmodule 
