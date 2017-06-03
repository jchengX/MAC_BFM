class crc7_agent extends uvm_agent;
  `uvm_component_utils(crc7_agent)
  
  uvm_analysis_port #(crc7_transaction) agent_ap_before;
  uvm_analysis_port #(crc7_transaction) agent_ap_after;
  
  crc7_sequencer c7_seqr;
  crc7_driver c7_drvr;
  crc7_monitor_before c7_mon_before;
  crc7_monitor_after c7_mon_after;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agent_ap_before = new(.name("agent_ap_before"), .parent(this));
    agent_ap_after = new(.name("agent_ap_after"), .parent(this));
    
    c7_seqr = crc7_sequencer::type_id::create(.name("c7_seqr"), .parent(this));
    c7_drvr = crc7_driver::type_id::create(.name("c7_drvr"), .parent(this));
    c7_mon_before = crc7_monitor_before::type_id::create(.name("c7_mon_before"), .parent(this));
    c7_mon_after = crc7_monitor_after::type_id::create(.name("c7_mon_after"), .parent(this));
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    c7_drvr.seq_item_port.connect(c7_seqr.seq_item_export);
    c7_mon_before.mon_ap_before.connect(agent_ap_before);
    c7_mon_after.mon_ap_after.connect(agent_ap_after);
  endfunction: connect_phase
endclass: crc7_agent
    
    
