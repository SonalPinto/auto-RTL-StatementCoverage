/***********************************************************************
        Copyright (C) 2012,
        Virginia Polytechnic Institute & State University
        
        This verilog file is transformed from ITC 99 benchmark
        which is available from
        http://www.cad.polito.it/downloads/tools/itc99.html This
        verilog file was originally coverted by Mr. Min Li under
        the supervision of Dr. Michael S. Hsiao, in the Bradley
        Department of Electrical Engineering, VPI&SU, in 2012. We
        used a commertial Tool: VHDL2verilog 17.01g for initial
        convertion and made necessary changes manually. The
        verilog file is verified by random simulation.

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

`define false 1'b 0
`define FALSE 1'b 0
`define true 1'b 1
`define TRUE 1'b 1

`timescale 1 ns / 1 ns // timescale for following modules


module b14 (
   clock,
   reset,
   addr,
   datai,
   datao,
   rd,
   wr);
 

input   clock; 
input   reset; 
output   [31:0] addr; 
input   [31:0] datai; 
output   [31:0] datao; 
output   rd; 
output   wr; 

reg     [31:0] addr; 
reg     [31:0] datao; 
reg     rd; 
reg     wr; 
parameter process_1_FETCH = 0; 
parameter process_1_EXEC = 1; 
integer  process_1_reg0; 
integer  process_1_reg1; 
integer  process_1_reg2; 
integer  process_1_reg3; 
reg      process_1_B; 
reg     [31:0]  process_1_MAR; 
integer  process_1_MBR; 
reg     [1:0]  process_1_mf; 
reg     [2:0]  process_1_df; 
reg      process_1_cf; 
reg     [3:0]  process_1_ff; 
reg     [31:0]  process_1_tail; 
integer  process_1_IR; 
reg      process_1_state; 
integer  process_1_r; 
integer  process_1_m; 
integer  process_1_t; 
integer  process_1_d; 
integer  process_1_temp; 
reg     [1:0]  process_1_s; 


always @(posedge clock or posedge reset)
   begin : process_1
   if (reset === 1'b 1)
      begin
      process_1_MAR = 0;   
      process_1_MBR = 0;   
      process_1_IR = 0;   
      process_1_d = 0;   
      process_1_r = 0;   
      process_1_m = 0;   
      process_1_s = 0;   
      process_1_temp = 0;   
      process_1_mf = 0;   
      process_1_df = 0;   
      process_1_ff = 0;   
      process_1_cf = 0;   
      process_1_tail = 0;   
      process_1_B = 1'b 0;   
      process_1_reg0 = 0;   
      process_1_reg1 = 0;   
      process_1_reg2 = 0;   
      process_1_reg3 = 0;   
      addr <= 0;   
      rd <= 1'b 0;   
      wr <= 1'b 0;   
      datao <= 0;   
      process_1_state = process_1_FETCH;   
      end
   else
      begin
      rd <= 1'b 0;   
      wr <= 1'b 0;   
      case (process_1_state)
      process_1_FETCH:
         begin
         process_1_MAR = process_1_reg3 %  /* VHDL ** operator */ 2**20;   
         addr <= process_1_MAR;   
         rd <= 1'b 1;   
         process_1_MBR = datai;   
         process_1_IR = process_1_MBR;   
         process_1_state = process_1_EXEC;   
         end
      process_1_EXEC:
         begin
         if (process_1_IR < 0)
            begin
            process_1_IR = -process_1_IR;   
            end
         process_1_mf = process_1_IR /  /* VHDL ** operator */ (2**27) % 4;   
         process_1_df = process_1_IR /  /* VHDL ** operator */ (2**24) %  /* VHDL ** operator */ (2**3);
         process_1_ff = process_1_IR /  /* VHDL ** operator */ (2**19) %  /* VHDL ** operator */ (2**4);   
         process_1_cf = process_1_IR /  /* VHDL ** operator */ (2**23) % 2;   
         process_1_tail = process_1_IR %  /* VHDL ** operator */ 2**20;   
         process_1_reg3 = process_1_reg3 %  /* VHDL ** operator */ (2**29) + 8;   
         process_1_s = process_1_IR /  /* VHDL ** operator */ (2**29) % 4;   
         case (process_1_s)
         0:
            begin
            process_1_r = process_1_reg0;   
            end
         1:
            begin
            process_1_r = process_1_reg1;   
            end
         2:
            begin
            process_1_r = process_1_reg2;   
            end
         3:
            begin
            process_1_r = process_1_reg3;   
            end
         endcase
         case (process_1_cf)
         1:
            begin
            case (process_1_mf)
            0:
               begin
               process_1_m = process_1_tail;   
               end
            1:
               begin
               process_1_m = datai;   
               addr <= process_1_tail;   
               rd <= 1'b 1;   
               end
            2:
               begin
               addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
               rd <= 1'b 1;   
               process_1_m = datai;   
               end
            3:
               begin
               addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
               rd <= 1'b 1;   
               process_1_m = datai;   
               end
            endcase
            case (process_1_ff)
            0:
               begin
               if (process_1_r < process_1_m)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            1:
               begin
               if (~(process_1_r < process_1_m))
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            2:
               begin
               if (process_1_r === process_1_m)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            3:
               begin
               if (~(process_1_r === process_1_m))
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            4:
               begin
               if (~(process_1_r > process_1_m))
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            5:
               begin
               if (process_1_r > process_1_m)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            6:
               begin
               if (process_1_r >  /* VHDL ** operator */ (2**30) - 1)
                  begin
                  process_1_r = process_1_r -  /* VHDL ** operator */ (2**30);   
                  end
               if (process_1_r < process_1_m)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            7:
               begin
               if (process_1_r >  /* VHDL ** operator */ (2**30) - 1)
                  begin
                  process_1_r = process_1_r -  /* VHDL ** operator */ (2**30);   
                  end
               if (~(process_1_r < process_1_m))
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            8:
               begin
               if (process_1_r < process_1_m | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            9:
               begin
               if (~(process_1_r < process_1_m) | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            10:
               begin
               if (process_1_r === process_1_m | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            11:
               begin
               if (~(process_1_r === process_1_m) | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            12:
               begin
               if (~(process_1_r > process_1_m) | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            13:
               begin
               if (process_1_r > process_1_m | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            14:
               begin
               if (process_1_r >  /* VHDL ** operator */ (2**30) - 1)
                  begin
                  process_1_r = process_1_r -  /* VHDL ** operator */ (2**30);   
                  end
               if (process_1_r < process_1_m | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            15:
               begin
               if (process_1_r >  /* VHDL ** operator */ (2**30) - 1)
                  begin
                  process_1_r = process_1_r -  /* VHDL ** operator */ (2**30);   
                  end
               if (~(process_1_r < process_1_m) | process_1_B === 1'b 1)
                  begin
                  process_1_B = 1'b 1;   
                  end
               else
                  begin
                  process_1_B = 1'b 0;   
                  end
               end
            endcase
            end
         0:
            begin
            if (~(process_1_df === 7))
               begin
               if (process_1_df === 5)
                  begin
                  if (~process_1_B === 1'b 1)
                     begin
                     process_1_d = 3;   
                     end
                  end
               else if (process_1_df === 4 )
                  begin
                  if (process_1_B === 1'b 1)
                     begin
                     process_1_d = 3;   
                     end
                  end
               else if (process_1_df === 3 )
                  begin
                  process_1_d = 3;   
                  end
               else if (process_1_df === 2 )
                  begin
                  process_1_d = 2;   
                  end
               else if (process_1_df === 1 )
                  begin
                  process_1_d = 1;   
                  end
               else if (process_1_df === 0 )
                  begin
                  process_1_d = 0;   
                  end
               case (process_1_ff)
               0:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  process_1_t = 0;   
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = process_1_t - process_1_m;   
                     end
                  1:
                     begin
                     process_1_reg1 = process_1_t - process_1_m;   
                     end
                  2:
                     begin
                     process_1_reg2 = process_1_t - process_1_m;   
                     end
                  3:
                     begin
                     process_1_reg3 = process_1_t - process_1_m;   
                     end
                  default:
                     ;
                  endcase
                  end
               1:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  process_1_reg2 = process_1_reg3;   
                  process_1_reg3 = process_1_m;   
                  end
               2:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = process_1_m;   
                     end
                  1:
                     begin
                     process_1_reg1 = process_1_m;   
                     end
                  2:
                     begin
                     process_1_reg2 = process_1_m;   
                     end
                  3:
                     begin
                     process_1_reg3 = process_1_m;   
                     end
                  default:
                     ;
                  endcase
                  end
               3:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = process_1_m;   
                     end
                  1:
                     begin
                     process_1_reg1 = process_1_m;   
                     end
                  2:
                     begin
                     process_1_reg2 = process_1_m;   
                     end
                  3:
                     begin
                     process_1_reg3 = process_1_m;   
                     end
                  default:
                     ;
                  endcase
                  end
               4:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               5:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               6:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               7:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               8:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               9:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               10:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r + process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               11:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_m = process_1_tail;   
                     end
                  1:
                     begin
                     process_1_m = datai;   
                     addr <= process_1_tail;   
                     rd <= 1'b 1;   
                     end
                  2:
                     begin
                     addr <= (process_1_tail + process_1_reg1) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  3:
                     begin
                     addr <= (process_1_tail + process_1_reg2) %  /* VHDL ** operator */ 2**20;   
                     rd <= 1'b 1;   
                     process_1_m = datai;   
                     end
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  1:
                     begin
                     process_1_reg1 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  2:
                     begin
                     process_1_reg2 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  3:
                     begin
                     process_1_reg3 = (process_1_r - process_1_m) %  /* VHDL ** operator */ (2**30);   
                     end
                  default:
                     ;
                  endcase
                  end
               12:
                  begin
                  case (process_1_mf)
                  0:
                     begin
                     process_1_t = process_1_r / 2;   
                     end
                  1:
                     begin
                     process_1_t = process_1_r / 2;   
                     if (process_1_B === 1'b 1)
                        begin
                        process_1_t = process_1_t %  /* VHDL ** operator */ (2**29);   
                        end
                     end
                  2:
                     begin
                     process_1_t = process_1_r %  /* VHDL ** operator */ (2**29) * 2;   
                     end
                  3:
                     begin
                     process_1_t = process_1_r %  /* VHDL ** operator */ (2**29) * 2;   
                     if (process_1_t >  /* VHDL ** operator */ (2**30) - 1)
                        begin
                        process_1_B = 1'b 1;   
                        end
                     else
                        begin
                        process_1_B = 1'b 0;   
                        end
                     end
                  default:
                     ;
                  endcase
                  case (process_1_d)
                  0:
                     begin
                     process_1_reg0 = process_1_t;   
                     end
                  1:
                     begin
                     process_1_reg1 = process_1_t;   
                     end
                  2:
                     begin
                     process_1_reg2 = process_1_t;   
                     end
                  3:
                     begin
                     process_1_reg3 = process_1_t;   
                     end
                  default:
                     ;
                  endcase
                  end
               13,
               14,
               15:
                  ;
               endcase
               end
            else if (process_1_df === 7 )
               begin
               case (process_1_mf)
               0:
                  begin
                  process_1_m = process_1_tail;   
                  end
               1:
                  begin
                  process_1_m = process_1_tail;   
                  end
               2:
                  begin
                  process_1_m = process_1_reg1 %  /* VHDL ** operator */ 2**20 + process_1_tail % 
       /* VHDL ** operator */ 2**20;   
                  end
               3:
                  begin
                  process_1_m = process_1_reg2 %  /* VHDL ** operator */ 2**20 + process_1_tail % 
       /* VHDL ** operator */ 2**20;   
                  end
               endcase
               addr <= process_1_m % 2 * 20;   
//  addr <= m;
//  removed (!)fs020699
               wr <= 1'b 1;   
               datao <= process_1_r;   
               end
            end
         endcase
         process_1_state = process_1_FETCH;   
         end
      endcase
      end
   end



// Subprograms that are created by VHDL2V translator
function integer power;
    input left_operand;
    integer left_operand;
    input exponent;
    integer exponent;
    integer index;
    begin
        power = 1;
        for(index = 0; index < exponent; index = index+1)
            power = power * left_operand;
    end
endfunction // power 

endmodule // module b14

