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
  
  //uvm run_phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    mac_transaction tr;
    reset();
    forever begin
      @(vif.clk);
      seq_item_port.get_next_item(tr);
      case(tr.cmd)
	RESET:reset();
        TRANSMIT:begin
	//vif.tx_frame = 1'b1;
          case(tr.tx_type)
            SEND_UNICAST:begin
		    vif.tx_frame = 1'b1;
	            send_unicast(tr.frame_control,tr.duration,tr.address1,tr.addeess2,tr.address3,tr.address4,tr.seq_control,tr.frame_body,tr.fcs);
	    	    wait_ack();
    	    end
	    SEND_BEACON:begin
		    vif.tx_frame = 1'b1;
		    send_beacon(tr.frame_control,tr.duration,tr.address1,tr.address2,tr.address3,tr.address4,tr.frame_body,tr.seq_control,tr.fcs);
	    end
	    SEND_AGGREGATE:begin
		    vif.tx_frame = 1'b1;
		    send_aggregate(tr.frame_control,tr.duration,tr.address1,tr.address2,tr.address3,tr.address4,tr.frame_body,tr.seq_control,tr.fcs);
		    wait_block_ack();
	    end
            default:`uvm_fatal("mac_driver","No valid command!")
          endcase
        RECEIVE:begin
	//vif.rx_frame = 1'b1;
          case(tr.rx_type)
	    UNICAST:begin
		    vif.rx_frame = 1'b1;
		    send_ack();
            end
	    AGGREGATE:begin
		    vif.rx_frame = 1'b1;
		    send_block_ack();
	    end
            default:@(vif.clk);
    	  endcase
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
  //task   : send
  //input  : n/a
  //output : n/a
  //descripton : send packet into interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send(input logic packet);
    int i = 0;
    int j = 0;

    always@(posedge vif.clk)//put packet into 32bit which used to driving vif.tx_data[31:0] 
	if((i<31)&&(j<PACKET_LEN))
	begin
		data_out[i]=data_tmp[j];
		i = i+1;
		j = j+1;
	end
	else if(i=31)
	begin
		vif.tx_data = data_out;//wait some signal?
		i = 0;
	end
	else if(j=PACKET_LEN)
	begin
		`uvm_info("mac_driver","packet has been send!",UVM_LOW)
		send_cmp = 1;
	end
  endtask:send

  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_ack
  //input  : n/a
  //output : n/a
  //descripton : send ack into interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send_ack();
	  logic [PACKET_LEN-1:0] data_tmp
	  ack_packet t_ack;
	  t_ack.agent_ack_packet(data_tmp);
	  send(data_tmp);
  endtask:send_ack

  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_block_ack
  //input  : n/a
  //output : n/a
  //descripton : send block ack into interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send_block_ack();
	  logic [PACKET_LEN-1:0] data_tmp
	  block_ack_packet t_block_ack;
	  t_block_ack.agent_block_ack_packet(data_tmp);
	  send(data_tmp);
  endtask:send_block_ack
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_unicast
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive unicast packet
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send_unicast(input logic [8:0] frame_control,input logic [47:0] address1,addeess2,address3,address4,input logic [15:0] seq_control,input logic [DATA_LEN-1:0] data_in,input [31:0] fcs);
    //mac_transaction tr;
    unicast_packet t_unicast;
    logic [PACKET_LEN-1:0] data_tmp;
    int send_cmp = 0;
    assign t_unicast.address1=address1;
    assign t_unicast.address2=address2;
    assign t_unicast.address3=address3;
    assign t_unicast.address4=address4;
    assign t_unicast.to_ds=frame_control.to_ds;//frame_control[6]
    assign t_unicast.from_ds=frame_control.from_ds;//frame_control[7]
    assign t_unicast.more_flag=frame_control.more_flag;
    assign t_unicast.retry=frame_control.retry;
    assign t_unicast.pwr_manage=frame_control.pwr_manage;
    assign t_unicast.more_data=frame_control.more_data;
    assign t_unicast.protect=frame_control.protect;
    assign t_unicast.order=frame_control.order;
    assign t_unicast.seq_control=seq_control;
    assign t_unicast.frame_body=data_in;
    assign t_unicast.fcs=fcs;
    t_unicast.agt_packet(data_tmp);
    send(data_tmp);
    `uvm_info("mac_driver","unicast packet has been send!",UVM_LOW)
  endtask: send_unicast
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_beacon
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive beacon packet
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task send_beacon(input logic [8:0] frame_control,,input logic [47:0] address1,[47:0] addeess2,[47:0] address3,[47:0] address4,input logic [15:0] seq_control,input logic [24:0] frame_body,input logic [31:0] fcs);
    //mac_transaction tr;
    beacon_packet t_beacon;
    logic [PACKET_LEN-1:0] data_tmp;
    int send_cmp = 0;

    assign t_beacon.address1=address1;
    assign t_beacon.address2=address2;
    assign t_beacon.address3=address3;
    assign t_beacon.address4=address4;
    assign t_beacon.to_ds=frame_control.to_ds;
    assign t_beacon.from_ds=frame_control.from_ds;
    assign t_beacon.more_flag=frame_control.more_flag;
    assign t_beacon.retry=frame_control.retry;
    assign t_beacon.pwr_manage=frame_control.pwr_manage;
    assign t_beacon.more_data=frame_control.more_data;
    assign t_beacon.protect=frame_control.protect;
    assign t_beacon.order=frame_control.order;
    assign t_beacon.seq_control=seq_control;
    assign t_beacon.Timestamp=frame_body.Timestamp;
    assign t_beacon.interval=frame_body.interval;
    assign t_beacon.SSID=frame_body.SSID;
    assign t_beacon.supported_rates=frame_body.supported_rates;
    assign t_beacon.FreHop=frame_body.FreHop;
    assign t_beacon.DS=frame_body.DS;
    assign t_beacon.FS=frame_body.FS;
    assign t_beacon.IBSS=frame_body.IBSS;
    assign t_beacon.TIM=frame_body.TIM;
    assign t_beacon.country=frame_body.country;
    assign t_beacon.FH=frame_body.FH;
    assign t_beacon.FH_Pattern=frame_body.FH_Pattern;
    assign t_beacon.power_constraint=frame_body.power_constraint;
    assign t_beacon.channel_switch=frame_body.channel_switch;
    assign t_beacon.quite=frame_body.quite;
    assign t_beacon.IBSS_DFS=frame_body.IBSS_DFS;
    assign t_beacon.TPC_report=frame_body.TPC_report;
    assign t_beacon.ERP_info=frame_body.ERP_info;
    assign t_beacon.extn_rate=frame_body.extn_rate;
    assign t_beacon.RSN=frame_body.RSN;
    assign t_beacon.BSS_load=frame_body.BSS_load;
    assign t_beacon.EDCA=frame_body.EDCA;
    assign t_beacon.QoS=frame_body.QoS;
    assign t_beacon.vendor_spec=frame_body.vendor_spec;
    assign t_beacon.fcs=fcs;
    t_beacon.agt_beacon_packet(data_tmp);
    send(data_tmp);
    `uvm_info("mac_driver","a beacon packet has been send!",UVM_LOW)
  endtask: send_beacon
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : send_aggregate
  //input  : addre1,address2,address3,address4,data
  //output : n/a
  //descripton : drive aggregate packet to interface
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : wait_ack
  //input  : n/a
  //output : n/a
  //descripton : wait ack
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task wait_ack();
	  logic [31:0] data_tmp;
	  while(vif.rx_frame!=1)@(posedge vif.clk);//wait rx frame
	  data_tmp=vif.rx_data;
	  if((data_tmp[3:2]=2'b01) && (data_tmp[7:4]=4'b1101))//type of ack
		  `uvm_info("mac_driver","ack is received!",UVM_LOW)
	  else
		  `uvm_fatal("mac_driver","ack is not received!") 
  endtask:wait_ack

  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  //task   : wait_block_ack
  //input  : n/a
  //output : n/a
  //descripton : wait block ack
  //TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
  task wait_block_ack();
	  logic [31:0] data_tmp;
	  while(vif.rx_frame!=1)@(posedge vif.clk);//wait rx frame
	  data_tmp=vif.rx_data;
	  if((data_tmp[3:2]=2'b01) && (data_tmp[7:4]=4'b1001))//type of block ack
		  `uvm_info("mac_driver","block ack is received!",UVM_LOW)
	  else
		  `uvm_fatal("mac_driver","block ack is not received!") 
  endtask:wait_block_ack

endclass: mac_drive
