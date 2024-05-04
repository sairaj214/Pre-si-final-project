class scoreboard;

 int no_trans;
  logic [7:0] RAM [7:0];
  bit [3:0] wCount;
  bit [3:0] rCount;
  mailbox mon2sb;
  
 function new(mailbox mon2sb);
   this.mon2sb = mon2sb;
   foreach(RAM[i])begin
     RAM[i] = 8'h0;
   end
 endfunction 
 
  task main;
    begin   
    transaction trans;
    
    mon2sb.get(trans);
     
      
      if(trans.winc)begin
       RAM[wCount] = trans.data_write;
       
        wCount = wCount + 1;
        end
        $display("%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h",RAM[0],RAM[1],RAM[2],RAM[3],RAM[4],RAM[5],RAM[6],RAM[7]);

      

      if(trans.rinc)begin
        if(trans.data_read == RAM[rCount])begin
          $display("MATCH at address %0h - trans.Data = %0h - Saved Data = %0h",rCount, trans.data_read,RAM[rCount]);
         
          
          rCount = rCount + 1;
       end else begin
         $display("ERROR at address %0h - trans.Data = %0h - Saved Data = %0h",rCount,trans.data_read,RAM[rCount]);
      end
    end

      
     if(trans.wfull)begin
       $display("FIFO is full");
    end
     if(trans.rempty)begin
       $display("FIFO is empty");
    end
	if(trans.half_full)begin
       $display("FIFO is half full");
    end
     if(trans.half_rempty)begin
       $display("FIFO is half empty");
    end
    no_trans++;
   end
  endtask
endclass
