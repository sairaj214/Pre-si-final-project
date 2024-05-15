class monitor; 
 virtual intf virt_ff;
 mailbox mon2sb;
 
  function new(virtual intf virt_ff,mailbox mon2scb);
  this.virt_ff = virt_ff;
  this.mon2sb = mon2sb;
 endfunction
 
 task drive;
   begin
     
   transaction trans;
   trans = new(); 	  
     @(posedge virt_ff.rclk);   
    trans.rinc = virt_ff.rinc;
    trans.winc = virt_ff.winc;
    trans.data_write = virt_ff.data_write;  
    trans.wfull = virt_ff.wfull;
    trans.rempty = virt_ff.rempty;
	trans.half_rempty = virt_ff.half_rempty;
	trans.half_full = virt_ff.half_full;
    trans.data_read = virt_ff.data_read; 
    mon2sb.put(trans);
  end
 endtask
    
    
    
      task  main;
		begin
          for (integer i = 0; i < 1; i++) begin
        	drive(); // Call the original
    	end
        end
      endtask

endclass
