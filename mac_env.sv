////////////////////////////////////
// File : mac_agent
// Data : 2017/06/03
// Description : mac bfm agent
////////////////////////////////////

`ifndef MAC_AGENT__SV
`define MAC_AGENT__SV

typedef class mac_agent;

class mac_agent extends uvm_agent;
    bit             sqr_on=1'b1;
    bit             drv_on=1'b1;
    bit             mon_on=1'b1;

    mac_config      cfg;
    mac_sequencer   sqr;
    mac_driver      drv;
    mac_monitor     mon;

    mac_if         vif;

    `uvm_component_utils_begin(mac_agent)
        `uvm_field_int(sqr_on,UVM_ALL_ON)
        `uvm_field_int(drv_on,UVM_ALL_ON)
        `uvm_field_int(mon_on,UVM_ALL_ON)
        `uvm_field_object(cfg,UVM_ALL_ON)
        `uvm_field_object(sqr,UVM_ALL_ON)
        `uvm_field_object(drv,UVM_ALL_ON)
        `uvm_field_object(mon,UVM_ALL_ON)
    `uvm_component_utils_end
    
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);

        //if(!this.get_config_int("sqr_on", sqr_on)) begin
        //    `uvm_fatal("get_config_int", "Couldn't found sqr_on")
        //end
        //if(!this.get_config_int("drv_on", drv_on)) begin
        //    `uvm_fatal("get_config_int", "Couldn't found drv_on")
        //end
        //if(!this.get_config_int("mon_on", mon_on)) begin
        //    `uvm_fatal("get_config_int", "Couldn't found mon_on")
        //end

        if(sqr_on == 1'b1) begin
            sqr = mac_sequencer::type_id::create("sqr", this);
        end
        if(drv_on == 1'b1) begin
            drv = mac_driver::type_id::create("drv", this);
        end
        if(mon_on == 1'b1) begin
            mon = mac_monitor::type_id::create("mon", this);
        end

        if (!uvm_config_db#(mac_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("mac_agent", "No virtual interface specified for this agent instance")
        end
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        if((drv_on==1'b1)&&(sqr_on==1'b1)) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction
endclass: mac_agent

`endif // MAC_AGENT__SV
