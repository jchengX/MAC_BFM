class crc7_env extends uvm_env;
  `uvm_component_utils(crc7_env)
  
  crc7_agent c7_agent;
  crc7_scoreboard c7_sb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    c7_agent = crc7_agent::type_id::create(.name("c7_agent"), .parent(this));
    c7_sb = crc7_scoreboard::type_id::create(.name("c7_sb"), .parent(this));
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    c7_agent.agent_ap_before.connect(c7_sb.sb_export_before);
    c7_agent.agent_ap_after.connect(c7_sb.sb_export_after);
  endfunction: connect_phase
endclass: crc7_env
