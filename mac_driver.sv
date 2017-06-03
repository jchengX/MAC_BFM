class mac_driver extends uvm_driver#(mac_transaction);
  `uvm_component_utils(mac_driver)
  
virtual mac_if vif;
  
 function new(string name, uvm_component parent);
 super.new(name, parent);
endfunction: new
  
function void build_phase(uvm_phase phase);
 super.build_phase(phase);
    
 void'(uvm_resource_db#(virtual mac_if)::read_by_name(.scope("ifs"), .name("mac_if"), .val(vif)));
  endfunction: build_phase
  
task run_phase(uvm_phase phase);
    drive();
  endtask: run_phase
  
  virtual task drive();
    mac_transaction c7_tx;
 integer counter = 40;
bit[39:0] data;
    data = 40'b0101000100000000000000000000000000000000; 
 vif.sig_data = 1'b0;
 vif.sig_rst = 1'b0;
    
    
    forever begin
      
      //seq_item_port.get_next_item(c7_tx);
      
  @(negedge vif.sig_clk)
   begin
    vif.sig_rst = 1'b0;
    vif.sig_data = data[counter - 1];
 counter = counter - 1;
      if(counter == 0)
 begin
            #28 counter = 40;
            vif.sig_rst = 1'b1;
 end
  end         
          //seq_item_port.item_done();
      end
  endtask: drive
endclass: mac_driver
  
        
  
