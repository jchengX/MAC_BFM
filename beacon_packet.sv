class beacon_packet extends packet;
	
  int DATA_LEN = 25;

  logic [PACKET_LEN-1:0] agt_beacon_packet;

  logic Timestamp;
  logic interval;
  logic SSID;
  logic supported_rates;
  logic FreHop;
  logic DS;
  logic FS;
  logic IBSS;
  logic TIM;
  logic country;
  logic FH;
  logic FH_Pattern;
  logic power_constraint;
  logic channel_switch;
  logic quite;
  logic IBSS_DFS;
  logic TPC_report;
  logic ERP_info;
  logic extn_rate;
  logic RSN;
  logic BSS_load;
  logic EDCA;
  logic QoS;
  logic vendor_spec;

  function new();
    type = 2'b00;
    sub_type = 4'b1000
    Timestamp = 0;
    interval = 0;
    SSID = 0;
    supported_rates = 0;
    FreHop = 0;
    DS = 0;
    FS = 0;
    IBSS = 0;
    TIM = 0;
    country = 0;
    FH = 0;
    FH_Pattern = 0;
    power_constraint = 0;
    channel_switch = 0;
    quite = 0;
    IBSS_DFS = 0;
    TPC_report = 0;
    ERP_info = 0;
    extn_rate = 0;
    RSN = 0;
    BSS_load = 0;
    EDCA = 0;
    QoS = 0;
    vendor_spec = 0;
  endfunction

  agent_packet(agt_beacon_packet);

  function agent_beacon_packet(output logic [PACKET_LEN-1:0] agt_beacon_packet);
    frame_body = {Timestamp,interval,SSID, supported_rates, FreHop, DS, FS,IBSS,TIM, country, FH, FH_Pattern, power_constraint, channel_switch,quite,IBSS_DFS, TPC_report, ERP_info, extn_rate, RSN, BSS_load, EDCA, QoS, vendor_spec};
    agent_packet(agt_beacon_packet);
  endfunction


  endclas
