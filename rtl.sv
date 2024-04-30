// Code your design here
// Code your design here
module async_fifo(
		wr_clk_i	  ,
		rd_clk_i 	  ,
		rst_i		  ,
		wr_en_i		  ,
		wdata_i		  ,
		full_o	 	  ,
		wr_error_o	  ,
		rd_en_i	  	  ,
		rdata_o		  ,
		empty_o	       	  ,
		rd_error_o
		);

parameter DEPTH=512, WIDTH=8, PTR_WIDTH=9;

input wr_clk_i	  	  ;
input rd_clk_i	  	  ;
input rst_i		  ;
// write interface
input wr_en_i		  ;
input [WIDTH-1:0] wdata_i ;
output logic full_o	 	  ;
output logic wr_error_o	  ;
// read interface
input rd_en_i	  	  ;
output logic [WIDTH-1:0] rdata_o    ;
output logic empty_o	       	  ;
output logic rd_error_o             ;

//write pointer, read pointer,toggle flags
logic [PTR_WIDTH-1:0] wr_ptr;
logic [PTR_WIDTH-1:0] rd_ptr;
logic [PTR_WIDTH-1:0] wr_ptr_rd_clk;
logic [PTR_WIDTH-1:0] rd_ptr_wr_clk;
logic wr_toggle_f;
logic rd_toggle_f;
logic wr_toggle_f_rd_clk;
logic rd_toggle_f_wr_clk;

//declare the memory
logic [WIDTH-1:0] mem [DEPTH-1:0];
integer i;

// processes in FIFO
// write, read => they are happen in different clk
// so both needs to be coded in different always block
// write always block
always @(posedge  wr_clk_i) begin
if(rst_i==1) begin
//all reg variables assign to reset value
	rd_error_o = 0;
	full_o = 0;
	empty_o = 1;
	wr_error_o = 0;
	rdata_o = 0;
	wr_ptr = 0;
	rd_ptr = 0;
	wr_ptr_rd_clk = 0;
	rd_ptr_wr_clk = 0;
	wr_toggle_f = 0;
	rd_toggle_f = 0;
	wr_toggle_f_rd_clk = 0;
	rd_toggle_f_wr_clk = 0;
	for (i = 0;i < DEPTH; i++)
      mem[i] = 0;	 	  
end
else begin // rst_i is not applied
    wr_error_o = 0;
 // write can happen
 if(wr_en_i == 1) begin
   if(full_o == 1) begin
    wr_error_o = 1;
   end
   else begin
    mem[wr_ptr] = wdata_i;
     if(wr_ptr==DEPTH-1) begin
       wr_toggle_f = ~wr_toggle_f;
     end
    wr_ptr = wr_ptr+1;
   end
 end
end	
end

//read always block
always @(posedge rd_clk_i) begin
if(rst_i!=1) begin
    rd_error_o = 0;
 // read can happen
 if(rd_en_i == 1) begin
   if(empty_o == 1) begin
    rd_error_o = 1;
   end
   else begin
     rdata_o = mem[rd_ptr];
     if(rd_ptr==DEPTH-1) begin
       rd_toggle_f = ~rd_toggle_f;
     end
    rd_ptr = rd_ptr+1;
   end
 end
end
end

// logic for empty and full condition
always @ (*) begin
 empty_o = 0;
 full_o = 0;
//full
  if (wr_ptr==rd_ptr_wr_clk )begin
    if (wr_toggle_f!=rd_toggle_f_wr_clk)
        full_o = 1;
    end
//empty
  if (wr_ptr_rd_clk==rd_ptr)begin
     if (wr_toggle_f_rd_clk==rd_toggle_f)
        empty_o = 1;
     end
 end
// synchronizer
always @(posedge rd_clk_i) begin
  wr_ptr_rd_clk <= wr_ptr;
  wr_toggle_f_rd_clk <= wr_toggle_f;
end

always @(posedge wr_clk_i) begin
  rd_ptr_wr_clk <= rd_ptr;
  rd_toggle_f_wr_clk <= rd_toggle_f;
end
endmodule
