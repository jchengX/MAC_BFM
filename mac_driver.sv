class mac_driver extends uvm_driver#(mac_transaction);
  `uvm_component_utils(mac_driver)
  
  virtual mac_if vif;
  vif.cb_drv hook;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(mac_if)::get(this, "", "vif", vif)) begin
    `uvm_fatal("mac_driver", "No virtual interface specified for this driver instance") 
  endfunction: build_phase
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    mac_transaction tr;
    reset();
    forever begin
      @(vif.clk);
      seq_item_port.get_next_item(tr);
      case(tr.status)
        TRANSMIT:begin
          case(tr.op_cmd)
            RESET:reset();
            SEND_UNICAST:send_unicast(tr.address,tr.data);
            SEND_BEACON:send_beacon();
            SEND_AGGREGATE:send_aggregate(tr.address,tr.data);
            default:`uvm_fatal("mac_driver","No valid command!")
          endcase
        RECEIVE:begin
          case(tr.rx_type)
            UNICAST:send_ack();
            AGGREGATE:send_block_ack();
            default:@(vif.clk);
          endcase
      seq_item_port.item_done();
    end
  endtask: run_phase
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : reset
  //input  : n/a
  //output : n/a
  //descripton : reset all signals
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task reset();
   begin
    hook.tx_frame <= 0;
    hook.tx_valid <= 0;
    hook.tx_data  <= 0;
    hook.rx_frame <= 0;
    hook.rx_valid <= 0;
    hook.rx_data  <= 0;
   end
  endtask:reset
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_ack
  //input  : n/a
  //output : n/a
  //descripton : send ack when receive unicast packet
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_block_ack
  //input  : n/a
  //output : n/a
  //descripton : send block ack when receive aggregate packet
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_unicast
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive unicast packet to interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send_unicast(input bit [47:0] address,input bit [DATA_LEN-1:0] data);
    mac_transaction tr;
    integer counter = 40;
    bit [39:0] data;
    data = 40'b0101000100000000000000000000000000000000; 
    vif.sig_data = 1'b0;
    vif.sig_rst = 1'b0;
    forever begin   
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
  end
  endtask: send_unicast
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_beacon
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive beacon packet to interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_aggregate
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive aggregate packet to interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  
  
endclass: mac_driver
  
        
  
