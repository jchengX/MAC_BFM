class crc7_monitor_before extends uvm_monitor;
  `uvm_component_utils(crc7_monitor_before)
  
  uvm_analysis_port#(crc7_transaction) mon_ap_before;
  
  virtual crc7_if vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    void'(uvm_resource_db#(virtual crc7_if)::read_by_name(.scope("ifs"), .name("crc7_if"), .val(vif)));
    mon_ap_before = new(.name("mon_ap_before"), .parent(this));
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    crc7_transaction c7_tx;
    c7_tx = crc7_transaction::type_id::create(.name("c7_tx"), .contxt(get_full_name()));
    
    forever begin
      @(negedge vif.sig_clk)
      begin
        c7_tx.crc = vif.sig_crc;
        `uvm_info("monitor_before",$sformatf("c7_tx.crc is '%b'", c7_tx.crc), UVM_LOW);
        mon_ap_before.write(c7_tx);
      end
    end
  endtask: run_phase
endclass: crc7_monitor_before

class crc7_monitor_after extends uvm_monitor;
  `uvm_component_utils(crc7_monitor_after)
  
  uvm_analysis_port#(crc7_transaction) mon_ap_after;
  
  virtual crc7_if vif;
  
  crc7_transaction c7_tx;
  	//For coverage
	crc7_transaction c7_tx_cg;

	//Define coverpoints
	covergroup crc7_cg;
	endgroup: crc7_cg
   
  function new(string name, uvm_component parent);
    super.new(name, parent);
    crc7_cg = new;
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    void'(uvm_resource_db#(virtual crc7_if)::read_by_name(.scope("ifs"), .name("crc7_if"), .val(vif)));
    mon_ap_after = new(.name("mon_ap_after"), .parent(this));
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    integer count = 42, rst = 0;
    
    c7_tx = crc7_transaction::type_id::create(.name("c7_tx"), .contxt(get_full_name()));
    
    forever begin
      @(negedge vif.sig_clk)
      begin
        rst = 0;
        count = count - 1;
        if(count == 0)
          begin
            rst = 1;
            count = 42;
            predictor();
            `uvm_info("monitor_after",$sformatf("c7_tx.crc is '%b'", c7_tx.crc), UVM_LOW);
            c7_tx_cg = c7_tx;
          
            crc7_cg.sample();
          
            mon_ap_after.write(c7_tx);
          end
        end
      end

endtask: run_phase

virtual function void predictor();
  c7_tx.crc = 7'b0101010;
endfunction: predictor
endclass: crc7_monitor_after
            
        
  
  
  
  
        
    
