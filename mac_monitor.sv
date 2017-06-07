`ifndef APB_MONITOR__SV
`define APB_MONITOR__SV


class mac_monitor extends uvm_monitor;
    bit     has_fcov;

    virtual mac_if.passive sigs;

    uvm_analysis_port#(mac_rw) ap;
    mac_config cfg;

    `uvm_component_utils(mac_monitor)
    `uvm_register_cb(mac_monitor,mac_monitor_cbs)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        mac_agent agent;
        if ($cast(agent, get_parent()) && agent != null) begin
            sigs = agent.vif;
        end
        else begin
            `uvm_fatal("APB/MON/NOVIF", "No virtual interface specified for this monitor instance")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            mac_rw tr;
            
            // Wait for a SETUP cycle
            do begin
               @ (this.sigs.pck);
            end
            while (this.sigs.pck.psel !== 1'b1 ||
                   this.sigs.pck.penable !== 1'b0);

            tr = mac_rw::type_id::create("tr", this);
            
            tr.kind = (this.sigs.pck.pwrite) ? mac_rw::WRITE : mac_rw::READ;
            tr.addr = this.sigs.pck.paddr;

            @ (this.sigs.pck);
            if (this.sigs.pck.penable !== 1'b1) begin
                `uvm_error("APB", "APB protocol violation: SETUP cycle not followed by ENABLE cycle");
            end
            tr.data = (tr.kind == mac_rw::READ) ? this.sigs.pck.prdata :
                                                  this.sigs.pck.pwdata;

            `uvm_do_callbacks(mac_monitor,mac_monitor_cbs,trans_observed(this,tr))

            ap.write(tr);
        end
    endtask: run_phase

endclass: mac_monitor

`endif
