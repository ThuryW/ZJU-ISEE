`timescale 1ns / 10ps

module button_press_unit_tb;
  reg clk,ButtonIn,reset;
  wire ButtonOut;
  parameter delay=10;
//  
   initial begin
      clk = 0;	reset = 1;	ButtonIn = 0;
      #(delay+1) reset=0;
      #(delay*100 )   
       repeat (25) 
         begin
           #(delay*5) ButtonIn=0;
           #(delay*5) ButtonIn=1;
         end
       #(delay*900) 
         repeat (25)
            begin
            #(delay*5) ButtonIn=1;
            #(delay*5) ButtonIn=0;
          end
       #(delay*1200) 
          repeat (25) 
         begin
           #(delay*5) ButtonIn=0;
           #(delay*5) ButtonIn=1;
         end
       #(delay*900) 
         repeat (25)
            begin
            #(delay*5) ButtonIn=1;
            #(delay*5) ButtonIn=0;
          end
       #(delay*100) 
       $stop;
      end
 //     
    always #(delay/2) clk=~clk;
 //

button_process_unit #(.sim(1))  button_unit(
  .clk(clk),
  .reset(reset),
  .ButtonIn(ButtonIn),
  .ButtonOut(ButtonOut)
   );

endmodule
