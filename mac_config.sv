class mac_config extends uvm_object;

    `uvm_object_utils(mac_config)
        virtual apb_if vif;
  

    function new(string name="mac_config");
        super.new(name);
    endfunction

endclas
