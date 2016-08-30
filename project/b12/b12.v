module b12(
	       input            clock,
	       input            reset,
	       input            start,
	       input [3:0]      k,
	       output reg           nloss,
	       output reg [3:0]      nl,
	       output reg           speaker
	       );

   parameter RED = 0;
   parameter GREEN = 1;
   parameter YELLOW = 2;
   parameter BLUE = 3;

   parameter LED_ON = 1;
   parameter LED_OFF = 0;

   parameter PLAY_ON = 1;
   parameter PLAY_OFF = 0;

   parameter KEY_ON = 1;

   parameter NUM_KEY = 4;
   parameter COD_COLOR = 2;
   parameter COD_SOUND = 3;

`define S_WIN 4
`define S_LOSS 5

   parameter SIZE_ADDRESS = 5;
   parameter SIZE_MEM = 2**SIZE_ADDRESS;

   parameter COUNT_KEY = 33;
   parameter COUNT_SEQ = 33;
   parameter DEC_SEQ = 1;
   parameter COUNT_FIN = 8;

   parameter ERROR_TONE = 1;
   parameter RED_TONE = 2;
   parameter GREEN_TONE = 3;
   parameter YELLOW_TONE = 4;
   parameter BLUE_TONE = 5;
   parameter WIN_TONE = 6;

   reg [0:0]                     wr;
   reg [(SIZE_ADDRESS-1):0] address;
   //reg[SIZE_ADDRESS:0] address;
   reg [(COD_COLOR-1):0]    data_in;
   reg [(COD_COLOR-1):0]    data_out;
   reg [(COD_COLOR-1):0]    num;
   reg [(COD_SOUND-1):0]    sound;
   // reg[((2**COD_COLOR)-1):0] data_in;
   // reg[((2**COD_COLOR)-1):0] data_out;
   // reg[((2**COD_COLOR)-1):0] num;
   // reg[((2**COD_SOUND)-1):0] sound;
   reg [0:0]                   play;

   //reg[3:0] counter;

   //reg[((2**COD_COLOR)-1):0] count;

   //reg[((2**COD_COLOR)-1):0] memory [0:(SIZE_MEM-1)];
   //reg[SIZE_ADDRESS:0] mar;

`define G0 0
`define G1 1
`define G2 2
`define G3 3
`define G4 4
`define G5 5
`define G6 6
`define G7 7
`define G8 8
`define G9 9
`define G10 10
`define G10a 11
`define G11 12
`define G12 13
`define Ea 14
`define E0 15
`define E1 16
`define K0 17
`define K1 18
`define K2 19
`define K3 20
`define K4 21
`define K5 22
`define K6 23
`define W0 24
`define W1 25

   reg [0:0] s;
   reg [2:0] counter;

   always @ (posedge clock )
   begin
	    if (reset) //0
	      begin
		     s = 0;
		     speaker <= 0;
		     counter = 0;
	      end
	    else //22
	      begin
		     if (play)//20
		       begin
			      case (sound) 
				    0: //3
				      begin
					     if (counter > RED_TONE) // > 0 //1
					       begin
						      s = ~s;
						      counter = 0;
						      speaker <= s;
					       end
					     else //2
						   counter = counter + 1;
				      end
				    
				    1: //6
				      begin
					     if (counter > GREEN_TONE) // > 1 //4
					       begin
						      s = ~s;
						      speaker <= s;
						      counter = 0;
					       end
					     else //5
						   counter = counter + 1;
				      end
				    
				    2: //9
				      begin 
					     if (counter > YELLOW_TONE) // > 2 //7
					       begin
						      s = ~s;
						      speaker <= s;
						      counter = 0;
					       end
					     else //8
						   counter = counter + 1;
				      end
				    
				    3: //12
				      begin
					     if (counter > BLUE_TONE) // > 3 //10
					       begin
						      s = ~s;
						      speaker <= s;
						      counter = 0;
					       end
					     else //11
						   counter = counter + 1;
				      end
				    
				    `S_WIN: //15
				      begin
					     if (counter > WIN_TONE) // 6 //13
					       begin
						      s = ~s;
						      speaker <= s;
						      counter = 0;
					       end
					     else //14
						   counter = counter + 1;
				      end
				    
				    `S_LOSS: //18
				      begin
					     if (counter > ERROR_TONE) // 1 //16
					       begin
						      s = ~s;
						      speaker <= s;
						      counter = 0;
					       end
					     else //17
						   counter = counter + 1;
				      end
				    
				    default: //19
					  counter = 0;
			      endcase
		       end
		     else //21
		       begin
			      counter = 0;
			      speaker <= 0;
		       end
	      end
     end

   reg [(COD_COLOR-1):0]    count;

   always @ (posedge clock )
     begin
	    if (reset) //23
	      begin
		     count = 0;
		     num <= 0;
	      end
	    else     //24
	      begin
		     // count <= (count + 1) % (2**COD_COLOR) ;
		     // num <= count;
		     count = (count + 1) % (2**COD_COLOR) ;
		     num <= count;
	      end
     end

   reg [(COD_COLOR-1):0]    memory [0:(SIZE_MEM-1)];

   always @ (posedge clock )
     begin
	    if (reset) //25
	      begin
             //integer mar;
		     	data_out <= 0;
		     //for (mar = 0; mar <= SIZE_MEM - 1; mar = mar + 1)
		     	memory[0] = 0;
		     	memory[1] = 0;
			memory[2] = 0;
			memory[3] = 0;
			memory[4] = 0;
			memory[5] = 0;
			memory[6] = 0;
			memory[7] = 0;
			memory[8] = 0;
		     	memory[9] = 0;
			memory[10] = 0;
			memory[11] = 0;
			memory[12] = 0;
			memory[13] = 0;
			memory[14] = 0;
			memory[15] = 0;
			memory[16] = 0;
		     	memory[17] = 0;
			memory[18] = 0;
			memory[19] = 0;
			memory[20] = 0;
			memory[21] = 0;
			memory[22] = 0;
			memory[23] = 0;
			memory[24] = 0;
		     	memory[25] = 0;
			memory[26] = 0;
			memory[27] = 0;
			memory[28] = 0;
			memory[29] = 0;
			memory[30] = 0;
			memory[31] = 0;
//		       memory[mar] <= 0;
	      end
	    else //27
	      begin
		     data_out <= memory[address];
		     if (wr) //26
//			   memory[address] <= data_in;
			   memory[address] = data_in;
	      end
     end

   reg [4:0]                gamma;
   reg [(COD_COLOR-1):0]    ind;
   //reg[((2**COD_COLOR)-1):0] ind;
   reg [(SIZE_ADDRESS-1):0] scan;
   reg [(SIZE_ADDRESS-1):0] max;
   // reg[SIZE_ADDRESS:0] scan;
   // reg[SIZE_ADDRESS:0] max;
   reg [5:0]                timebase;
   reg [5:0]                count2;
   // reg [5:0]                timebase;
   // reg [5:0]                count2;

   always @ (posedge clock )
     begin
	    if (reset) //28
	      begin
		     nloss <= LED_OFF;
		     nl <=  LED_OFF;
		     play <= PLAY_OFF;
		     wr <= 0;
		     scan = 0;
		     max = 0;
		     ind = 0;
		     timebase = 0;
		     count2 = 0;
		     sound <= 0;
		     address <= 0;
		     data_in <= 0;
		     gamma = `G0;
	      end
	    else //104
	      begin
		     if (start == 1'b1) //29
			   gamma = `G1;
             else //30
			   gamma = gamma;
               
		     case (gamma)
		       
			   `G0: //31
			     begin
				    gamma = `G0;
			     end
			   
			   `G1: // set to zero //32
			     begin
				    nloss <= LED_OFF;
				    nl <= LED_OFF;
				    play <= PLAY_OFF;
				    wr <= 0;
				    max = 0;
				    timebase = COUNT_SEQ; 
				    gamma = `G2;
			     end
			   
			   `G2: //33
			     begin
				    scan = 0;
				    wr <= 1; // begin to write something!!! the num
				    address <= max; // address for data_in
				    data_in <= num; // num to data_in
				    gamma = `G3;
			     end
			   
			   `G3: //34
			     begin
				    wr <= 0; // close the write!!!
				    address <= scan;
				    gamma = `G4;
			     end
			   
			   `G4: //35
			     begin
				    gamma = `G5;
			     end
			   
			   `G5: //36
			     begin
				    nl[data_out] <= LED_ON;
				    count2 = timebase;
				    play <= PLAY_ON;
				    sound <= {1'b0,data_out};
//				    sound <= data_out;
				    gamma = `G6;
			     end
			   
			   `G6: //39
			     begin
				    if (count2 == 0) //37
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_OFF;
					     count2 = timebase;
					     gamma = `G7;
				      end
				    else //38
				      begin
					     count2 = count2 - 1;
					     gamma = `G6;
				      end
			     end
			   
			   `G7: //44
			     begin
				    if (count2 == 0) //42
				      begin
					     if (scan != max) //40
					       begin
						      scan = scan + 1;
						      gamma = `G3;
					       end
					     else //41
					       begin
						      scan = 0;
						      gamma = `G8;
					       end
				      end
				    else //43
				      begin
					     count2 = count2 - 1;
					     gamma = `G7;
				      end
			     end
			   
			   `G8: //45
			     begin
				    count2 = COUNT_KEY;
				    address <= scan;
				    gamma = `G9;
			     end
			   
			   `G9: //46
			     begin
				    gamma = `G10;
			     end
			   
			   `G10: //62
			     begin
				    if (count2 == 0) //47
				      begin
					     nloss <= LED_ON;
					     max = 0;
					     gamma = `K0;
				      end
				    else //61
				      begin
					     count2 = count2 - 1;
					     if (k[0] == KEY_ON) //50
					       begin
						      ind = 0;
						      sound <= 0;
						      play <= PLAY_ON;
						      count2 = timebase;
						      
						      if (data_out == 0) //48
							    gamma = `G10a;
						      else //49
						        begin
							       nloss <= LED_ON;
							       gamma = `Ea;
						        end
					       end
					     else if (k[1] == KEY_ON) //60
					       begin
						      ind = 1;
						      sound <= 1;
						      play <= PLAY_ON;
						      count2 = timebase;
						      
						      if (data_out == 1) //51
							    gamma = `G10a;
						      else //52
						        begin
							       nloss <= LED_ON;
							       gamma = `Ea;
						        end
					       end
					     else if (k[2] == KEY_ON) //59
					       begin
						      ind = 2;
						      sound <= 2;
						      play <= PLAY_ON;
						      count2 = timebase;
						      
						      if (data_out == 2) //53
							    gamma = `G10a;
						      else //54
						        begin
							       nloss <= LED_ON;
							       gamma = `Ea;
						        end
					       end
					     else if (k[3] == KEY_ON) //58
					       begin
						      ind = 3;
						      sound <= 3;
						      play <= PLAY_ON;
						      count2 = timebase;
						      
						      if (data_out == 3) //55
							    gamma = `G10a;
						      else //56
						        begin
							       nloss <= LED_ON;
							       gamma = `Ea;
						        end
					       end
					     else //57
						   gamma = `G10;
				      end
			     end
			   
			   `G10a: //63
			     begin
				    nl[ind] <= LED_ON;
				    gamma = `G11;
			     end
			   
			   `G11: //66
			     begin
				    if (count2 == 0) //64
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_OFF;
					     count2 = timebase;
					     gamma = `G12;
				      end
				    else //65
				      begin
					     count2 = count2 - 1;
					     gamma = `G11;
				      end
			     end
			   
			   `G12: //72
			     begin
				    if (count2 == 0) //70
				      begin
					     if (scan != max) //67
					       begin
						      scan = scan + 1;
						      gamma = `G8;
					       end
					     else if (max != (SIZE_MEM - 1)) //69
					       begin
						      max = max + 1;
						      timebase = timebase - DEC_SEQ;
						      gamma = `G2;
					       end
					     else //68
					       begin
						      play <= PLAY_ON;
						      sound <= `S_WIN;
						      count2 = COUNT_FIN;
						      gamma = `W0;
					       end
				      end
				    else //71
				      begin
					     count2 = count2 - 1;
					     gamma = `G12;
				      end
			     end
			   
			   `Ea: //73
			     begin
				    nl[ind] <= LED_ON;
				    gamma = `E0;
			     end
			   
			   `E0: //76
			     begin
				    if (count2 == 0) //74
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_OFF;
					     count2 = timebase;
					     gamma = `E1;
				      end
				    else //75
				      begin
					     count2 = count2 - 1;
					     gamma = `E0;
				      end
			     end
			   
			   `E1: //79
			     begin
				    if (count2 == 0) //77
				      begin
					     max = 0;
					     gamma = `K0;
				      end
				    else //78
				      begin
					     count2 = count2 - 1;
					     gamma = `E1;
				      end
			     end
			   
			   `K0: //80
			     begin
				    address <= max;
				    gamma = `K1;
			     end
			   
			   `K1: //81
			     begin
				    gamma = `K2;
			     end
			   
			   `K2: //82
			     begin
				    nl[data_out] <= LED_ON;
				    play <= PLAY_ON;
				    sound <= {1'b0,data_out};
//				    sound <= data_out;
				    count2 = timebase;
				    gamma = `K3;
			     end
			   
			   `K3: //85
			     begin
				    if (count2 == 0) //83
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_OFF;
					     count2 = timebase;
					     gamma = `K4;
				      end
				    else //84
				      begin
					     count2 = count2 - 1;
					     gamma = `K3;
				      end
			     end
			   
			   `K4: //90
			     begin
				    if (count2 == 0) //88
				      begin
					     if (max != scan) //86
					       begin
						      max = max + 1;
						      gamma = `K0;
					       end
					     else //87
					       begin
						      nl[data_out] <= LED_ON;
						      play <= PLAY_ON;
						      sound <= `S_LOSS;
						      count2 = COUNT_FIN;
						      gamma = `K5;
					       end
				      end
				    else //89
				      begin
					     count2 = count2 - 1;
					     gamma = `K4;
				      end
			     end
			   
			   `K5: //93
			     begin
				    if (count2==0) //91
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_OFF;
					     count2 = COUNT_FIN;
					     gamma = `K6;
				      end
				    else //92
				      begin
					     count2 = count2 - 1;
					     gamma = `K5;
				      end
			     end
			   
			   `K6: //96
			     begin
				    if (count2==0) //94
				      begin
					     nl[data_out] <= LED_ON;
					     play <= PLAY_ON;
					     sound <= `S_LOSS;
					     count2 = COUNT_FIN;
					     gamma = `K5;
				      end
				    else //95
				      begin
					     count2 = count2 - 1;
					     gamma = `K6;
				      end
			     end
			   
			   `W0: //99
			     begin
				    if (count2==0) //97
				      begin
					     nl <= LED_ON;
					     play <= PLAY_OFF;
					     count2 = COUNT_FIN;
					     gamma = `W1;
				      end
				    else //98
				      begin
					     count2 = count2 - 1;
					     gamma = `W0;
				      end
			     end
			   
			   `W1: //102
			     begin
				    if (count2==0) //100
				      begin
					     nl <= LED_OFF;
					     play <= PLAY_ON;
					     sound <= `S_WIN;
					     count2 = COUNT_FIN;
					     gamma = `W0;
				      end
				    else //101
				      begin
					     count2 = count2 - 1;
					     gamma = `W1;
				      end
			     end
			   
			   default: //103
				 gamma = `G1;
		     endcase
	      end
     end
endmodule
