//////////////////////////////////////////
// File : mac_env
// Data : 2017/06/03
// Description : mac bfm env
/////////////////////////////////////////

`ifndef MAC_ENV__SV
`define MAC_ENV__SV

class mac_env extends uvm_env;
  `uvm_component_utils(mac_env)
  
  mac_agent mac_agent;
  mac_scoreboard mac_sb;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mac_agent = mac_agent::type_id::create("mac_agent", this);
    mac_sb = mac_scoreboard::type_id::create("mac_sb", this);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction: connect_phase
endclass: mac_en

`endif //MAC_ENV__SV
