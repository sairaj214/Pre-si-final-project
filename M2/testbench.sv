// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module async_fifo_tb();

parameter DEPTH=512, WIDTH=8, PTR_WIDTH=9;

logic wr_clk_i;
logic rd_clk_i;
logic rst_i;
logic wr_en_i;
logic [WIDTH-1:0] wdata_i; 
logic full_o;	 	  
logic wr_error_o;	  
logic rd_en_i;	  	  
logic [WIDTH-1:0] rdata_o;
logic empty_o;	       	  
logic rd_error_o;
//wire [PTR_WIDTH-1:0] wr_ptr;
//wire [PTR_WIDTH-1:0] rd_ptr;
integer i;

async_fifo dut(
		.wr_clk_i(wr_clk_i)	 ,
		.rd_clk_i(rd_clk_i)	 ,
		.rst_i(rst_i)      	 ,
		.wr_en_i(wr_en_i)	 ,
	        .wdata_i(wdata_i)    	 ,
		.full_o(full_o)	    	 ,
	        .wr_error_o(wr_error_o)  ,
		.rd_en_i(rd_en_i)	 ,
	        .rdata_o(rdata_o)   	 ,
		.empty_o(empty_o)	 ,
		.rd_error_o(rd_error_o)
		);
  
initial
 begin
   wr_clk_i = 0;
  forever  #5 wr_clk_i = ~wr_clk_i;
 end

initial
 begin
   rd_clk_i = 0;
  forever  #7 rd_clk_i = ~rd_clk_i;
 end

initial begin
 rst_i = 1;
//driving design inputs to 0
 wr_en_i = 0;
 rd_en_i = 0;
 wdata_i = 0;
@(posedge wr_clk_i); //holding 
 rst_i = 0; //releasing
 write_fifo();
 read_fifo();
end
//now design in a state where we can apply the inputs
 
task write_fifo();
  begin
   for (i = 0; i < DEPTH; i = i+1 ) begin
       @(posedge wr_clk_i);
       wr_en_i = 1;
       wdata_i = $random;
   end
   @(posedge wr_clk_i);
   wr_en_i = 0;
   wdata_i = 0;
 end
endtask

task read_fifo();
 begin
   for (i = 0; i < DEPTH; i = i++ ) begin
       @(posedge rd_clk_i);
       rd_en_i = 1;
   end
   @(posedge rd_clk_i);
   rd_en_i = 0;
 end
endtask
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end

initial begin
#1000;
$finish;
end

endmodule
