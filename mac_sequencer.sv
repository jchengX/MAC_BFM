`ifndef MAC_SEQUENCER__SV
`define MAC_SEQUENCER__SV

class mac_sequencer extends uvm_sequencer #(mac_rw);

    `uvm_component_utils(mac_sequencer)

    function new(input string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

endclass : mac_sequencer

`endif
