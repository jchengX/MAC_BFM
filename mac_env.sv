//////////////////////////////////////////
// File : mac_env
// Data : 2017/06/03
// Description : mac bfm env
/////////////////////////////////////////

`ifndef MAC_ENV__SV
`define MAC_ENV__SV
//ToDo: Include required files here
class mac_vsequencer extends uvm_sequencer;
    //ral_sys_TEST    regmodel;
    `uvm_component_utils(mac_vsequencer)
    
    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass

//Including all the required component files here
class mac_env extends uvm_env;
    //ral_sys_TEST    regmodel;
    mac_agent       mac_agt; 
    //reg2mac_adapter reg2host;
    mac_vsequencer  vsqr;
    
     `uvm_component_utils(mac_env)

    extern function new(string name= "mac_env", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
endclass: mac_env

function mac_env::new(string name= "mac_env",uvm_component parent=null);
    super.new(name,parent);
endfunction:new

function void mac_env::build_phase(uvm_phase phase);
    super.build();
    mac_agt = mac_agent::type_id::create("mac_agt",this); 
    vsqr = mac_vsequencer::type_id::create("vsqr",this);
endfunction: build_phase

function void mac_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Connecting the driver to the sequencer via ports
    //regmodel.set_hdl_path_root("");
    regmodel.default_map.set_sequencer(mac_agt.sqr,reg2host);
    vsqr.regmodel = regmodel;

    // ToDo: Register any required callbacks

endfunction: connect_phase

task mac_env::main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this,"");
    //ToDo: Run your simulation here
    phase.drop_objection(this);
endtask:main_phase

`endif // MAC_ENV__S
