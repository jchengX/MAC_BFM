class packet;
  bit command;
  bit std_packet;
  
  bit [15:0] frame_control;
  bit [15:0] duration;
  bit [47:0] address1;
  bit [47:0] address2;
  bit [47:0] address3;
  bit [15:0] seq_control;
  bit [47:0] address4;
  bit [DATA_LEN-1:0] frame_body;
  bit [31:0] fcs;
  
  bit [1:0] protocol=2'b00;
  bit [1:0] type;
  bit [3:0] sub_type;
  bit to_ds;
  bit from_ds;
  bit more_flag;
  bit retry;
  bit pwr_manage;
  bit more_data;
  bit protecet_frame;
  bit order;
  
  assign frame_control = {protocol,type,sub_type,to_ds,from_ds,more_flag,retry,pwr_manage,more_data,protecet_frame,order};
  assign std_packet = {frame_control,duration,address1,address2,address3,seq_control,address4,frame_body};
  
  function new();
    commad=0;
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
    
  task send();
    int data[i];
    
    
endclass    
    
