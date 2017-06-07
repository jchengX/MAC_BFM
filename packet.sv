class packet;
  //logic command;
  logic [PACKET_LEN-1:0] agt_packet;
  
  logic [15:0] frame_control;
  logic [15:0] duration;
  logic [47:0] address1;
  logic [47:0] address2;
  logic [47:0] address3;
  logic [15:0] seq_control;
  logic [47:0] address4;
  logic [DATA_LEN-1:0] frame_body;
  logic [31:0] fcs;
  
  logic [1:0] protocol;
  logic [1:0] type;
  logic [3:0] sub_type;
  logic to_ds;
  logic from_ds;
  logic more_flag;
  logic retry;
  logic pwr_manage;
  logic more_data;
  logic protecet_frame;
  logic order;
  
  function new();
    protocol=0;
    type=0;
    sub_type=0;
    frame_control=16'h0000;
    duration=0;
    address1=0;
    address2=0;
    address3=0;
    seq_control=0;
    address4=0;
    frame_body=0;
    fcs=0;
  endfunction

  function agent_packet(output logic [PACKET_LEN-1:0] agt_packet);
    frame_control = {protocol,type,sub_type,to_ds,from_ds,more_flag,retry,pwr_manage,more_data,protecet_frame,order};
    agt_packet = {frame_control,duration,address1,address2,address3,seq_control,address4,frame_body};
  endfunction
  //task send();
    
endclass  
    
